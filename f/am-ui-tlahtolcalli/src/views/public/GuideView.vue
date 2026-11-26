<template>
    <!-- Manual de uso (/como-se-usa): carrusel, un paso a la vez, todo en una pantalla.
         Teléfono: captura arriba, texto y Anterior/Siguiente abajo (también deslizando).
         Computadora: captura a la izquierda; a la derecha el texto, los controles y el índice de pasos (y flechas ← →).
         Los 8 textos van en el HTML (los demás con .hidden) para que Google los lea aunque solo se vea uno. -->
    <PublicShell>
        <main class="px-4 py-8 md:py-8">
            <div class="container mx-auto md:px-16 max-w-5xl">
                <p class="text-sm font-semibold tracking-widest text-turquesa uppercase mb-2">Tlahtolcalli</p>
                <h1 class="text-3xl md:text-4xl font-bold mb-2">Cómo se usa</h1>
                <p class="text-gray-400 mb-6 md:mb-8 max-w-2xl">Funciona igual en el teléfono y en la computadora. Entra desde
                    cualquier navegador; no hay que instalar nada.</p>

                <section class="grid md:grid-cols-[auto_minmax(0,1fr)] gap-4 md:gap-12 items-center max-w-sm md:max-w-none mx-auto"
                    aria-roledescription="carrusel" aria-label="Pasos de uso"
                    @touchstart.passive="onTouchStart" @touchend.passive="onTouchEnd">
                    <figure class="mx-auto">
                        <div class="guia-tel">
                            <Transition name="guia" mode="out-in">
                                <img :key="GUIDE[step].img" :src="`/landing/pantallas/${GUIDE[step].img}.webp`"
                                    :alt="GUIDE[step].alt" width="432" height="935" loading="lazy">
                            </Transition>
                        </div>
                    </figure>

                    <div>
                        <ol class="guia-textos bg-surface-2 border border-line rounded-xl p-4 md:p-6" aria-live="polite">
                            <li v-for="(g, i) in GUIDE" :key="g.img" :class="{ hidden: step !== i }">
                                <p class="text-xs md:text-sm font-semibold tracking-widest text-turquesa uppercase mb-1 md:mb-2">Paso {{ i + 1 }} de {{ GUIDE.length }}</p>
                                <h2 class="text-lg md:text-2xl font-bold mb-1 md:mb-3">{{ g.title }}</h2>
                                <p class="text-gray-400 text-[15px] md:text-lg leading-snug md:leading-relaxed" v-html="g.text"></p>
                            </li>
                        </ol>

                        <div class="flex items-center justify-between gap-2 mt-3 md:mt-4">
                            <button type="button" @click="go(-1)" :disabled="step === 0"
                                class="shrink-0 border-2 border-line text-gray-100 font-semibold py-2 px-3 sm:px-4 md:px-6 rounded-lg disabled:opacity-40">Anterior</button>
                            <div class="flex flex-nowrap justify-center min-w-0 md:hidden">
                                <button v-for="(g, i) in GUIDE" :key="g.img" type="button" @click="step = i"
                                    :aria-label="`Paso ${i + 1}: ${g.title}`" :aria-current="step === i ? 'step' : undefined" class="tl-flat p-[3px] sm:p-1">
                                    <span class="block w-1.5 h-1.5 sm:w-2 sm:h-2 rounded-full transition-colors" :class="step === i ? 'bg-turquesa' : 'bg-line'"></span>
                                </button>
                            </div>
                            <button v-if="step < GUIDE.length - 1" type="button" @click="go(1)"
                                class="shrink-0 bg-turquesa-deep hover:bg-turquesa-deeper text-white font-semibold py-2 px-3 sm:px-4 md:px-6 rounded-lg">Siguiente</button>
                            <router-link v-else :to="authStore.user ? '/app' : { query: { auth: 'register' } }"
                                class="shrink-0 bg-turquesa-deep hover:bg-turquesa-deeper text-white font-semibold py-2 px-3 sm:px-4 md:px-6 rounded-lg">
                                {{ authStore.user ? 'Ir a la app' : 'Empezar' }}</router-link>
                        </div>

                        <!-- Computadora: índice de pasos (solo títulos) para saltar -->
                        <nav class="hidden md:grid grid-cols-2 gap-x-4 mt-5" aria-label="Ir a un paso">
                            <button v-for="(g, i) in GUIDE" :key="g.img" type="button" @click="step = i"
                                :aria-current="step === i ? 'step' : undefined"
                                class="tl-flat flex items-center gap-3 text-left rounded-lg px-2 py-1 transition-colors"
                                :class="step === i ? 'text-gray-100' : 'text-gray-400 hover:text-gray-200'">
                                <span class="shrink-0 w-7 h-7 rounded-md text-sm font-bold flex items-center justify-center"
                                    :class="step === i ? 'bg-turquesa text-surface-3' : 'bg-surface-2'">{{ i + 1 }}</span>
                                <span class="truncate">{{ g.title }}</span>
                            </button>
                        </nav>
                    </div>
                </section>
            </div>
        </main>
    </PublicShell>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import PublicShell from '../../components/public/PublicShell.vue'
import { useAuthStore } from '../../stores/auth'

const authStore = useAuthStore()

// Pasos del manual de uso. El texto es fijo (se prerenderiza y lo lee Google); la imagen cambia con el paso elegido.
const step = ref(0)

// Carrusel (teléfono): botones y deslizar a los lados
const go = (d) => { step.value = Math.min(GUIDE.length - 1, Math.max(0, step.value + d)) }
let touchX = null
let touchY = null
const onTouchStart = (e) => { touchX = e.touches[0].clientX; touchY = e.touches[0].clientY }
const onTouchEnd = (e) => {
    if (touchX == null) return
    const dx = e.changedTouches[0].clientX - touchX
    const dy = e.changedTouches[0].clientY - touchY
    touchX = touchY = null
    if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy) * 1.5) go(dx < 0 ? 1 : -1)
}

// Computadora: flechas del teclado (si no se está escribiendo en un campo)
const onKey = (e) => {
    if (e.target?.closest?.('input, textarea, select, [contenteditable]')) return
    if (e.key === 'ArrowRight') go(1)
    else if (e.key === 'ArrowLeft') go(-1)
}
onMounted(() => window.addEventListener('keydown', onKey))
onBeforeUnmount(() => window.removeEventListener('keydown', onKey))
const GUIDE = [
    { img: 'registro', alt: 'Formulario para crear cuenta', title: 'Crea tu cuenta',
      text: 'Toca <b>Empezar gratis</b>, llena tus datos y toca <b>Crear cuenta</b>; te llega un correo para verificarla. También puedes entrar con <b>Continuar con Google</b>.' },
    { img: 'idioma', alt: 'Lista para elegir idioma', title: 'Elige tu idioma',
      text: 'Abre la familia de lenguas, marca el idioma y toca <b>Continuar</b>. El náhuatl central está en uto-aztec y el tének en maya.' },
    { img: 'nhn-inicio', alt: 'Niveles del curso', title: 'Avanza por niveles',
      text: 'Cada curso tiene 6 niveles. El primero está abierto y cada uno se abre al terminar el anterior. El rayo de arriba es tu energía.' },
    { img: 'nhn-nivel', alt: 'Unidades de un nivel', title: 'Entra a una unidad',
      text: 'Cada nivel tiene 6 unidades con su objetivo y una nota de gramática. Toca <b>Empezar lección</b>; las terminadas se pueden repasar.' },
    { img: 'nhn-leccion-correcta', alt: 'Ejercicio respondido correctamente', title: 'Haz la lección',
      text: 'Elige la traducción, arma la frase con las fichas, une los pares o escribe la palabra que falta y toca <b>Verificar</b>. Toca una palabra subrayada para ver su pronunciación y de qué partes se forma. Si fallas, pierdes 1 punto de energía y el ejercicio vuelve al final.' },
    { img: 'nhn-glosario', alt: 'Glosario con el alfabeto', title: 'Gana EXP y repasa',
      text: 'Al terminar ganas EXP y se abre la siguiente unidad. En <b>Glosario</b> está el alfabeto del idioma; en <b>Estadísticas</b> y <b>Perfil</b>, tu avance y tus logros.' },
    { img: 'hus-inicio', alt: 'Inicio con el botón de idioma', title: 'Cambia de idioma',
      text: 'En el inicio, toca el círculo con el ícono del idioma, arriba a la izquierda, y elige otro. Tu avance de cada idioma se guarda.' },
    { img: 'editar', alt: 'Pantalla Editar perfil', title: 'Edita tu perfil',
      text: 'En <b>Perfil → Ajustes → Editar perfil</b> cambias tu nombre, usuario, correo o contraseña, o eliminas tu cuenta.' },
]
</script>

<style scoped>
/* Teléfono de la guía de uso */
/* Teléfono: lo que quepa con el texto y los botones en una pantalla (13rem máx.) */
.guia-tel { width: 13rem; width: min(13rem, calc((100svh - 27rem) * 432 / 935)); aspect-ratio: 432 / 935; border-radius: 2rem; padding: .5rem; background: #0b1219;
    border: 1px solid rgb(255 255 255 / .12); box-shadow: 0 24px 60px -20px rgb(0 0 0 / .7); overflow: hidden; }
.guia-tel img { width: 100%; height: 100%; object-fit: cover; border-radius: 1.5rem; display: block; }
@media (min-width: 768px) { .guia-tel { width: 17rem; width: min(17rem, calc((100vh - 17rem) * 432 / 935)); } }
/* Alto fijo del texto: los botones no brincan al cambiar de paso */
.guia-textos { min-height: 10rem; }
@media (min-width: 768px) { .guia-textos { min-height: 13rem; } }
.guia-enter-active, .guia-leave-active { transition: opacity .2s ease; }
.guia-enter-from, .guia-leave-to { opacity: 0; }
</style>
