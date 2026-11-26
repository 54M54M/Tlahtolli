<template>
    <!-- Manual de uso (/como-se-usa).
         Computadora: pasos a la izquierda, pantalla del paso elegido a la derecha (fija al desplazarse).
         Teléfono: carrusel, un paso por pantalla (captura + texto + Anterior/Siguiente, también deslizando).
         La lista completa sigue en el HTML (oculta en teléfono) para que Google lea los 8 pasos. -->
    <PublicShell>
        <main class="px-4 py-8 md:py-16">
            <div class="container mx-auto md:px-16">
                <p class="text-sm font-semibold tracking-widest text-turquesa uppercase mb-2 md:mb-3">Tlahtolcalli</p>
                <h1 class="text-3xl md:text-5xl font-bold mb-2 md:mb-4">Cómo se usa</h1>
                <p class="text-gray-400 mb-6 md:mb-12 max-w-2xl">Funciona igual en el teléfono y en la computadora. Entra desde
                    cualquier navegador; no hay que instalar nada.</p>
                <div class="grid md:grid-cols-[minmax(0,1fr)_auto] gap-10 md:gap-16 items-start">
                    <ol class="hidden md:block space-y-3">
                        <li v-for="(g, i) in GUIDE" :key="g.title">
                            <button type="button" @click="step = i" :aria-pressed="step === i"
                                class="w-full text-left flex gap-4 p-5 rounded-xl border transition-colors"
                                :class="step === i ? 'bg-surface-2 border-turquesa' : 'border-line hover:border-gray-500'">
                                <span class="shrink-0 w-9 h-9 rounded-lg font-bold flex items-center justify-center"
                                    :class="step === i ? 'bg-turquesa text-surface-3' : 'bg-surface-2 text-gray-300'">{{ i + 1 }}</span>
                                <span>
                                    <span class="block text-lg font-bold mb-1">{{ g.title }}</span>
                                    <span class="block text-gray-400" v-html="g.text"></span>
                                </span>
                            </button>
                        </li>
                    </ol>

                    <section class="md:sticky md:top-24 mx-auto w-full md:w-auto max-w-sm" aria-roledescription="carrusel"
                        aria-label="Pasos de uso" @touchstart.passive="onTouchStart" @touchend.passive="onTouchEnd">
                        <figure>
                            <div class="guia-tel mx-auto">
                                <Transition name="guia" mode="out-in">
                                    <img :key="GUIDE[step].img" :src="`/landing/pantallas/${GUIDE[step].img}.webp`"
                                        :alt="GUIDE[step].alt" width="432" height="935" loading="lazy">
                                </Transition>
                            </div>
                            <figcaption class="hidden md:block text-center text-sm text-gray-400 mt-3">Paso {{ step + 1 }} de {{ GUIDE.length }}</figcaption>
                        </figure>

                        <!-- Teléfono: texto del paso y controles -->
                        <div class="md:hidden mt-4">
                            <Transition name="guia" mode="out-in">
                                <div :key="step" class="bg-surface-2 border border-line rounded-xl p-4 min-h-[10rem]" aria-live="polite">
                                    <p class="text-xs font-semibold tracking-widest text-turquesa uppercase mb-1">Paso {{ step + 1 }} de {{ GUIDE.length }}</p>
                                    <h2 class="text-lg font-bold mb-1">{{ GUIDE[step].title }}</h2>
                                    <p class="text-gray-400 text-[15px] leading-snug" v-html="GUIDE[step].text"></p>
                                </div>
                            </Transition>
                            <div class="flex items-center justify-between gap-2 mt-3">
                                <button type="button" @click="go(-1)" :disabled="step === 0"
                                    class="shrink-0 border-2 border-line text-gray-100 font-semibold py-2 px-3 sm:px-4 rounded-lg disabled:opacity-40">Anterior</button>
                                <div class="flex flex-nowrap justify-center min-w-0">
                                    <button v-for="(g, i) in GUIDE" :key="g.img" type="button" @click="step = i"
                                        :aria-label="`Paso ${i + 1}: ${g.title}`" :aria-current="step === i ? 'step' : undefined" class="tl-flat p-[3px] sm:p-1">
                                        <span class="block w-1.5 h-1.5 sm:w-2 sm:h-2 rounded-full transition-colors" :class="step === i ? 'bg-turquesa' : 'bg-line'"></span>
                                    </button>
                                </div>
                                <button v-if="step < GUIDE.length - 1" type="button" @click="go(1)"
                                    class="shrink-0 bg-turquesa-deep hover:bg-turquesa-deeper text-white font-semibold py-2 px-3 sm:px-4 rounded-lg">Siguiente</button>
                                <router-link v-else :to="authStore.user ? '/app' : { query: { auth: 'register' } }"
                                    class="shrink-0 bg-turquesa-deep hover:bg-turquesa-deeper text-white font-semibold py-2 px-3 sm:px-4 rounded-lg">
                                    {{ authStore.user ? 'Ir a la app' : 'Empezar' }}</router-link>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </main>
    </PublicShell>
</template>

<script setup>
import { ref } from 'vue'
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
@media (min-width: 768px) { .guia-tel { width: 17rem; } }
.guia-enter-active, .guia-leave-active { transition: opacity .2s ease; }
.guia-enter-from, .guia-leave-to { opacity: 0; }
</style>
