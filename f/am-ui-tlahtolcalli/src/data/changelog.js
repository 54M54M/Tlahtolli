// Novedades para las personas que usan la app (/novedades).
// Escrito para usuarios, no para desarrolladores: qué cambió y qué significa para ellos.
// El detalle técnico de cada versión está en /doc/changelog.
//
// Para agregar una versión: ponla AL INICIO del arreglo.
//   version: '4.1.0' (o null si no tuvo número) · date: 'AAAA-MM-DD' o 'AAAA-MM'
//   type: 'nuevo' | 'mejora' | 'correccion'
export const CHANGELOG = [
    {
        version: '4.6.2',
        date: '2026-11-25',
        title: 'Pistas con desglose',
        items: [
            { type: 'nuevo', text: '«Cómo se usa» ahora tiene su propia página, paso a paso.' },
            { type: 'mejora', text: 'Estadísticas de aprendizaje más claras: cada indicador dice qué cuenta.' },
            { type: 'nuevo', text: 'Nuevo ejercicio «Selecciona los pares»: une cada palabra con su traducción.' },
            { type: 'nuevo', text: 'Al tocar una palabra subrayada ves su pronunciación y, si la tiene, cada parte de la palabra con su significado.' },
            { type: 'mejora', text: 'Los botones con relieve se aplican en toda la app, desde la página de inicio.' },
            { type: 'mejora', text: 'Si la frase es pregunta, todas las opciones llevan signo de pregunta; si no, ninguna.' },
            { type: 'mejora', text: 'Fichas más grandes en el teléfono y frases más claras para armar ("el nombre de él/ella").' },
            { type: 'mejora', text: 'El botón Verificar sube con el teclado y ya no salen sugerencias del corrector al escribir.' },
            { type: 'correccion', text: 'Las unidades terminadas ya no se marcan como la unidad actual.' },
        ],
    },
    {
        version: '4.6.1',
        date: '2026-11-24',
        title: 'Botones a tu gusto',
        items: [
            { type: 'mejora', text: 'Los ejercicios de opción múltiple siempre tienen 4 opciones, y las preguntas salen todas con signo o todas sin él.' },
            { type: 'mejora', text: 'Las opciones y las fichas tienen el mismo diseño en toda la app.' },
            { type: 'nuevo', text: 'En Perfil → Ajustes puedes elegir botones con relieve o planos.' },
        ],
    },
    {
        version: '4.6.0',
        date: '2026-11-24',
        title: 'Lecciones que te ayudan a recordar',
        items: [
            { type: 'nuevo', text: 'Las palabras nuevas se presentan primero ("Palabra nueva") y vuelven a aparecer en la misma lección para que las reconozcas.' },
            { type: 'nuevo', text: 'Arma frases con fichas: toca las palabras en orden para traducir.' },
            { type: 'nuevo', text: 'Repaso: cada lección trae palabras de unidades anteriores.' },
            { type: 'mejora', text: 'Lo que respondes mal se repite al final de la lección ("Error anterior").' },
        ],
    },
    {
        version: '4.5.0',
        date: '2026-11-22',
        title: 'Tu racha cuenta',
        items: [
            { type: 'nuevo', text: 'Racha de días: cuántos días seguidos llevas estudiando, en tu perfil y en tus estadísticas, junto con tu mejor racha. El fuego cambia de color: rojo desde 50 días, morado desde 200 y azul desde 500.' },
            { type: 'correccion', text: '"Días estudiados" ahora cuenta días distintos (antes sumaba uno por lección).' },
            { type: 'mejora', text: 'Al restablecer tu contraseña se cierra tu sesión en todos tus dispositivos.' },
            { type: 'mejora', text: 'Las frases largas en los diálogos de las lecciones ahora se acomodan bien en pantallas pequeñas.' },
            { type: 'nuevo', text: 'Puedes ver la versión de la app en Perfil → Ajustes.' },
            { type: 'correccion', text: 'El encabezado de inicio queda centrado en todos los teléfonos y el glosario ya no muestra un recuadro vacío.' },
            { type: 'mejora', text: 'Al cambiar de idioma, "Continuar" solo se activa si eliges uno distinto al actual.' },
        ],
    },
    {
        version: '4.4.0',
        date: '2026-11-22',
        title: 'Sigue aprendiendo sin internet',
        items: [
            { type: 'nuevo', text: 'Si se va el internet a media lección, puedes terminarla: tu avance se guarda en tu dispositivo y se envía solo cuando vuelve la conexión.' },
            { type: 'mejora', text: 'Sin conexión puedes seguir viendo lo que ya habías abierto (inicio, niveles, lecciones). El aviso de "Sin conexión" solo tapa la pantalla si esa sección nunca se había cargado.' },
            { type: 'correccion', text: 'Las lecciones cuentan en el día correcto (hora de México), también las que terminaste sin conexión.' },
        ],
    },
    {
        version: '4.3.0',
        date: '2026-11-22',
        title: 'Instálala como app',
        items: [
            { type: 'nuevo', text: 'Instala Tlahtolcalli en tu teléfono o computadora: abre al instante, sin la barra del navegador.' },
            { type: 'nuevo', text: 'Si te quedas sin internet, la app te avisa en lugar de mostrar un error del navegador.' },
            { type: 'nuevo', text: 'Cuando hay una versión nueva, la app te avisa para actualizar (nunca a media lección).' },
            { type: 'mejora', text: 'Al mantener presionado el ícono: accesos directos a continuar, glosario y estadísticas.' },
        ],
    },
    {
        version: '4.2.0',
        date: '2026-11-21',
        title: 'Recupera tu cuenta y lección de bienvenida',
        items: [
            { type: 'nuevo', text: '¿Olvidaste tu contraseña? Pide un enlace con tu usuario o tu correo y crea una nueva.' },
            { type: 'nuevo', text: 'Al elegir un idioma nuevo, una lección de bienvenida de 5 preguntas te muestra cómo funcionan las lecciones. No gasta energía.' },
            { type: 'mejora', text: 'Si intentas registrarte con un usuario o correo que ya tiene cuenta, la app te ofrece recuperar tu contraseña.' },
        ],
    },
    {
        version: '4.1.1',
        date: '2026-11-21',
        title: 'Guía de uso y origen del contenido',
        items: [
            { type: 'nuevo', text: 'La portada explica paso a paso cómo usar la app, con capturas de cada pantalla.' },
            { type: 'mejora', text: 'Aclaramos de dónde viene el contenido: los cursos se crearon a partir de investigación en fuentes publicadas; el de náhuatl incorpora los comentarios de un hablante y ninguno tiene todavía una revisión completa de hablantes nativos.' },
        ],
    },
    {
        version: '4.0.2',
        date: '2026-11-18',
        title: 'Direcciones más limpias',
        items: [
            { type: 'mejora', text: 'La dirección de niveles y lecciones muestra tu idioma (por ejemplo /app/leccion/nhn) en lugar de un número.' },
            { type: 'mejora', text: 'Si abres esa dirección desde un marcador o un enlace, te lleva a tu nivel o lección en curso.' },
            { type: 'nuevo', text: 'La portada explica qué significa Tlahtolcalli y las otras formas de escribirlo.' },
        ],
    },
    {
        version: '4.0.1',
        date: '2026-11-18',
        title: 'Ajustes después del cambio',
        items: [
            { type: 'correccion', text: 'El botón Volver de los niveles y del glosario regresa al inicio de la app, no a la portada.' },
            { type: 'correccion', text: 'Los niveles y lecciones bloqueados ya no se abren escribiendo su dirección: hay que desbloquearlos primero.' },
            { type: 'mejora', text: 'La portada muestra pantallas reales de los cursos de náhuatl central y tének.' },
        ],
    },
    {
        version: '4.0.0',
        date: '2026-11-18',
        title: 'Una sola casa para Tlahtolcalli',
        items: [
            { type: 'nuevo', text: 'La página con toda la información del proyecto ahora es la portada de la app.' },
            { type: 'nuevo', text: 'Inicia sesión o crea tu cuenta desde una ventana sobre la portada, sin cambiar de página.' },
            { type: 'nuevo', text: 'Esta página de novedades, para que sepas qué cambia en cada versión.' },
            { type: 'nuevo', text: 'Aviso de privacidad y términos del servicio.' },
            { type: 'mejora', text: 'La app vive ahora en /app. Los enlaces anteriores siguen funcionando.' },
            { type: 'mejora', text: 'Fuera de las lecciones ya no aparece el aviso de “recargar el sitio”.' },
        ],
    },
    {
        version: '3.9.0',
        date: '2026-11-17',
        title: 'Entra con Google',
        items: [
            { type: 'nuevo', text: 'Inicia sesión o regístrate con tu cuenta de Google.' },
            { type: 'nuevo', text: 'Si entras con Google por primera vez, eliges tu nombre de usuario antes de empezar.' },
            { type: 'nuevo', text: 'Las cuentas creadas con Google pueden crear una contraseña desde Editar perfil.' },
        ],
    },
    {
        version: '3.8.0',
        date: '2026-11-17',
        title: 'Verificación de correo y perfil completo',
        items: [
            { type: 'nuevo', text: 'Verifica tu correo con un enlace. Si no lo has hecho, la app te lo recuerda y puedes reenviarlo.' },
            { type: 'nuevo', text: 'Editar perfil: cambia tu nombre, tu usuario, tu contraseña y tu correo, o elimina tu cuenta.' },
            { type: 'mejora', text: 'Cambiar de correo pide confirmar el nuevo y avisa al anterior.' },
            { type: 'mejora', text: 'Puedes cambiar tu nombre de usuario una vez cada 30 días.' },
            { type: 'mejora', text: 'Las contraseñas nuevas deben tener al menos 8 caracteres.' },
        ],
    },
    {
        version: '3.7.0',
        date: '2026-11',
        title: 'Cuentas más seguras',
        items: [
            { type: 'mejora', text: 'Tu sesión usa un token que vence: cada persona solo puede ver y modificar sus propios datos.' },
            { type: 'mejora', text: 'Los cursos cargan más rápido.' },
        ],
    },
    {
        version: '3.6.0',
        date: '2026-11',
        title: 'Náhuatl central y tének',
        items: [
            { type: 'nuevo', text: 'Curso completo de náhuatl central (nhn) con ortografía moderna y macrones para las vocales largas.' },
            { type: 'nuevo', text: 'Curso completo de tének de San Luis Potosí (hus), con la norma de escritura del INALI.' },
            { type: 'nuevo', text: 'Sistema de escritura de cada lengua en el glosario, con ejemplos del curso.' },
            { type: 'mejora', text: 'Ya no hay idioma por defecto: al crear tu cuenta eliges qué lengua aprender.' },
            { type: 'correccion', text: 'Los logros muestran su nombre e ícono correctos.' },
        ],
    },
    {
        version: null,
        date: '2026-04',
        title: 'Tu avance, guardado en el servidor',
        items: [
            { type: 'nuevo', text: 'Tu cuenta, tu progreso y tus logros se guardan en el servidor, no solo en tu navegador.' },
            { type: 'mejora', text: 'Cambia de idioma desde el encabezado sin recargar la página.' },
        ],
    },
    {
        version: '3.5.0',
        date: '2025-12-17',
        title: 'Energía en toda la app',
        items: [
            { type: 'nuevo', text: 'La energía se mantiene igual en toda la app y se recupera con el tiempo.' },
            { type: 'nuevo', text: 'Aviso cuando no tienes energía suficiente para empezar o cuando se te acaba a media lección.' },
            { type: 'correccion', text: 'El cronómetro de la lección ya no falla cuando se acaba la energía.' },
        ],
    },
    {
        version: '3.4.0',
        date: '2025-12-11',
        title: 'Nuevo selector de idioma',
        items: [
            { type: 'mejora', text: 'Selector de idioma rediseñado, agrupado por familia lingüística.' },
            { type: 'correccion', text: 'Arreglos de diseño en teléfonos.' },
        ],
    },
    {
        version: '3.3.0',
        date: '2025-11-25',
        title: 'Personajes en los ejercicios',
        items: [
            { type: 'nuevo', text: 'Personajes ilustrados acompañan los ejercicios.' },
            { type: 'mejora', text: 'Mensaje al terminar una unidad y desbloqueo de niveles más claros.' },
            { type: 'mejora', text: 'Más vocabulario.' },
        ],
    },
    {
        version: '3.2.0',
        date: '2025-11-15',
        title: 'Lecciones renovadas',
        items: [
            { type: 'nuevo', text: 'Pronunciación al pasar el cursor o tocar las palabras clave.' },
            { type: 'nuevo', text: 'Paso directo al siguiente nivel al terminar.' },
            { type: 'mejora', text: 'Ejercicios del nivel 6 y vocabulario ampliado.' },
        ],
    },
    {
        version: '3.0.0',
        date: '2025-11-08',
        title: 'La app por dentro, de nuevo',
        items: [
            { type: 'mejora', text: 'Reestructuración completa de la app para crecer a más lenguas.' },
        ],
    },
    {
        version: '2.0.0',
        date: '2025-10-17',
        title: 'Estadísticas',
        items: [
            { type: 'nuevo', text: 'Vista de estadísticas: palabras aprendidas, lecciones perfectas y días de estudio.' },
            { type: 'mejora', text: 'Pantallas de carga y mejoras en la interfaz.' },
        ],
    },
    {
        version: '1.3.0',
        date: '2025-10-16',
        title: 'Identidad visual y glosario',
        items: [
            { type: 'nuevo', text: 'Identidad visual de Tlahtolcalli.' },
            { type: 'nuevo', text: 'Glosario con diccionario y sistema de escritura.' },
        ],
    },
    {
        version: '1.0.0',
        date: '2025-04-28',
        title: 'Primera versión',
        items: [
            { type: 'nuevo', text: 'Niveles, unidades y lecciones con ejercicios.' },
            { type: 'nuevo', text: 'Perfil, progreso y logros.' },
            { type: 'nuevo', text: 'Navegación para teléfono y computadora.' },
        ],
    },
]

const MONTHS = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre']

/** '2026-11-18' → '18 de noviembre de 2026' · '2026-11' → 'noviembre de 2026' */
export function formatChangelogDate(d) {
    const [y, m, day] = d.split('-').map(Number)
    return day ? `${day} de ${MONTHS[m - 1]} de ${y}` : `${MONTHS[m - 1]} de ${y}`
}
