<template>
    <transition name="modal-fade">
        <div v-if="show"
            class="fixed inset-0 z-50 flex items-end md:items-center justify-center md:p-4 bg-black bg-opacity-70">
            <div
                class="bg-gradient-to-br from-[#0a2136] to-[#1a3757] rounded-2xl p-6 md:p-8 max-w-md w-full mx-auto border-2 shadow-2xl border-[#0A2136] relative">

                <!-- Icono dinámico según tipo -->
                <div class="flex justify-center mb-6">
                    <div class="w-16 h-16 md:w-20 md:h-20 rounded-full flex items-center justify-center border-2 shadow-lg"
                        :class="{
                            'border-red-500 bg-red-900/30': modalType === 'depleted',
                            'border-yellow-500 bg-yellow-900/30': modalType === 'insufficient'
                        }">

                        <!-- Icono para energía insuficiente -->
                        <svg v-if="modalType === 'insufficient'" class="w-10 h-10 md:w-12 md:h-12 text-yellow-500"
                            fill="currentColor" viewBox="0 0 24 24">
                            <path d="M13 14h-2V9h2m0 9h-2v-2h2M1 21h22L12 2 1 21z" />
                        </svg>

                        <!-- Icono para energía agotada -->
                        <svg v-else class="w-10 h-10 md:w-12 md:h-12 text-red-500" fill="currentColor"
                            viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M3 5h16a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1Zm2 3v8h4V8H5Zm16 1h2v6h-2V9Z">
                            </path>
                        </svg>

                    </div>
                </div>

                <!-- Título dinámico -->
                <h2 class="text-xl md:text-2xl font-bold text-center text-white mb-3 md:mb-4">
                    {{ modalTitle }}
                </h2>

                <!-- Mensaje dinámico -->
                <div class="text-center text-gray-300 mb-5 md:mb-6">
                    <p class="mb-3 text-sm md:text-base">{{ modalMessage }}</p>
                    <div class="bg-gray-900/50 p-3 md:p-4 rounded-lg">
                        <p class="text-sm font-medium text-yellow-300 mb-1">
                            Actualmente tienes {{ currentEnergy }} de energía
                        </p>
                        <p class="text-xs md:text-sm">Recuperarás 1 punto de energía cada 20 minutos</p>
                        <p v-if="modalType === 'insufficient'" class="text-xs text-gray-400 mt-2">
                            Se requieren al menos {{ requiredEnergy }} para esta lección
                        </p>
                        <p v-else class="text-xs text-gray-400 mt-2">
                            Tiempo para recuperar completamente tu energía: {{ recoveryTime }}
                        </p>
                    </div>
                </div>

                <!-- Opciones -->
                <div class="space-y-3 md:space-y-4">
                    <!-- Botón Volver (siempre arriba, siempre w-full) -->
                    <button @click="handleReturn"
                        class="bg-[#31771c] hover:bg-[#58cc02] uppercase text-white py-3 px-4 rounded-lg font-semibold transition-all duration-300 flex items-center justify-center gap-2 text-sm md:text-base w-full">
                        <svg class="w-4 h-4 md:w-5 md:h-5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd"
                                d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z"
                                clip-rule="evenodd" />
                        </svg>
                        {{ returnButtonText }}
                    </button>

                    <!-- Botones inferiores con ref para contar elementos -->
                    <div :ref="el => buttonsContainerRef = el" :class="getButtonsGridClasses()">
                        <!-- Botón Seguir adelante -->
                        <button @click="handleClose" v-if="modalType === 'insufficient'"
                            class="text-[#31771c] hover:text-[#58cc02] py-3 px-4 border border-[#31771c] hover:border-[#58cc02] rounded-lg font-semibold transition-all duration-300 flex items-center justify-center gap-2 text-sm md:text-base w-full">
                            Seguir adelante
                        </button>

                        <!-- Botón Practicar -->
                        <!-- <button @click="handlePractice" v-if="showPracticeButton"
                            class="text-[#715c1c] hover:text-[#FFC10A] py-3 px-4 border border-[#715c1c] hover:border-[#FFC10A] rounded-lg font-semibold transition-all duration-300 flex items-center justify-center gap-2 text-sm md:text-base w-full">
                            Recuperar energia
                        </button> -->
                    </div>
                </div>

                <!-- Información adicional -->
                <div class="mt-5 md:mt-6 pt-4 border-t border-gray-700/50">
                    <p class="text-xs text-gray-400 text-center">
                        💡 <span class="font-medium text-gray-300">Consejo:</span>
                        {{ tipMessage }}
                    </p>
                </div>
            </div>
        </div>
    </transition>
</template>

<script>
import { ref, watch, nextTick } from 'vue';

export default {
    name: 'NoEnergyModal',
    props: {
        show: {
            type: Boolean,
            default: false
        },
        modalType: {
            type: String,
            default: 'depleted',
            validator: (value) => ['insufficient', 'depleted'].includes(value)
        },
        currentEnergy: {
            type: Number,
            default: 0
        },
        maxEnergy: {
            type: Number,
            default: 15
        },
        requiredEnergy: {
            type: Number,
            default: 10
        },
        recoveryTime: {
            type: String,
            default: '20 minutos'
        },
        recoveryAmount: {
            type: Number,
            default: 1
        },
        redirectTo: {
            type: String,
            default: ''
        },
        showPracticeButton: {
            type: Boolean,
            default: true
        },
        currentLevel: {
            type: Object,
            required: false,
            default: () => ({ id: null })
        }
    },

    emits: ['close', 'practice', 'return', 'proceed-without-energy'],

    setup() {
        const buttonsContainerRef = ref(null);
        const visibleButtonCount = ref(0);

        const countVisibleButtons = () => {
            if (!buttonsContainerRef.value) return 0;

            // Contar solo los botones que son elementos directos y están visibles
            const buttons = buttonsContainerRef.value.querySelectorAll('button');
            let count = 0;

            buttons.forEach(button => {
                // Verificar si el botón está visible (no display: none ni visibility: hidden)
                const style = window.getComputedStyle(button);
                if (style.display !== 'none' && style.visibility !== 'hidden') {
                    count++;
                }
            });

            return count;
        };

        const updateButtonCount = () => {
            nextTick(() => {
                visibleButtonCount.value = countVisibleButtons();
            });
        };

        const getButtonsGridClasses = () => {
            const base = 'w-full';

            if (visibleButtonCount.value === 0) {
                return `${base} hidden`;
            } else if (visibleButtonCount.value === 1) {
                return `${base}`;
            } else if (visibleButtonCount.value === 2) {
                return `${base} grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4`;
            }

            return base;
        };

        return {
            buttonsContainerRef,
            getButtonsGridClasses,
            updateButtonCount
        };
    },

    computed: {
        modalTitle() {
            return this.modalType === 'insufficient'
                ? '¡Energía insuficiente!'
                : '¡Energía agotada!';
        },
        modalMessage() {
            if (this.modalType === 'insufficient') {
                return 'Necesitas al menos 10 de energía para seguir haciendo tus lecciones';
            }

            if (this.currentEnergy === 0) {
                return '¡Oh no! Te quedaste sin energía... ¿Y si nos tomamos un descanso?';
            }

            return 'Tu energía está muy baja. ¡Es momento de recargar!';
        },
        returnButtonText() {
            return this.modalType === 'insufficient' ? 'Volver' : 'Salir de la lección';
        },
        tipMessage() {
            return this.modalType === 'insufficient'
                ? 'Espera un poco para que tu energía se recupere o practica para ganar más'
                : 'Completa ejercicios de práctica para recuperar energía más rápido';
        },

        buttonCount() {
            let count = 1; // Botón "Volver" siempre está presente

            if (this.modalType === 'insufficient') {
                count++; // Botón "Seguir adelante"
            }

            if (this.showPracticeButton) {  // ← Si showPracticeButton es false, no cuenta este botón
                count++; // Botón "Practicar"
            }

            return count;
        },

        optionsContainerClasses() {
            // Clase base para el contenedor principal
            return 'space-y-3 md:space-y-4';
        },

        buttonsGridClasses() {
            const base = 'w-full';

            if (this.buttonCount === 2) {
                // Solo hay 1 botón inferior (además del "Volver")
                return `${base}`;
            } else if (this.buttonCount === 3) {
                // Hay 2 botones inferiores
                return `${base} grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4`;
            }

            // No hay botones inferiores (solo el "Volver")
            return `${base} hidden`;
        }

    },

    watch: {
        // Observar cambios en las props que afectan la visibilidad de botones
        modalType() {
            this.updateButtonCount();
        },
        showPracticeButton() {
            this.updateButtonCount();
        },
        show(newVal) {
            if (newVal) {
                // Esperar a que el DOM se actualice y luego contar los botones
                this.updateButtonCount();
            }
        }
    },

    methods: {
        handleReturn() {
            let route = this.redirectTo;

            if (!route && this.currentLevel?.id) {
                route = `/nivel/${this.currentLevel.id}`;
            }

            if (!route || route === '') {
                route = '/';
            }

            console.log('✅ Redirigiendo a:', route);

            try {
                this.$router.push(route);
            } catch (error) {
                console.error('❌ Error al redirigir:', error);
                this.$router.push('/');
            }

            this.$emit('return');
            this.$emit('close');
        },
        handlePractice() {
            this.$emit('practice');
            this.$emit('close');
        },

        handleClose() {
            this.$emit('close');
            this.$emit('proceed-without-energy');
        },

        closeModal() {
            this.$emit('close');
        }
    },
    data() {
        return {
            handleEscape: null
        };
    },
    mounted() {
        this.handleEscape = (e) => {
            if (e.key === 'Escape' && this.show) {
                this.closeModal();
            }
        };

        document.addEventListener('keydown', this.handleEscape);

        this.updateButtonCount();
    },
    beforeUnmount() {
        if (this.handleEscape) {
            document.removeEventListener('keydown', this.handleEscape);
        }
    }
};
</script>

<style scoped>
.modal-fade-enter-active,
.modal-fade-leave-active {
    transition: opacity 0.3s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
    opacity: 0;
}

/* Mejoras para desktop */
@media (min-width: 768px) {
    .fixed {
        align-items: center;
        justify-content: center;
    }

    .max-w-md {
        max-width: 28rem;
        /* 448px */
    }
}

@media (min-width: 1024px) {
    .max-w-md {
        max-width: 32rem;
        /* 512px */
    }
}
</style>