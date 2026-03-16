package com.tlahtolli.api.config;
 
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;
 
@Configuration
public class CorsConfig implements WebMvcConfigurer {    
    @Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/api/**")
				// allowedOriginPatterns en lugar de allowedOrigins("*")
				// — permite usar allowCredentials si se agrega auth después
				.allowedOriginPatterns("http://localhost:*", // Vite: 5173, 3000, 4173...
									   "http://127.0.0.1:*")
				.allowedOrigins("*")
				.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH").allowedHeaders("*")
				.allowCredentials(false).maxAge(3600);
	}
}