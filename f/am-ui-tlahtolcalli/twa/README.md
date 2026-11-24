# App de Android (TWA)

Empaqueta la PWA de prod (`tlahtolcalli.netlify.app`) como app de Android con
[Bubblewrap](https://github.com/GoogleChromeLabs/bubblewrap). La app abre el sitio en Chrome sin barra
de dirección: el contenido es el mismo que la web, así que **las actualizaciones de la web no requieren
un APK nuevo**. Solo hace falta empaquetar otra vez si cambian el nombre, los íconos, los colores o
si quieres que Android muestre la versión nueva.

## Requisitos (una sola vez)

- Node 18+ y `npm i -g @bubblewrap/cli`
- La primera vez Bubblewrap ofrece descargar el JDK 17 y el Android SDK: acepta.

## Primera vez

```bash
cd f/am-ui-tlahtolcalli
npm run twa:version          # copia la versión de package.json a twa/twa-manifest.json
cd twa
bubblewrap update            # genera el proyecto Android a partir de twa-manifest.json
bubblewrap build             # pide crear la llave (android.keystore): guarda bien sus contraseñas
bubblewrap fingerprint list  # muestra la huella SHA-256 de la llave
```

1. En Netlify (sitio **prod**) agrega `TWA_SHA256_FINGERPRINTS` con esa huella y vuelve a desplegar.
   Revisa que abra `https://tlahtolcalli.netlify.app/.well-known/assetlinks.json`.
2. Instala `app-release-signed.apk` en el teléfono (cópialo o `adb install app-release-signed.apk`).
   Si se abre sin barra de dirección, la verificación funcionó.

## Versiones siguientes

```bash
npm run twa:version && cd twa && bubblewrap update && bubblewrap build
```

`appVersionCode` sale de la versión (4.5.0 → 40500) y siempre debe subir; el script no deja bajarlo.

## No subir al repo

`android.keystore` (la llave: si se pierde, no se puede actualizar la app instalada ni la de Play Store),
los `.apk`/`.aab` y el proyecto Android generado ya están en `.gitignore`. Guarda la llave y sus
contraseñas fuera del repo (por ejemplo en tu gestor de contraseñas).

## Google Play (opcional)

Sube `app-release-bundle.aab`. Play vuelve a firmar con su propia llave: copia la huella de
*Configuración → Integridad de la app → Firma de apps* y agrégala a `TWA_SHA256_FINGERPRINTS`
(separada por coma). El `packageId` (`app.netlify.tlahtolcalli.twa`) **no se puede cambiar** una vez
publicada la app.
