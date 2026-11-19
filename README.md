# 🌐 Tlahtolli

Plataforma web de aprendizaje de lenguas originarias que utiliza un enfoque gamificado para hacer que el aprendizaje sea interactivo, divertido y culturalmente contextualizado. Ofrece cursos estructurados en niveles con lecciones cortas, ejercicios variados y un sistema de progresión que motiva el estudio constante.

## ✨ Características principales

### 🎓 Sistema de aprendizaje estructurado

- **Niveles progresivos**: Contenido organizado en 6 niveles, cada uno con 6 unidades temáticas (y 6 ejercicios por ahora)
- **Lecciones cortas**: Sesiones de 10-15 minutos diseñadas para el aprendizaje efectivo
- **Ejercicios variados**: Múltiple opción y completar espacios
- **Nivel Rápido**: Opción para desbloquear niveles completos demostrando conocimientos previos

### 🎮 Gamificación y progreso

- **Sistema de energía**: Mecánica de juego que recompensa el estudio constante y la precisión
- **Sistema de rachas**: Bonificaciones por respuestas correctas consecutivas
- **Logros desbloqueables**: Reconocimientos por hitos alcanzados en el aprendizaje
- **Experiencia y niveles**: Sistema de XP que refleja el progreso del usuario
- **Estadísticas detalladas**: Conteo de palabras aprendidas, lecciones perfectas y días estudiados

### 📚 Contenido didáctico completo

- **Vocabulario contextualizado**: Palabras y frases con pronunciación, traducción y ejemplos de uso
- **Tooltips interactivos**: Información de pronunciación al pasar el cursor sobre palabras clave
- **Sistema de escritura integrado**: Se usa el alfabeto latino, con diferentes normas según la lengua y su variante dialectal

### 🌍 Lenguas disponibles

- **Náhuatl Central** (nhce) - Variante en demo, usada para probar las funcionalidaees de la plataforna
- **Familia linguistica Uto-Azteca** (Clasico, Central, de la Huateca, de la Sierra de Puebla, de Guerrero, entre otros) - En desarrollo
- **Familia linguistica Maya** (Maya yucateco, Huasteco/Teenek, Tzotzil, Tzetzal, Mamm, entre otras) - En desarrollo

### 💾 Persistencia y almacenamiento

- **Progreso local**: Todo el avance se guarda automáticamente en el navegador, se esta trabajando para la informacion sea persistente
- **Sin necesidad de conexión constante**: Una vez cargado, funciona offline

### 🎨 Interfaz adaptativa

- **Diseño responsive**: Optimizado para móvil y desktop
- **Tema oscuro**: Interfaz diseñada para reducir fatiga visual
- **Navegación intuitiva**: Estructura clara con sidebar en desktop y barra inferior en móvil
- **Componentes reutilizables**: Experiencia consistente en toda la plataforma

## 🛠️ Tecnologías utilizadas

### Frontend

- **Vue 3** - Framework progresivo de JavaScript
- **Vue Router** - Navegación SPA
- **Pinia** - Gestión de estado global
- **Tailwind CSS** - Framework de utilidades CSS

### Arquitectura

- **Patrón Repository**: Separación clara de lógica de datos
- **Servicios especializados**:
  - `ProgressService` - Gestión de progreso del usuario
  - `AchievementService` - Sistema de logros
  - `EnergyService` - Mecánica de energía
  - `QuickLevelService` - Lógica de nivel rápido
  - `SpeechService` - Síntesis de voz
  - `LanguageService` - Información de idiomas
- **LocalStorage**: Persistencia de datos en el navegador
- **Componentes modulares**: Estructura organizada y mantenible

## 📖 Estructura del repositorio

```
├── f/                         Frontend (Vue 3 + Vite) · Netlify: tlahtolcalli.netlify.app
│   ├── public/                Íconos, imagen de la portada, robots.txt, sitemap.xml
│   ├── scripts/prerender.mjs  Genera el HTML de las páginas públicas al compilar
│   └── src/
│       ├── views/public/      Portada (/), novedades, privacidad y términos
│       ├── components/public/ Encabezado y pie públicos, modal de inicio de sesión
│       ├── views/             Vistas de la app (/app/…)
│       ├── data/changelog.js  Novedades que ven los usuarios en /novedades
│       ├── router/            Rutas públicas (publicRoutes.js) y de la app (index.js)
│       └── entry-prerender.js Entrada del prerender
├── b/ar-cs-tlahtolcalli/      Backend (Spring Boot 3 · Java 21) · Render, con el monitor en /monitor
├── doc/                       Documentación: changelogs técnicos, despliegue, notas y recursos
└── _redirects                 Redirige el sitio anterior de la landing (totlahtol) a la app
```

### Rutas

| Ruta | Qué es | Sesión |
|---|---|---|
| `/` | Portada | Con o sin sesión |
| `/?auth=login` · `/?auth=register` | Modal para iniciar sesión o crear cuenta | Sin sesión |
| `/novedades` · `/privacidad` · `/terminos` | Páginas públicas | Con o sin sesión |
| `/verificar` | Enlace del correo de verificación | Con o sin sesión |
| `/app/…` | La app | Requiere sesión |

Las rutas anteriores (`/login`, `/perfil`, `/glosario`, …) redirigen a las nuevas.

### Compilar

```
cd f
npm install
npm run build        # vite build + prerender de las páginas públicas
npm run build:spa    # solo vite build, sin prerender
```

La documentación está en [`/doc`](doc/README.md).

## 🎯 Flujo de usuario

1. **Inicio de sesión**: Usuario demo para probar la plataforma
2. **Selección de idioma**: Elegir entre lenguas disponibles
3. **Niveles**: Acceder a niveles desbloqueados
4. **Unidades**: Completar unidades desbloqueadas dentro de cada nivel
5. **Lecciones**: Resolver ejercicios interactivos
6. **Progreso**: Desbloquear logros y avanzar en la plataforma
7. **Nivel Rápido**: Opción para saltar niveles demostrando conocimiento

## 🔧 Características técnicas destacadas

### Sistema de energía

- Consumo de 1 punto por ejercicio
- Recuperación de +1-2 puntos por acierto
- Bonificación de +3-4 puntos por racha de 3+ aciertos
- Regeneración automática: 1 punto cada 20 minutos

### Sistema de logros

- Verificación automática de requisitos
- Recompensas de XP por desbloqueo
- Seguimiento de progreso hacia logros
- Categorías: general, dedicación, vocabulario, cultura, rendimiento

### Procesamiento de texto inteligente

- Detección automática de palabras del vocabulario
- Tooltips con pronunciación y traducción
- Resaltado de palabras importantes
- Soporte para múltiples dialectos

### Prevención de pérdida de progreso

- Confirmación antes de salir de lecciones
- Prevención de recarga accidental
- Guardado automático de progreso
- Advertencias de energía baja

## 🧩 Próximas funcionalidades

- [ ] Más lenguas y variantes dialectales
- [ ] Sistema de práctica para recuperar energía
- [ ] Ejercicios de audio y pronunciación
- [ ] Modo de repaso inteligente
- [ ] Sistema de amigos y competencia
- [ ] Certificados de completación
- [ ] Contenido cultural expandido
- [ ] Integración con API de voz nativa
- [ ] Modo oscuro/claro personalizable

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si deseas colaborar:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Áreas donde puedes contribuir

- 📝 Contenido educativo (nuevos ejercicios, vocabulario)
- 🎨 Diseño y UX/UI
- 🐛 Reportes de bugs y correcciones
- 🌐 Traducciones y contenido para nuevas lenguas
- 📚 Documentación
- ⚡ Optimizaciones de rendimiento

## 📄 Licencia

- Este proyecto está bajo la **Licencia Creative Commons BY-NC-ND 4.0**

```
  /$$$$$$    /$$$$$$   /$$      /$$   /$$$$$$    /$$$$$$   /$$      /$$
 /$$__  $$  /$$__  $$ | $$$    /$$$  /$$__  $$  /$$__  $$ | $$$    /$$$
| $$  \__/ | $$  \ $$ | $$$$  /$$$$ | $$  \__/ | $$  \ $$ | $$$$  /$$$$
|  $$$$$$  | $$$$$$$$ | $$ $$/$$ $$ |  $$$$$$  | $$$$$$$$ | $$ $$/$$ $$
 \____  $$ | $$__  $$ | $$  $$$| $$  \____  $$ | $$__  $$ | $$  $$$| $$
 /$$  \ $$ | $$  | $$ | $$\  $ | $$  /$$  \ $$ | $$  | $$ | $$\  $ | $$
|  $$$$$$/ | $$  | $$ | $$ \/  | $$ |  $$$$$$/ | $$  | $$ | $$ \/  | $$
 \______/  |__/  |__/ |__/     |__/  \______/  |__/  |__/ |__/     |__/
```

- Ver el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- A las comunidades de hablantes de lenguas originarias
- A los lingüistas y educadores que preservan estas lenguas
- A todos los que contribuyen a hacer el aprendizaje accesible

---

Desarrollado con ❤️ para promover, preservar y revitalizar las lenguas originarias de México y América Latina.

**Nota**: Este proyecto es educativo y está en desarrollo activo. El contenido se expande constantemente gracias a la comunidad.
