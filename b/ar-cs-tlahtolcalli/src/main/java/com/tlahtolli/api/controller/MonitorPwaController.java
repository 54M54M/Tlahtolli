package com.tlahtolli.api.controller;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.zip.CRC32;

import javax.imageio.ImageIO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/**
 * Monitor instalable como app (Android / escritorio).
 *
 * Chrome ofrece "Instalar app" cuando la página enlaza un manifest con íconos de 192 y 512 px.
 * Todo vive en /monitor/assets/**, que SecurityConfig ya deja pasar sin sesión (Chrome los pide antes del login).
 *
 * Ícono: si existe src/main/resources/static/monitor/icon.png (propio, cuadrado y con su fondo), se usa ese a
 * tamaño completo. Si no, se toma el de Render (MONITOR_ICON_URL), se centra sobre el fondo del monitor.
 * En ambos casos se redimensiona a 192 y 512 px y se guarda en memoria.
 * Si Render no responde, se dibuja uno provisional y se vuelve a intentar en la siguiente petición.
 *
 * Las URLs de los íconos llevan ?v=<huella del ícono>: si cambias icon.png, cambia la URL y Chrome/Android
 * no reutilizan la imagen vieja de su caché (al reinstalar la app toman la nueva).
 */
@RestController
public class MonitorPwaController {

    private static final Logger log = LoggerFactory.getLogger(MonitorPwaController.class);
    private static final Color BACKGROUND = new Color(0x0e, 0x15, 0x17);
    private static final String OWN_ICON = "static/monitor/icon.png";

    private final String iconUrl;
    private final String iconVersion;
    private final Map<Integer, byte[]> cache = new ConcurrentHashMap<>();
    private final HttpClient http = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(5))
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    public MonitorPwaController(
            @Value("${MONITOR_ICON_URL:https://dashboard.render.com/favicon-light.png}") String iconUrl) {
        this.iconUrl = iconUrl;
        this.iconVersion = fingerprint(iconUrl);
    }

    /** Huella corta del ícono actual; la usan el manifest y las plantillas (${@monitorPwaController.iconVersion}). */
    public String getIconVersion() {
        return iconVersion;
    }

    private static String fingerprint(String iconUrl) {
        CRC32 crc = new CRC32();
        ClassPathResource own = new ClassPathResource(OWN_ICON);
        try (InputStream in = own.exists() ? own.getInputStream() : null) {
            if (in != null) crc.update(in.readAllBytes());
            else crc.update(iconUrl.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        } catch (IOException e) {
            crc.update(iconUrl.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        }
        return Long.toHexString(crc.getValue());
    }

    @GetMapping(value = "/monitor/assets/manifest.webmanifest", produces = "application/manifest+json")
    public ResponseEntity<String> manifest() {
        String v = iconVersion;
        String json = """
            {
              "name": "Tlahtolcalli Monitor",
              "short_name": "Monitor",
              "description": "Panel de administración de Tlahtolcalli",
              "id": "/monitor",
              "start_url": "/monitor",
              "scope": "/monitor",
              "display": "standalone",
              "background_color": "#000000",
              "theme_color": "#000000",
              "icons": [
                { "src": "/monitor/assets/icon-192.png?v=%1$s", "sizes": "192x192", "type": "image/png", "purpose": "any" },
                { "src": "/monitor/assets/icon-512.png?v=%1$s", "sizes": "512x512", "type": "image/png", "purpose": "any" },
                { "src": "/monitor/assets/icon-192.png?v=%1$s", "sizes": "192x192", "type": "image/png", "purpose": "maskable" },
                { "src": "/monitor/assets/icon-512.png?v=%1$s", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
              ]
            }
            """.formatted(v);
        return ResponseEntity.ok().cacheControl(CacheControl.noCache()).body(json);
    }

    @GetMapping(value = "/monitor/assets/icon-{size}.png", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> icon(@PathVariable int size) {
        if (size != 192 && size != 512) return ResponseEntity.notFound().build();

        byte[] cached = cache.get(size);
        if (cached != null) return png(cached, Duration.ofDays(1));

        BufferedImage own = loadOwn();
        BufferedImage source = own != null ? own : loadRemote();
        if (source != null) {
            byte[] bytes = encode(own != null ? scale(own, size) : compose(source, size));
            if (bytes != null) {
                cache.put(size, bytes);
                return png(bytes, Duration.ofDays(1));
            }
        }
        // Provisional (no se guarda: se reintenta con el ícono real en la siguiente petición)
        byte[] fallback = encode(placeholder(size));
        return fallback == null ? ResponseEntity.internalServerError().build() : png(fallback, Duration.ofMinutes(5));
    }

    private static ResponseEntity<byte[]> png(byte[] bytes, Duration maxAge) {
        return ResponseEntity.ok().cacheControl(CacheControl.maxAge(maxAge)).contentType(MediaType.IMAGE_PNG).body(bytes);
    }

    /** Ícono propio del classpath (static/monitor/icon.png), si existe. */
    private static BufferedImage loadOwn() {
        ClassPathResource own = new ClassPathResource(OWN_ICON);
        if (!own.exists()) return null;
        try (InputStream in = own.getInputStream()) {
            return ImageIO.read(in);
        } catch (IOException e) {
            log.warn("[monitor] no se pudo leer {}: {}", OWN_ICON, e.getMessage());
            return null;
        }
    }

    /** Favicon de Render (MONITOR_ICON_URL). */
    private BufferedImage loadRemote() {
        try {
            HttpResponse<byte[]> res = http.send(
                    HttpRequest.newBuilder(URI.create(iconUrl)).timeout(Duration.ofSeconds(8)).GET().build(),
                    HttpResponse.BodyHandlers.ofByteArray());
            if (res.statusCode() == 200) {
                BufferedImage img = ImageIO.read(new ByteArrayInputStream(res.body()));
                if (img != null) return img;
            }
            log.warn("[monitor] ícono {} respondió {}", iconUrl, res.statusCode());
        } catch (Exception e) {
            log.warn("[monitor] no se pudo descargar el ícono {}: {}", iconUrl, e.getMessage());
        }
        return null;
    }

    /** Ícono propio a tamaño completo (ya trae su fondo y sus márgenes). */
    private static BufferedImage scale(BufferedImage src, int size) {
        BufferedImage out = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = out.createGraphics();
        try {
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g.drawImage(src, 0, 0, size, size, null);
        } finally {
            g.dispose();
        }
        return out;
    }

    /** Fondo del monitor con el ícono centrado al 70 % (margen para las máscaras redondas de Android). */
    private static BufferedImage compose(BufferedImage src, int size) {
        BufferedImage out = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = out.createGraphics();
        try {
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g.setColor(BACKGROUND);
            g.fillRect(0, 0, size, size);
            double box = size * 0.70;
            double scale = Math.min(box / src.getWidth(), box / src.getHeight());
            int w = (int) Math.round(src.getWidth() * scale);
            int h = (int) Math.round(src.getHeight() * scale);
            g.drawImage(src, (size - w) / 2, (size - h) / 2, w, h, null);
        } finally {
            g.dispose();
        }
        return out;
    }

    /** Círculo jade sobre el fondo del monitor, por si no hay ícono disponible (sin fuentes: el contenedor puede no tenerlas). */
    private static BufferedImage placeholder(int size) {
        BufferedImage out = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g = out.createGraphics();
        try {
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g.setColor(BACKGROUND);
            g.fillRect(0, 0, size, size);
            g.setColor(new Color(0x00, 0xC8, 0x96));
            int d = (int) (size * 0.5);
            g.fillOval((size - d) / 2, (size - d) / 2, d, d);
        } finally {
            g.dispose();
        }
        return out;
    }

    private static byte[] encode(BufferedImage img) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            return ImageIO.write(img, "png", out) ? out.toByteArray() : null;
        } catch (IOException e) {
            return null;
        }
    }
}
