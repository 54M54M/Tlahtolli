<template>
    <div class="md:mt-[70px] mt-[35px] md:mb-[-15px]">

        <!-- Loading -->
        <div v-if="loading" class="space-y-4">
            <div v-for="i in 3" :key="i" class="animate-pulse rounded-xl h-40 bg-gray-800 w-full"></div>
        </div>

        <template v-else>
            <Header variant="levels" :title="currentLevel.titleNative || currentLevel.title || ''"
                :subtitle="currentLevel.title || ''" @show-all="handleShowAll" :color="currentLevel.color"
                :backRoute="'/'" />

            <div class="space-y-4">
                <!-- Unidades desbloqueadas -->
                <router-link v-for="unit in unlockedUnits" :key="unit.id" :to="'/leccion/' + unit.id" class="block">
                    <div class="rounded-xl p-4 space-y-4 text-white transition-transform transform hover:scale-105"
                        :style="{ backgroundColor: unit.color || currentLevel.color || '#4bb101' }">

                        <!-- Sección de unidad -->
                        <div class="flex items-center gap-2">
                            <div
                                class="bg-white/20 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold">
                                {{ unit.unitNum || unit.id }}
                            </div>
                            <h3 class="font-bold">{{ unit.title }}</h3>

                            <!-- Unidad actual -->
                            <div v-if="unit.current" class="ml-auto flex items-center justify-center">
                                <svg width="40" height="32" viewBox="0 0 40 32" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <g clip-path="url(#clip0_7030_116434)">
                                        <path fill-rule="evenodd" clip-rule="evenodd"
                                            d="M22.0423 14.9989C23.4698 15.8749 23.4698 17.9491 22.0423 18.825L8.91839 26.8783C7.42288 27.796 5.5 26.7199 5.5 24.9653L5.5 8.85865C5.5 7.10401 7.42288 6.02791 8.9184 6.94562L22.0423 14.9989Z"
                                            fill="white" />
                                        <path fill-rule="evenodd" clip-rule="evenodd"
                                            d="M35.4535 14.9989C36.881 15.8749 36.881 17.9491 35.4535 18.825L22.3296 26.8783C20.8341 27.796 18.9112 26.7199 18.9112 24.9653L18.9112 8.85865C18.9112 7.10401 20.8341 6.02791 22.3296 6.94562L35.4535 14.9989Z"
                                            fill="white" />
                                    </g>
                                    <defs>
                                        <clipPath id="clip0_7030_116434">
                                            <rect width="31" height="30" fill="white" transform="translate(5.5 2)" />
                                        </clipPath>
                                    </defs>
                                </svg>
                            </div>

                            <!-- Unidades completadas -->
                            <div v-if="unit.completed && !unit.current"
                                class="ml-auto flex items-center justify-center">
                                <svg width="42" height="34" viewBox="0 0 42 34" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <g clip-path="url(#clip0_7030_116430)">
                                        <path fill-rule="evenodd" clip-rule="evenodd"
                                            d="M18.5239 18.112L14.4053 13.9934C13.1459 12.734 11.104 12.734 9.84455 13.9934C8.58514 15.2528 8.58514 17.2947 9.84455 18.5541L16.1331 24.8427C16.7889 25.4985 17.6569 25.8128 18.5161 25.7856C19.3802 25.817 20.2545 25.5028 20.9142 24.8432L32.2521 13.5053C33.5115 12.2459 33.5115 10.204 32.2521 8.94456C30.9927 7.68515 28.9508 7.68515 27.6914 8.94456L18.5239 18.112Z"
                                            fill="white" />
                                    </g>
                                    <defs>
                                        <clipPath id="clip0_7030_116430">
                                            <rect width="24.2966" height="17.7878" fill="white"
                                                transform="translate(8.89999 8)" />
                                        </clipPath>
                                    </defs>
                                </svg>
                            </div>
                        </div>

                        <!-- Objetivo -->
                        <div class="bg-white/20 rounded-lg p-4 shadow-md">
                            <h4 class="font-bold mb-1">Objetivo</h4>
                            <p class="text-sm">{{ unit.objective }}</p>
                        </div>

                        <!-- Gramática básica -->
                        <div class="bg-white/20 rounded-lg p-4 shadow-md" v-if="unit.grammar">
                            <h4 class="font-bold mb-2 text-white flex items-center gap-2">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd"
                                        d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                                        clip-rule="evenodd" />
                                </svg>
                                Gramática básica
                            </h4>
                            <p class="text-sm bg-black/25 text-white p-3 rounded-lg font-medium backdrop-blur-sm">
                                {{ unit.grammar }}
                            </p>
                        </div>

                        <!-- Botón para unidades desbloqueadas -->
                        <button class="w-full bg-white text-black py-2 mt-4 rounded hover:bg-gray-100 font-bold">
                            {{ unit.completed ? 'Repasar lección' : 'Empezar lección' }}
                        </button>
                    </div>
                </router-link>

                <!-- Unidades bloqueadas -->
                <div v-for="unit in lockedUnits" :key="unit.id" class="block">
                    <div class="rounded-xl p-4 space-y-4 text-white opacity-60 cursor-pointer text-center"
                        :style="{ backgroundColor: unit.color || currentLevel.color || '#4bb101' }">

                        <!-- Sección de unidad -->
                        <div class="flex items-center gap-2">
                            <div
                                class="bg-white/20 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold">
                                {{ unit.unitNum || unit.id }}
                            </div>
                            <h3 class="font-bold">{{ unit.title }}</h3>
                        </div>

                        <!-- Requisito para desbloquear -->
                        <div class="mt-3 p-2 bg-black/20 rounded-lg">
                            <p class="text-xs text-white/80">🔒 {{ unit.unlockReq || 'Completa la unidad anterior' }}
                            </p>
                        </div>

                        <!-- Botón deshabilitado -->
                        <button disabled
                            class="w-full bg-gray-400 text-gray-200 py-2 mt-4 rounded font-bold cursor-pointer">
                            Unidad Bloqueada
                        </button>
                    </div>
                </div>
            </div>
        </template>

    </div>
    <!-- Componente "¿QUÉ SIGUE DESPUÉS?" -->
    <NextStage :current-level-id="id" :language="authStore.selectedLanguage" />
</template>

<script>
import Header from '../../components/vHeader.vue';
import Badge from '../../components/Badge.vue';
import NextStage from '../../components/NextStage.vue';
import { useAuthStore } from '../../stores/auth';
import { useEnergyStore } from '../../stores/energy';
import { learningApi } from '../../api/apiClient.js';

export default {
    name: 'Level',
    components: { Header, Badge, NextStage },
    props: {
        id: {
            type: [String, Number],
            required: true
        }
    },
    data() {
        return {
            authStore: useAuthStore(),
            energyStore: useEnergyStore(),
            currentLevel: {},
            units: [],
            loading: false,
        };
    },
    computed: {
        unlockedUnits() {
            return this.units.filter(u => !u.locked);
        },
        lockedUnits() {
            return this.units.filter(u => u.locked);
        },
    },
    watch: {
        '$route.params.id': {
            handler() {
                this.loadData();
            }
        }
    },
    async mounted() {
        const userId = this.authStore.user?.id || 1;
        await this.energyStore.initializeEnergy(userId);
        await this.loadData();
    },
    methods: {
        async loadData() {
            if (!this.authStore.selectedLangId || !this.authStore.user) return;
            this.loading = true;
            try {
                const levelId = Number(this.id);
                const levels = await learningApi.getLevels(
                    this.authStore.selectedLangId,
                    this.authStore.user.id
                );
                this.currentLevel = levels.find(l => l.id === levelId) || {};
                this.units = await learningApi.getUnits(levelId, this.authStore.user.id);
            } catch (err) {
                console.error('[LevelView] loadData:', err);
            } finally {
                this.loading = false;
            }
        },
        handleShowAll() { },
    }
};
</script>