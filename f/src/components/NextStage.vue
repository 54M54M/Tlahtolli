<template>
    <div class="mt-8 p-6 mb-[73px] md:mb-[0px] rounded-xl border border-[#374151] shadow-sm">
        <div class="text-center">
            <!-- Información del siguiente nivel -->
            <div v-if="nextLevel" class="mb-1 pb-4 px-4 shadow-sm">
                <div class="flex flex-col items-center justify-center text-center">
                    <!-- Título -->
                    <div class="bg-[#374151] border border-[#374151] rounded-lg mb-4 mt-0">
                        <h3 class="text-xs font-bold text-neutral-400 py-2 px-4">¿QUÉ SIGUE DESPUÉS?</h3>
                    </div>

                    <!-- Contenedor de 3 elementos en grid -->
                    <div class="grid grid-cols-3 max-w-md mb-4">
                        <!-- Estado de bloqueo/desbloqueo -->
                        <div class="flex justify-center">
                            <div class="flex items-center justify-center">
                                <div class="flex items-center justify-center text-white font-bold text-lg">
                                    <!-- SVG para nivel bloqueado -->
                                    <svg v-if="nextLevel.locked" class="w-5 h-5" fill="currentColor"
                                        viewBox="0 0 20 20">
                                        <path fill-rule="evenodd"
                                            d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
                                            clip-rule="evenodd" />
                                    </svg>
                                    <!-- SVG para nivel desbloqueado -->
                                    <svg v-else class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                        <path
                                            d="M10 2a5 5 0 00-5 5v2a2 2 0 00-2 2v5a2 2 0 002 2h10a2 2 0 002-2v-5a2 2 0 00-2-2H7V7a3 3 0 015.905-.75 1 1 0 001.937-.5A5.002 5.002 0 0010 2z" />
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <!-- Etiqueta "Nivel" -->
                        <div class="text-xl font-bold text-white flex items-center justify-center">Nivel</div>

                        <!-- Número del nivel -->
                        <div class="flex items-center justify-center">
                            <div class="flex items-center justify-center text-white font-extrabold text-xl">
                                {{ nextLevel.id }}
                            </div>
                        </div>
                    </div>

                    <!-- Descripción -->
                    <p class="text-lg text-gray-300 max-w-md">{{ nextLevel.description }}</p>
                </div>
            </div>

            <!-- Botón de acción -->
            <div class="flex flex-col gap-3">
                <!-- Botón para nivel bloqueado o desbloqueado -->
                <button v-if="nextLevel" @click="handleLevelAction"
                    class="text-white font-bold py-3 px-6 rounded-lg transition-all duration-300 hover:opacity-90"
                    :style="{ backgroundColor: nextLevel.color }">
                    {{ nextLevel.locked ? '¿SALTAR AQUÍ?' : 'CONTINUAR' }}
                </button>
            </div>
        </div>
    </div>
</template>

<script>
import { useAuthStore } from '../stores/auth.js';
import { getLearningRepository } from '../data/repositories/RepositoryFactory.js';

export default {
    name: 'NextStage',
    props: {
        currentLevelId: {
            type: [String, Number],
            required: true
        },
        language: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            learningRepo: getLearningRepository(),
            authStore: useAuthStore()
        };
    },
    computed: {
        nextLevel() {
            const currentLevelNum = Number(this.currentLevelId);
            const allLevels = this.learningRepo.getLevels(this.language) || [];
            return allLevels.find(level => level.id === currentLevelNum + 1);
        }
    },
    methods: {
        handleSkip() {
            if (this.nextLevel) {
                console.log('Saltando al nivel rápido del nivel:', this.currentLevelId);
                // Navegar a la vista de QuickLevel del nivel ACTUAL
                this.$router.push(`/nivel-rapido/${this.currentLevelId}`);
            }
        },
        handleLevelAction() {
            if (this.nextLevel.locked) {
                // Si está bloqueado, usa la lógica existente de handleSkip
                this.handleSkip();
            } else {
                // Si está desbloqueado, navega al SIGUIENTE nivel
                this.$router.push(`/nivel/${this.nextLevel.id}`);
            }
        }
    },
};
</script>