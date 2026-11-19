<template>
    <DocPage title="Aviso de privacidad" updated="18 de noviembre de 2026">
        <template #intro>
            <p><strong>En corto:</strong> guardamos lo mínimo para que tengas una cuenta y no pierdas tu avance.
                No vendemos tus datos, no mostramos publicidad y no usamos rastreadores de terceros en la app.
                Puedes borrar tu cuenta y todos sus datos cuando quieras desde la app.</p>
        </template>

        <h2 id="responsable">1. Quién es responsable de tus datos</h2>
        <p><strong>Tlahtolcalli</strong> es un proyecto independiente y gratuito para aprender lenguas originarias de México.
            Es responsable del tratamiento de los datos que se describen aquí. Para cualquier asunto de privacidad
            escríbenos a <a class="lnk" :href="`mailto:${MAIL}`">{{ MAIL }}</a>.</p>

        <h2 id="datos">2. Qué datos guardamos</h2>
        <h3>Datos de tu cuenta</h3>
        <ul class="list">
            <li>Nombre de usuario, nombre completo y correo electrónico.</li>
            <li>Tu contraseña, guardada solo de forma cifrada (hash bcrypt): nadie puede leerla, ni nosotros.</li>
            <li>Si el correo está verificado, la fecha de verificación y, si pediste cambiarlo, el correo nuevo pendiente.</li>
            <li>Fecha de registro y fecha del último cambio de nombre de usuario.</li>
        </ul>
        <h3>Si entras con Google</h3>
        <p>Recibimos de Google solo tu <strong>nombre, correo, si el correo está verificado y un identificador de tu
            cuenta de Google</strong>. Con eso creamos o vinculamos tu cuenta. No recibimos tu contraseña de Google ni
            accedemos a tus contactos, archivos, correos ni ningún otro dato de tu cuenta de Google.</p>
        <h3>Tu aprendizaje</h3>
        <ul class="list">
            <li>Idioma que estudias, unidades completadas, historial de lecciones (fecha, aciertos, tiempo y XP).</li>
            <li>XP, nivel, racha, energía, logros y estadísticas por idioma.</li>
        </ul>
        <h3>En tu navegador</h3>
        <p>La app guarda en el almacenamiento local de tu navegador tu sesión (un token que vence) y el idioma elegido,
            para que no tengas que iniciar sesión cada vez. <strong>La app no usa cookies de publicidad ni de
            analítica.</strong> Al cerrar sesión se borran.</p>
        <h3>Datos técnicos</h3>
        <p>Como cualquier sitio web, los servidores donde vive la app registran datos técnicos de las peticiones
            (por ejemplo, dirección IP, fecha y página solicitada) para operar y proteger el servicio. Además, contamos
            cuántas peticiones recibe cada sección de la app y cuánto tardan, sin asociarlo a personas.</p>

        <h2 id="finalidades">3. Para qué los usamos</h2>
        <ul class="list">
            <li>Crear y proteger tu cuenta, y dejarte iniciar sesión (con contraseña o con Google).</li>
            <li>Guardar tu progreso, rachas y logros, y mostrártelos.</li>
            <li>Enviarte correos <strong>necesarios para tu cuenta</strong>: verificar tu correo y avisarte si alguien
                cambia el correo de tu cuenta. No enviamos publicidad.</li>
            <li>Mantener el servicio funcionando, encontrar errores y prevenir abusos.</li>
        </ul>
        <p>No usamos tus datos para publicidad, no hacemos perfiles comerciales y no los vendemos ni rentamos.</p>

        <h2 id="terceros">4. Con quién los compartimos</h2>
        <p>Para funcionar, la app usa los siguientes servicios. Cada uno trata solo los datos necesarios para su parte
            y puede estar ubicado fuera de México:</p>
        <div class="overflow-x-auto">
            <table>
                <thead><tr><th>Servicio</th><th>Para qué</th><th>Datos</th></tr></thead>
                <tbody>
                    <tr v-for="s in SERVICES" :key="s[0]"><td>{{ s[0] }}</td><td>{{ s[1] }}</td><td>{{ s[2] }}</td></tr>
                </tbody>
            </table>
        </div>
        <p>La app carga sus tipografías desde Google Fonts, que puede registrar tu dirección IP. Solo compartiríamos
            datos con autoridades si una ley o una orden válida nos lo exige.</p>

        <h2 id="conservacion">5. Cuánto tiempo los guardamos</h2>
        <ul class="list">
            <li>Los datos de tu cuenta y tu progreso, mientras tengas la cuenta.</li>
            <li>Los enlaces de verificación de correo vencen en 24 horas y no se pueden reutilizar.</li>
            <li>Al borrar tu cuenta se eliminan tu cuenta, tu progreso, historial, logros, estadísticas y energía.
                Las copias de seguridad del proveedor de base de datos pueden conservarlos por un tiempo limitado
                antes de desaparecer.</li>
        </ul>

        <h2 id="derechos">6. Tus derechos</h2>
        <p>Puedes <strong>acceder</strong> a tus datos, <strong>corregirlos</strong>, <strong>borrarlos</strong> u
            <strong>oponerte</strong> a su uso, y retirar tu consentimiento:</p>
        <ul class="list">
            <li>En la app, en <strong>Perfil → Editar perfil</strong>, puedes cambiar tu nombre, usuario, correo y
                contraseña, y <strong>eliminar tu cuenta</strong> con todos sus datos.</li>
            <li>Para cualquier otra solicitud, escribe a <a class="lnk" :href="`mailto:${MAIL}`">{{ MAIL }}</a> desde el
                correo de tu cuenta. Te respondemos lo antes posible.</li>
            <li>Si entraste con Google, también puedes quitarle el acceso a Tlahtolcalli desde
                <a class="lnk" href="https://myaccount.google.com/connections" target="_blank" rel="noopener">tu cuenta de Google</a>.</li>
        </ul>

        <h2 id="seguridad">7. Seguridad</h2>
        <p>Las conexiones van cifradas (HTTPS), las contraseñas se guardan con hash, las sesiones vencen y cada
            persona solo puede ver y modificar sus propios datos. Ningún sistema es perfecto: si detectamos un problema
            que afecte tus datos, te avisaremos.</p>

        <h2 id="menores">8. Menores de edad</h2>
        <p>Tlahtolcalli es para cualquier persona que quiera aprender. Si eres menor de edad, usa la app con permiso de
            tu madre, padre o tutor. No pedimos datos de más a nadie. Si eres madre, padre o tutor y quieres que
            borremos la cuenta de un menor, escríbenos.</p>

        <h2 id="cambios">9. Cambios a este aviso</h2>
        <p>Si cambiamos este aviso, actualizaremos la fecha de arriba y, si el cambio es importante, te avisaremos en
            la app o por correo.</p>
    </DocPage>
</template>

<script setup>
import DocPage from '../../components/public/DocPage.vue'

const MAIL = 'contacto.tlahtolcalli@gmail.com'
const SERVICES = [
    ['Neon', 'Base de datos', 'Tu cuenta y tu progreso'],
    ['Render', 'Servidor de la app', 'Peticiones a la app y datos técnicos'],
    ['Netlify', 'Publicar la app', 'Datos técnicos de las visitas'],
    ['Brevo', 'Enviar correos de la cuenta', 'Tu nombre y correo, solo al enviarte un correo'],
    ['Google', 'Iniciar sesión con Google (si lo eliges)', 'Los datos del punto 2'],
    ['UptimeRobot', 'Revisar que el servidor esté en línea', 'Ningún dato tuyo'],
]
</script>
