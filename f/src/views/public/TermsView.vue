<template>
    <DocPage title="Términos del servicio" updated="18 de noviembre de 2026">
        <template #intro>
            <p><strong>En corto:</strong> Tlahtolcalli es gratis y está en desarrollo. Úsalo para aprender,
                trata con respeto las lenguas y a sus comunidades, y cuida tu cuenta. Al crear una cuenta o usar la app
                aceptas estos términos y el <router-link class="lnk" to="/privacidad">aviso de privacidad</router-link>.</p>
        </template>

        <h2 id="servicio">1. El servicio</h2>
        <p><strong>Tlahtolcalli</strong> es una app web gratuita para aprender lenguas originarias de México con lecciones,
            vocabulario, guía de pronunciación y práctica. Es un proyecto independiente y en desarrollo activo: el contenido,
            las funciones y el diseño pueden cambiar, y el servicio puede tener pausas o fallas.</p>

        <h2 id="cuenta">2. Tu cuenta</h2>
        <ul class="list">
            <li>Puedes crear tu cuenta con usuario y contraseña o con Google. Usa un correo real para poder
                verificarlo y recuperar tu cuenta.</li>
            <li>Eres responsable de lo que pase con tu cuenta: no compartas tu contraseña.</li>
            <li>Tu nombre de usuario debe ser respetuoso. Puedes cambiarlo con un tiempo de espera entre cambios.</li>
            <li>Puedes borrar tu cuenta cuando quieras desde <strong>Perfil → Editar perfil</strong>.</li>
        </ul>

        <h2 id="uso">3. Uso aceptable</h2>
        <p>Al usar Tlahtolcalli te comprometes a no:</p>
        <ul class="list">
            <li>Intentar entrar a cuentas o datos de otras personas, o a partes de la app que no son para ti.</li>
            <li>Atacar, saturar, automatizar peticiones abusivas o intentar vulnerar el servicio.</li>
            <li>Usar nombres, mensajes o propuestas ofensivas, discriminatorias o que se burlen de las lenguas o
                de sus comunidades.</li>
            <li>Copiar el contenido de la app para venderlo o presentarlo como propio.</li>
        </ul>
        <p>Si alguien no respeta estas reglas podemos suspender o cerrar su cuenta.</p>

        <h2 id="contenido">4. El contenido y las lenguas</h2>
        <p>Las lenguas originarias pertenecen a sus pueblos y comunidades hablantes. Tlahtolcalli no se adueña de ellas:
            organiza materiales de aprendizaje y los revisa con hablantes antes de publicarlos. Aun así, puede haber errores
            o diferencias entre variantes. El contenido es para aprender, no sustituye a hablantes, docentes ni fuentes
            oficiales. Si encuentras un error,
            <a class="lnk" :href="`mailto:${MAIL}?subject=Correcci%C3%B3n%20de%20contenido`">avísanos</a>.</p>
        <p>El diseño, la mascota, el código y la organización de los cursos son de Tlahtolcalli. Si nos envías
            correcciones, propuestas o materiales, nos das permiso de usarlos en la app y, si así lo quieres,
            te damos crédito.</p>

        <h2 id="gratis">5. Gratis y sin garantías</h2>
        <p>La app se ofrece gratis y “tal como está”. Hacemos lo posible para que funcione bien y para no perder tu
            progreso, pero no podemos garantizar que esté siempre disponible ni libre de errores. En la medida que permita
            la ley, Tlahtolcalli no es responsable de daños derivados del uso o de la imposibilidad de usar la app.</p>

        <h2 id="cambios">6. Cambios</h2>
        <p>Podemos actualizar estos términos. Cambiaremos la fecha de arriba y, si el cambio es importante, te avisaremos
            en la app o por correo. Si sigues usando la app después de un cambio, aceptas la nueva versión.</p>

        <h2 id="ley">7. Ley aplicable y contacto</h2>
        <p>Estos términos se rigen por las leyes de México. Para dudas, aclaraciones o reportes escríbenos a
            <a class="lnk" :href="`mailto:${MAIL}`">{{ MAIL }}</a>.</p>
    </DocPage>
</template>

<script setup>
import DocPage from '../../components/public/DocPage.vue'
const MAIL = 'contacto.tlahtolcalli@gmail.com'
</script>
