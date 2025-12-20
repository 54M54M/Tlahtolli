<template>
    <!-- Titulo views -->
    <header v-if="variant === 'simple'"
        class="py-3 px-4 text-white w-full fixed top-0 left-0 md:left-[-70px] right-20 z-20 bg-[#0a2136]">
        <div class="max-w-xl mx-auto flex justify-center items-center">
            <h1 class="text-lg font-bold">{{ title }}</h1>
        </div>
    </header>

    <!-- HomeView header -->
    <div v-else-if="variant === 'homeview'"
        class="py-3 px-4 text-white w-full top-0 left-0 md:left-[-70px] right-20 z-20">
        <div class="max-w-xl mx-auto flex items-center">
            <!-- Izquierda -->
            <div class="hidden md:block mr-8">
                <div class="flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105"
                    :style="{
                        backgroundColor: currentLanguageData.color + '40', border: `2px solid ${currentLanguageData.color}`
                    }" @click="$emit('show-all')">
                    <div class="w-6 h-6 rounded-full flex items-center justify-center text-white text-xs font-bold"
                        :style="{ backgroundColor: currentLanguageData.color }">
                        {{ currentLanguageData.flag }}
                    </div>
                </div>
            </div>

            <!-- Centro -->
            <div class="flex-grow flex justify-center">
                <h1 class="md:text-xl text-[19.6px] font-bold">{{ title }}</h1>
            </div>

            <!-- Derecha -->
            <div class="ml-8">
                <!-- En la sección de energía -->
                <div class="flex items-center px-3 py-1 mt-2 rounded-full transition-all duration-300 hover:scale-105 relative bg-[#FFC10A40]"
                    @click="$emit('energy-click')">
                    <div class="h-6 rounded-full flex items-center justify-center text-white text-xs font-bold">
                        <svg width="16px" height="16px" viewBox="0 0 32 32" enable-background="new 0 0 32 32"
                            version="1.1" xml:space="preserve" xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink">
                            <path
                                d="M26.8,11.5l-12,19C14.7,30.8,14.3,31,14,31c-0.1,0-0.2,0-0.3-0.1c-0.4-0.2-0.7-0.6-0.6-1.1L14.8,17H6    c-0.4,0-0.7-0.2-0.9-0.5c-0.2-0.3-0.1-0.7,0.1-1l10-14c0.3-0.4,0.7-0.5,1.1-0.4C16.7,1.2,17,1.6,17,2v8h9c0.4,0,0.7,0.2,0.9,0.5    C27,10.8,27,11.2,26.8,11.5z"
                                fill="#FFC10A" />
                        </svg>
                    </div>
                    <span class="text-xs font-semibold ml-1" :style="{ color: '#FFC10A' }">
                        {{ energyCurrent }}
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Niveles views -->
    <div v-else-if="variant === 'levels'"
        :class="['text-white w-full fixed top-0 left-0 md:left-[-70px] right-0 z-10 bg-[#0a2136] pt-4 pl-4 pr-4 pb-0']">
        <div class="max-w-xl mx-auto bg-[#1f2937] rounded-xl px-4 py-3">

            <div class="flex justify-between items-center">

                <router-link :to="backRoute"
                    class="text-white text-sm flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105">
                    <span class="font-bold">
                        <span v-if="!isMobile">← Volver</span>
                        <span v-else>
                            <svg fill="#d1d5db" height="20px" width="20px" version="1.1" id="Capa_1"
                                xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                                viewBox="0 0 460.775 460.775" xml:space="preserve">
                                <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                                <g id="SVGRepo_iconCarrier">
                                    <path
                                        d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z">
                                    </path>
                                </g>
                            </svg>
                        </span>
                    </span>
                </router-link>

                <div class="text-center flex-1 max-w-[200px] md:max-w-[315px] mx-4">
                    <h2 class="text-sm font-semibold truncate">{{ subtitle }}</h2>
                    <h1 class="text-lg font-bold truncate md:">
                        {{ title }}
                    </h1>
                </div>

                <!-- Badge dinámico para versión default -->
                <div class="flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105"
                    :style="{
                        backgroundColor: currentLanguageData.color + '40',
                        border: `2px solid ${currentLanguageData.color}`
                    }" @click="$emit('show-all')">
                    <div class="w-6 h-6 rounded-full flex items-center justify-center text-white text-xs font-bold"
                        :style="{ backgroundColor: currentLanguageData.color }">
                        {{ currentLanguageData.flag }}
                    </div>
                    <span v-if="!isMobile" class="text-xs font-semibold" :style="{ color: currentLanguageData.color }">
                        {{ currentLanguageData.name }}
                    </span>
                </div>
            </div>

        </div>
    </div>

    <!-- Ejercicios views -->
    <div v-else-if="variant === 'lesson'"
        :class="['py-3 px-4 text-white w-full fixed top-0 left-0 right-0 z-10 pt-2 pb-0']">
        <div class="bg-[#1f2937] rounded-xl px-4 pt-[5px] pb-5">
            <div class="max-w-xl mx-auto md:max-w-5xl">
                <div class="flex justify-between items-center mb-3 mt-2">

                    <!-- CAMBIO: Reemplazar router-link por button -->
                    <button @click="$emit('exit-lesson')"
                        class="text-white text-sm flex items-center gap-2 px-3 pt-2 rounded-full transition-all duration-300 hover:scale-105">
                        <span class="font-bold">
                            <span v-if="!isMobile">← Volver</span>
                            <span v-else>
                                <svg fill="#d1d5db" height="20px" width="20px" version="1.1" id="Capa_1"
                                    xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                                    viewBox="0 0 460.775 460.775" xml:space="preserve">
                                    <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                    <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                                    <g id="SVGRepo_iconCarrier">
                                        <path
                                            d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z">
                                        </path>
                                    </g>
                                </svg>
                            </span>
                        </span>
                    </button>

                    <div class="text-center -mt-3">
                        <h2 class="text-xs tracking-wider font-semibold mb-[-5px] uppercase">
                            {{ title }}
                        </h2>
                    </div>

                    <!-- En la sección de energía -->
                    <div class="flex items-center px-3 py-1 mt-2 rounded-full transition-all duration-300 hover:scale-105 relative bg-[#FFC10A40]"
                        @click="$emit('energy-click')">
                        <div class="h-6 rounded-full flex items-center justify-center text-white text-xs font-bold">
                            <svg width="16px" height="16px" viewBox="0 0 32 32" enable-background="new 0 0 32 32"
                                version="1.1" xml:space="preserve" xmlns="http://www.w3.org/2000/svg"
                                xmlns:xlink="http://www.w3.org/1999/xlink">
                                <path
                                    d="M26.8,11.5l-12,19C14.7,30.8,14.3,31,14,31c-0.1,0-0.2,0-0.3-0.1c-0.4-0.2-0.7-0.6-0.6-1.1L14.8,17H6    c-0.4,0-0.7-0.2-0.9-0.5c-0.2-0.3-0.1-0.7,0.1-1l10-14c0.3-0.4,0.7-0.5,1.1-0.4C16.7,1.2,17,1.6,17,2v8h9c0.4,0,0.7,0.2,0.9,0.5    C27,10.8,27,11.2,26.8,11.5z"
                                    fill="#FFC10A" />
                            </svg>
                        </div>
                        <span class="text-xs font-semibold ml-1" :style="{ color: '#FFC10A' }">
                            {{ energyCurrent }}
                        </span>

                        <!-- Animación de cambios de energía desde store global -->
                        <div v-if="energyStore.energyChanges.length > 0 && energyStore.currentEnergy < 15"
                            class="absolute -top-1 -left-1">
                            <div v-for="change in energyStore.energyChanges" :key="change.id"
                                class="text-xs font-bold px-1 py-0.5 rounded-full slow-pulse"
                                :class="change.type === 'gain' ? 'text-[#FFC10A] bg-[#FFC10A40]/20' : 'text-[#FFC10A] bg-[#FFC10A40]/20'">
                                {{ change.value > 0 ? '+' : '' }}{{ change.value }}
                            </div>
                        </div>
                    </div>

                </div>

                <div class="flex justify-center w-full mt-[-15px]">
                    <div class="w-7/12">
                        <ProgressBar :current="progressCurrent" :total="progressTotal" />
                    </div>
                </div>
            </div>

        </div>

    </div>

</template>

<script>
import Badge from './Badge.vue';
import ProgressBar from './ProgressBar.vue';
import { useAuthStore } from '../stores/auth';
import { LanguageService } from '../data/services/LanguageService.js';
import { useEnergyStore } from '../stores/energy';

import { ref, onMounted, onBeforeUnmount } from 'vue';

export default {
    name: 'Header',
    components: {
        Badge,
        ProgressBar
    },
    setup() {
        const energyStore = useEnergyStore();
        return { energyStore };
    },
    props: {
        variant: {
            type: String,
            default: 'default',
            validator: (value) => ['simple', 'levels', 'lesson'].includes(value)
        },
        title: {
            type: String,
            required: true
        },
        subtitle: {
            type: String,
            default: ''
        },
        backRoute: {
            type: [String, Object],
            default: '/'
        },
        progressCurrent: {
            type: Number,
            default: 0
        },
        progressTotal: {
            type: Number,
            default: 1
        },
        color: {
            type: String,
            default: '#58cc02'
        },
        // Nuevas props para energía
        energyCurrent: {
            type: Number,
            default: 15
            // default: 25
        },
        energyMax: {
            type: Number,
            default: 15
            // default: 25
        },
        energyStreak: {
            type: Number,
            default: 0
        },
        showEnergy: {
            type: Boolean,
            default: true
        }
    },
    emits: ['show-all', 'exit-lesson', 'energy-click'],
    data() {
        return {
            authStore: useAuthStore(),
            languageService: new LanguageService(),
            isMobile: false,
            showRecoveryAnimation: false,
            recoveryTimer: null
        };
    },
    computed: {
        currentLanguageData() {
            if (!this.authStore.selectedLanguage) {
                return { color: '#666', name: 'Selecciona idioma', flag: '🌐' };
            }
            return this.languageService.getLanguageInfo(this.authStore.selectedLanguage) ||
                { color: '#666', name: 'Idioma no encontrado', flag: '❓' };
        },
        energyTooltip() {
            const tooltips = [
                `Energía: ${this.energyCurrent}/${this.energyMax}⚡`,
                `Consumo: -1⚡ por ejercicio`,
                `Acierto: +1-2⚡ bonus`,
                `Racha (${this.energyStreak}): +3-4⚡ bonus`
            ];
            return tooltips.join('\n');
        },
        isLowEnergy() {
            return (this.energyCurrent / this.energyMax) < 0.3;
        },
        energyPercentage() {
            return (this.energyCurrent / this.energyMax) * 100;
        },
        // Obtener energía del store global
        energyForDisplay() {
            return this.energyStore.energyForHeader;
        },
        energyCurrent() {
            return this.energyForDisplay.current;
        },
        energyMax() {
            return this.energyForDisplay.max;
        },
        energyStreak() {
            return this.energyForDisplay.streak;
        },
    },
    methods: {
        checkScreenSize() {
            this.isMobile = window.innerWidth < 768;
        },
        startRecoveryAnimation() {
            // Mostrar animación cuando la energía está recuperándose
            if (this.energyCurrent < this.energyMax) {
                this.showRecoveryAnimation = true;
                setTimeout(() => {
                    this.showRecoveryAnimation = false;
                }, 3000);
            }
        },
        updateEnergyDisplay() {
            // Este método sería llamado desde el componente padre cuando la energía cambia
            this.startRecoveryAnimation();
        }
    },
    mounted() {
        this.checkScreenSize();
        window.addEventListener('resize', this.checkScreenSize);

        // Iniciar timer para animación de recarga (cada 20 minutos simbólico)
        this.recoveryTimer = setInterval(() => {
            if (this.energyCurrent < this.energyMax) {
                this.startRecoveryAnimation();
            }
        }, 60000); // Cada minuto para demostración
    },
    beforeUnmount() {
        window.removeEventListener('resize', this.checkScreenSize);
        if (this.recoveryTimer) {
            clearInterval(this.recoveryTimer);
        }
    },
    watch: {
        energyCurrent(newVal, oldVal) {
            if (newVal > oldVal) {
                this.startRecoveryAnimation();
            }
        }
    }
};
</script>

<style scoped>
/* Animación de pulso lento con fade in/out */
@keyframes slow-pulse {
    0% {
        opacity: 0;
        transform: scale(0.9);
    }

    15% {
        opacity: 1;
        transform: scale(1);
    }

    50% {
        opacity: 1;
        transform: scale(1);
    }

    85% {
        opacity: 1;
        transform: scale(1);
    }

    100% {
        opacity: 0;
        transform: scale(0.9);
    }
}

.slow-pulse {
    animation: slow-pulse 5s ease-in-out 1 forwards;
}
</style>