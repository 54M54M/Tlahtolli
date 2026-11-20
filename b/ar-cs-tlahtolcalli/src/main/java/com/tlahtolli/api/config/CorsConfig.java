package com.tlahtolli.api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Orígenes que pueden llamar a la API desde el navegador: producción, desarrollo y local.
 * En Render se pueden cambiar con la variable CORS_ORIGINS (separados por coma, admite comodines:
 * https://*--tlahtolcalli.netlify.app para las vistas previas de Netlify).
 */
@Configuration
public class CorsConfig implements WebMvcConfigurer {

	@Value("${CORS_ORIGINS:https://tlahtolcalli.netlify.app,https://dev-tlahtolcalli.netlify.app}")
	private String[] origins;

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		String[] patterns = new String[origins.length + 2];
		for (int i = 0; i < origins.length; i++) patterns[i] = origins[i].trim();
		patterns[origins.length] = "http://localhost:*";       // Vite: 5173, 4173...
		patterns[origins.length + 1] = "http://127.0.0.1:*";
		registry.addMapping("/api/**")
				.allowedOriginPatterns(patterns)
				.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH")
				.allowedHeaders("*")
				.allowCredentials(false)
				.maxAge(3600);
	}
}
