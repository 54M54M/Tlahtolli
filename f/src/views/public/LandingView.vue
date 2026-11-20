<template>
    <PublicShell>
        <!-- Portada: texto a la izquierda, pantallas reales de la app inclinadas a la derecha -->
        <section class="portada relative overflow-hidden">
            <div class="container mx-auto px-4 relative z-10 py-10 md:py-0 md:min-h-[640px] flex items-center">
                <div class="md:w-1/2 md:pr-6">
                    <h1 class="text-4xl md:text-6xl font-bold mb-6 leading-tight text-balance">
                        Lenguas originarias de México, palabra por palabra</h1>
                    <p class="text-lg md:text-xl mb-8 text-gray-400 max-w-xl">Tlahtolcalli es una app web gratuita para
                        aprender con lecciones cortas, vocabulario con pronunciación y práctica diaria.</p>
                    <div class="flex flex-col sm:flex-row gap-4">
                        <router-link :to="authStore.user ? '/app' : { query: { auth: 'register' } }"
                            class="bg-turquesa-deep hover:bg-turquesa-deeper text-white font-bold py-3 px-6 rounded-lg text-center transition-colors">
                            {{ authStore.user ? 'Continuar aprendiendo' : 'Empezar gratis' }}
                        </router-link>
                        <router-link v-if="!authStore.user" :to="{ query: { auth: 'login' } }"
                            class="border-2 border-line hover:border-turquesa text-gray-100 font-bold py-3 px-6 rounded-lg text-center transition-colors">
                            Ya tengo cuenta
                        </router-link>
                        <a v-else href="/#idiomas" @click.prevent="scrollTo('idiomas')"
                            class="border-2 border-line hover:border-turquesa text-gray-100 font-bold py-3 px-6 rounded-lg text-center transition-colors">
                            Ver idiomas disponibles
                        </a>
                    </div>
                </div>
            </div>

            <!-- 3 columnas desfasadas, giradas en conjunto (capturas en public/landing/pantallas) -->
            <div class="telefonos relative h-[460px] md:h-auto md:absolute md:inset-y-0 md:right-0 md:w-[55%]"
                role="img" aria-label="Pantallas de la app Tlahtolcalli">
                <div class="inclinado">
                    <div v-for="(col, c) in COLUMNAS" :key="c" class="columna" :style="{ '--y': ['-12%', '6%', '-22%'][c] }">
                        <div v-for="(sc, i) in col" :key="sc + i" class="tel">
                            <img :src="`/landing/pantallas/${sc}.webp`" alt="" width="432" height="935" decoding="async"
                                :fetchpriority="c === 1 && i === 1 ? 'high' : 'auto'">
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Qué significa el nombre (también ayuda a que Google encuentre las otras formas de escribirlo) -->
        <section id="nombre" class="py-14 md:py-16 px-4 scroll-mt-20">
            <div class="container mx-auto md:px-10 max-w-3xl text-center">
                <h2 class="text-2xl md:text-3xl font-bold mb-4">¿Qué significa Tlahtolcalli?</h2>
                <p class="text-lg mb-6">
                    En náhuatl, <strong class="text-turquesa">tlahtōlli</strong> es «palabra» o «lengua» y
                    <strong class="text-turquesa">calli</strong> es «casa»: <strong>Tlahtolcalli</strong> es
                    <em>la casa de la palabra</em>, un lugar para aprender y cuidar las lenguas originarias de México.
                </p>
                <p class="text-sm text-gray-400">
                    Según la variante y la escritura, también lo encontrarás como tlahtolcali, tlajtolcalli, tlajtolcali,
                    tla'tolcalli o tla'tolcali. La raíz, tlahtolli, se escribe también tlahtoli, tlajtolli, tlajtoli,
                    tla'tolli o tla'toli.
                </p>
            </div>
        </section>

        <!-- Desafío y propuesta -->
        <section class="py-16 md:py-20 px-4 bg-surface-1">
            <div class="container mx-auto md:px-10 grid md:grid-cols-2 gap-8">
                <div class="bg-surface-2 border border-line p-8 rounded-xl">
                    <h2 class="text-2xl font-bold mb-6 text-grana">El desafío</h2>
                    <ul class="space-y-4">
                        <li v-for="t in CHALLENGES" :key="t" class="flex gap-3">
                            <span class="mt-2 w-2 h-2 rounded-full bg-grana shrink-0"></span>
                            <p>{{ t }}</p>
                        </li>
                    </ul>
                </div>
                <div class="bg-surface-2 border border-line p-8 rounded-xl">
                    <h2 class="text-2xl font-bold mb-6 text-turquesa">Nuestra propuesta</h2>
                    <p class="text-lg mb-6">Una app gratuita y gamificada que hace el aprendizaje accesible y respetuoso
                        con cada lengua y su variante.</p>
                    <p class="text-gray-400">El contenido se escribe con una sola norma ortográfica por variante y se
                        revisa con hablantes antes de publicarse.</p>
                </div>
            </div>
        </section>

        <!-- Características -->
        <section id="caracteristicas" class="py-16 md:py-20 px-4 scroll-mt-20">
            <div class="container mx-auto md:px-16">
                <h2 class="text-3xl md:text-4xl font-bold text-center mb-4">Características</h2>
                <p class="text-center text-gray-400 mb-12 max-w-2xl mx-auto">Lo que ya puedes usar hoy en la app.</p>
                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div v-for="f in FEATURES" :key="f.title" class="bg-surface-2 border border-line p-7 rounded-xl">
                        <p class="font-semibold text-sm uppercase tracking-wider mb-2" :class="f.color">{{ f.tag }}</p>
                        <h3 class="text-xl font-bold mb-3">{{ f.title }}</h3>
                        <p class="text-gray-400">{{ f.text }}</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Método -->
        <section id="metodo" class="py-16 md:py-20 px-4 bg-surface-1 scroll-mt-20">
            <div class="container mx-auto md:px-16">
                <h2 class="text-3xl md:text-4xl font-bold text-center mb-4">Cómo se aprende</h2>
                <p class="text-center text-gray-400 mb-12 max-w-2xl mx-auto">Cada idioma tiene 6 niveles con 6 unidades cada uno.</p>
                <ol class="grid md:grid-cols-2 gap-x-12 gap-y-8">
                    <li v-for="(l, i) in LEVELS" :key="l.title" class="flex gap-4">
                        <span class="shrink-0 w-9 h-9 rounded-lg text-surface-3 font-bold flex items-center justify-center"
                            :class="l.color">{{ i + 1 }}</span>
                        <div>
                            <h3 class="text-xl font-bold mb-1">{{ l.title }}</h3>
                            <p class="text-gray-400">{{ l.text }}</p>
                        </div>
                    </li>
                </ol>
            </div>
        </section>

        <!-- Idiomas y estado del proyecto -->
        <section id="idiomas" class="py-16 md:py-20 px-4 scroll-mt-20">
            <div class="container mx-auto md:px-16">
                <h2 class="text-3xl md:text-4xl font-bold text-center mb-4">Idiomas disponibles</h2>
                <p class="text-center text-gray-400 mb-12 max-w-2xl mx-auto">Tlahtolcalli está en desarrollo activo. Esto es lo que hay hoy.</p>
                <div class="grid md:grid-cols-2 gap-6 mb-10">
                    <article v-for="c in COURSES" :key="c.name" class="bg-surface-2 border border-line rounded-xl p-7">
                        <div class="flex items-center justify-between gap-3 mb-4">
                            <h3 class="text-2xl font-bold">{{ c.name }}</h3>
                            <span class="text-xs font-semibold px-2.5 py-1 rounded-full whitespace-nowrap" :class="c.badge">Curso en desarrollo</span>
                        </div>
                        <p class="text-gray-400 mb-6">{{ c.text }}</p>
                        <dl class="grid grid-cols-2 sm:grid-cols-4 gap-4 text-center tabular-nums">
                            <div v-for="s in c.stats" :key="s[0]">
                                <dt class="text-xs text-gray-400 uppercase tracking-wider">{{ s[0] }}</dt>
                                <dd class="text-2xl font-bold font-display">{{ s[1] }}</dd>
                            </div>
                        </dl>
                    </article>
                </div>

                <div class="bg-surface-1 border border-line rounded-xl p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                    <div>
                        <h3 class="text-lg font-bold">Estado del servicio</h3>
                        <p class="text-gray-400 text-sm">Disponibilidad del servidor de la app, revisada cada 5 minutos.</p>
                    </div>
                    <a href="https://stats.uptimerobot.com/iG8x8aeb43?utm_source=status_badge&utm_medium=referral"
                        target="_blank" rel="noopener" class="shrink-0 bg-white rounded-lg px-3 py-2">
                        <img src="https://badge.uptimerobot.com/psp/637355e694476be4e90904f07614a3f3.svg?style=logo&theme=dark"
                            alt="Estado del servidor de Tlahtolcalli" height="24" loading="lazy">
                    </a>
                </div>
            </div>
        </section>

        <!-- Colabora -->
        <section id="colabora" class="py-16 md:py-20 px-4 scroll-mt-20">
            <div class="container mx-auto md:px-16">
                <h2 class="text-3xl md:text-4xl font-bold text-center mb-4">Colabora</h2>
                <p class="text-center text-gray-400 mb-12 max-w-2xl mx-auto">Tlahtolcalli crece con la comunidad. Si
                    hablas o enseñas una lengua originaria, tu ayuda hace que el contenido sea correcto y respetuoso.</p>
                <div class="grid md:grid-cols-3 gap-6 mb-10">
                    <a v-for="c in COLLAB" :key="c.title" :href="`mailto:${MAIL}?subject=${encodeURIComponent(c.subject)}`"
                        class="block bg-surface-2 border border-line hover:border-turquesa p-7 rounded-xl transition-colors">
                        <p class="font-semibold text-sm uppercase tracking-wider mb-2" :class="c.color">{{ c.tag }}</p>
                        <h3 class="text-xl font-bold mb-3">{{ c.title }}</h3>
                        <p class="text-gray-400">{{ c.text }}</p>
                    </a>
                </div>
                <p class="text-center text-gray-400">Escríbenos a
                    <a :href="`mailto:${MAIL}`" class="text-turquesa font-semibold hover:underline break-all">{{ MAIL }}</a></p>
            </div>
        </section>

        <!-- Llamado final -->
        <section class="py-16 md:py-20 px-4 bg-surface-1">
            <div class="container mx-auto text-center">
                <div class="escalon justify-center mx-auto w-max mb-8" aria-hidden="true">
                    <span class="h-4 bg-turquesa"></span><span class="h-8 bg-turquesa"></span><span
                        class="h-12 bg-azul-maya"></span><span class="h-16 bg-cempasuchil"></span><span
                        class="h-12 bg-grana"></span><span class="h-8 bg-barro"></span><span class="h-4 bg-barro"></span>
                </div>
                <h2 class="text-3xl md:text-4xl font-bold mb-4">{{ authStore.user ? 'Sigue aprendiendo' : 'Empieza hoy' }}</h2>
                <p class="text-lg mb-8 max-w-xl mx-auto text-gray-400">Crea tu cuenta, elige tu idioma y aprende tus
                    primeras palabras en unos minutos.</p>
                <router-link :to="authStore.user ? '/app' : { query: { auth: 'register' } }"
                    class="inline-block bg-turquesa-deep hover:bg-turquesa-deeper text-white font-bold py-3 px-8 rounded-lg transition-colors">
                    {{ authStore.user ? 'Continuar aprendiendo' : 'Crear mi cuenta' }}
                </router-link>
            </div>
        </section>
    </PublicShell>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import PublicShell from '../../components/public/PublicShell.vue'

const authStore = useAuthStore()
const route = useRoute()
const MAIL = 'contacto.tlahtolcalli@gmail.com'

const scrollTo = (id) => document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })

// Si llegó con /#seccion desde otra página
onMounted(() => { if (route.hash) setTimeout(() => scrollTo(route.hash.slice(1)), 50) })

// Pantallas de la portada, por columna (capturas en public/landing/pantallas)
// nhn = náhuatl central · hus = tének
const COLUMNAS = [
    ['hus-glosario', 'nhn-nivel', 'hus-estadisticas'],
    ['hus-leccion-correcta', 'nhn-leccion-correcta', 'hus-nivel1'],
    ['nhn-glosario', 'nhn-inicio', 'hus-inicio'],
]

const CHALLENGES = [
    'México tiene 68 agrupaciones lingüísticas originarias y 364 variantes, y muchas están en riesgo de desaparecer.',
    'Hay pocos recursos digitales para aprenderlas, sobre todo para variantes vivas como el tének.',
    'Muchas personas jóvenes ya no las aprenden en casa.',
]

const FEATURES = [
    { tag: 'Progreso', color: 'text-cempasuchil', title: 'Aprendizaje gamificado', text: 'XP, rachas, energía y logros que premian la práctica constante.' },
    { tag: 'Glosario', color: 'text-azul-maya', title: 'Diccionario y silabario', text: 'Cada palabra con traducción, sílabas y guía de pronunciación.' },
    { tag: 'Escritura', color: 'text-barro', title: 'Una norma por variante', text: 'Reglas de escritura documentadas: dígrafos, saltillo y silabeo correcto.' },
    { tag: 'Niveles', color: 'text-grana', title: 'Progresión por unidades', text: 'Las unidades se desbloquean al completar la anterior. Con el nivel rápido puedes saltar lo que ya sabes.' },
    { tag: 'Pronunciación', color: 'text-turquesa', title: 'Escucha y lee en voz alta', text: 'Guía sílaba por sílaba y lectura en voz desde el navegador (en desarrollo).' },
    { tag: 'Acceso', color: 'text-cempasuchil', title: 'Gratis, en cualquier pantalla', text: 'Funciona en el navegador del teléfono, la tableta o la computadora. No necesitas instalar nada.' },
]

const LEVELS = [
    { color: 'bg-turquesa', title: 'Saluda y preséntate', text: 'Saludos, despedidas, tu nombre y cómo te sientes.' },
    { color: 'bg-azul-maya', title: 'Describe a tu familia', text: 'Pronombres, parentesco y adjetivos.' },
    { color: 'bg-cempasuchil', title: 'Pide y da información', text: 'Preguntas, lugares, necesidades y números.' },
    { color: 'bg-grana', title: 'Habla en el tiempo', text: 'Ayer, hoy y mañana: pasado y futuro.' },
    { color: 'bg-barro', title: 'Describe tu día', text: 'Rutinas, comida y partes del día.' },
    { color: 'bg-turquesa', title: 'Expresa tus gustos', text: 'Lo que te gusta, lo que quieres y cómo pedir algo.' },
]

const COURSES = [
    {
        name: 'Náhuatl central', badge: 'bg-turquesa/15 text-turquesa',
        text: 'Variante nhn, escrita en ortografía moderna con macrones. Contenido en revisión con un hablante de la variante.',
        stats: [['Niveles', 6], ['Unidades', 36], ['Palabras', 195], ['Ejercicios', 216]],
    },
    {
        name: 'Tének', badge: 'bg-azul-maya/15 text-azul-maya',
        text: 'Variante hus de San Luis Potosí, con la norma de escritura del INALI. Contenido en revisión con hablantes.',
        stats: [['Niveles', 6], ['Unidades', 36], ['Palabras', 175], ['Ejercicios', 216]],
    },
]

const COLLAB = [
    { tag: 'Revisar', color: 'text-turquesa', title: 'Corrige una palabra', subject: 'Corrección de contenido', text: '¿Encontraste una traducción, escritura o pronunciación incorrecta? Avísanos.' },
    { tag: 'Proponer', color: 'text-cempasuchil', title: 'Suma tu lengua o variante', subject: 'Propuesta de idioma', text: 'Si hablas una lengua o variante que no está, podemos armar su curso contigo.' },
    { tag: 'Reportar', color: 'text-grana', title: 'Algo no funciona', subject: 'Reporte de error', text: 'Cuéntanos qué pasó, en qué pantalla y desde qué dispositivo.' },
]
</script>

<style scoped>
/* Motivo escalonado (greca xicalcoliuhqui): el único patrón de la marca */
.escalon { display: grid; grid-template-columns: repeat(7, 16px); gap: 8px; align-items: end; }
.escalon span { display: block; width: 16px; border-radius: 2px; }
.text-balance { text-wrap: balance; }

/* Portada */
.portada {
    background:
        radial-gradient(45% 60% at 80% 25%, rgb(var(--turquesa) / .16), transparent 70%),
        radial-gradient(40% 50% at 70% 100%, rgb(var(--cempasuchil) / .10), transparent 70%);
}
.telefonos {
    /* los teléfonos se desvanecen hacia el texto (escritorio) y hacia abajo (móvil) */
    -webkit-mask-image: linear-gradient(to bottom, transparent, #000 14%, #000 72%, transparent);
            mask-image: linear-gradient(to bottom, transparent, #000 14%, #000 72%, transparent);
}
@media (min-width: 768px) {
    .telefonos {
        -webkit-mask-image: linear-gradient(to right, transparent 0, transparent 6%, #000 36%);
                mask-image: linear-gradient(to right, transparent 0, transparent 6%, #000 36%);
    }
}
.inclinado {
    position: absolute; left: 50%; top: 50%;
    display: flex; gap: 22px; width: max-content;
    transform: translate(-46%, -50%) rotate(-18deg);
}
.columna { display: flex; flex-direction: column; gap: 22px; transform: translateY(var(--y)); }
.tel {
    width: 170px; padding: 6px; background: #0b0f10; border-radius: 26px;
    box-shadow: 0 24px 40px -18px rgba(0, 0, 0, .8), inset 0 0 0 1.5px #2a3336;
}
.tel img { display: block; width: 100%; height: auto; border-radius: 20px; }
@media (min-width: 1024px) { .tel { width: 200px; border-radius: 30px; padding: 7px; } .tel img { border-radius: 23px; } }

</style>
