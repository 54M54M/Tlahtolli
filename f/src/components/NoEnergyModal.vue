<template>
    <!-- HAY QUE HACER EL MODAL RESPONSIVE PARA DESKTOP -->
    <transition name="modal-fade">
        <div v-if="show" class="fixed inset-0 z-50 flex items-end justify-center bg-black bg-opacity-70">
            <div
                class="bg-gradient-to-br from-[#0a2136] to-[#1a3757] rounded-2xl p-8 max-w-md w-full mx-auto border-2 shadow-2xl border-[#0A2136]">

                <!-- Icono dinámico según tipo -->
                <div class="flex justify-center mb-6">
                    <div class="w-20 h-20 rounded-full flex items-center justify-center border-4 shadow-lg"
                        :class="modalType === 'insufficient'">

                        <!-- Icono para energía insuficiente -->
                        <svg v-if="modalType === 'insufficient'" class="w-12 h-12" fill="currentColor"
                            viewBox="0 0 24 24">
                            <path d="M13 14h-2V9h2m0 9h-2v-2h2M1 21h22L12 2 1 21z" />
                        </svg>

                        <!-- Icono para energía agotada -->
                        <svg v-else class="w-12 h-12 text-white" fill="currentColor" viewBox="0 0 24 24"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M3 5h16a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1Zm2 3v8h4V8H5Zm16 1h2v6h-2V9Z">
                            </path>
                        </svg>

                    </div>
                </div>

                <!-- Título dinámico -->
                <h2 class="text-2xl font-bold text-center text-white mb-4">
                    {{ modalTitle }}
                </h2>

                <!-- Mensaje dinámico -->
                <div class="text-center text-gray-300 mb-6">
                    <p class="mb-3">{{ modalMessage }}</p>
                    <div class="bg-gray-900/50 p-4 rounded-lg">
                        <p class="text-sm font-medium text-yellow-300 mb-1">
                            Actualmente tienes {{ currentEnergy }} de energia
                        </p>
                        <p class="text-sm">Recuperarás 1 punto de energia cada 20 minutos</p>
                        <p v-if="modalType === 'insufficient'" class="text-xs text-gray-400 mt-2">
                            Se requieren al menos {{ requiredEnergy }} para esta lección
                        </p>
                        <p v-else class="text-xs text-gray-400 mt-2">
                            Tiempo para recuperar completamente tu energia: {{ recoveryTime }}
                        </p>
                    </div>
                </div>

                <!-- Opciones -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Botón Volver -->
                    <button @click="handleReturn"
                        class="bg-[#31771c] hover:bg-[#58cc02] uppercase text-white py-3 px-4 rounded-lg font-semibold transition-all duration-300 flex items-center justify-center gap-2">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd"
                                d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z"
                                clip-rule="evenodd" />
                        </svg>
                        {{ returnButtonText }}
                    </button>

                    <!-- Botón Practicar para recuperar -->
                    <button @click="handleClose" v-if="modalType === 'insufficient'"
                        class="text-[#31771c] hover:text-[#58cc02] py-3 px-4 border border-[#31771c] hover:border-[#58cc02] rounded-lg font-semibold transition-all duration-300 flex items-center justify-center gap-2">
                        Seguir adelante
                    </button>

                    <!-- <button @click="handlePractice" v-if="showPracticeButton"
                        class="bg-gradient-to-r from-yellow-600 to-yellow-500 hover:from-yellow-500 hover:to-yellow-400 text-white py-3 px-4 rounded-lg font-semibold transition-all duration-300 flex items-center justify-center gap-2">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd"
                                d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v3.586L7.707 9.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 10.586V7z"
                                clip-rule="evenodd" />
                        </svg>
                        Recuperar +1⚡
                    </button> -->
                </div>

                <!-- Información adicional -->
                <div class="mt-6 pt-4 border-t border-gray-700/50">
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
export default {
    name: 'NoEnergyModal',
    props: {
        show: {
            type: Boolean,
            default: false
        },
        // Tipo de modal: 'insufficient' (antes de lección) o 'depleted' (durante lección)
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
            // default: 25
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
    emits: ['close', 'practice', 'return'],
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

            // Para 'depleted'
            if (this.currentEnergy === 0) {
                return 'Oh no! Te quedaste sin energía... ¿Y si nos tomamos un descanso?';
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
        }
    },

    watch: {
        modalType(newType) {
            console.log('🔄 Modal type changed to:', newType);
        }
    },

    methods: {
        handleReturn() {
            // Construir la ruta: prioridad redirectTo, luego currentLevel, luego home
            let route = this.redirectTo;

            // console.log('🔍 Debug redirectTo:', this.redirectTo);
            // console.log('🔍 Debug currentLevel:', this.currentLevel);

            if (!route && this.currentLevel?.id) {
                route = `/nivel/${this.currentLevel.id}`;
            }

            if (!route || route === '') {
                route = '/';
            }

            console.log('✅ Redirigiendo a:', route); // Para debug

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
</style>