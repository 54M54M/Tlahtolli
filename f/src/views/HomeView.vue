<template>
    <div class="flex flex-col items-center text-white min-h-screen mt-[-47px] md:mt-[-20px] md:py-8 md:pt-1">
        <h1 class="text-3xl font-bold mb-6">Elige un nivel</h1>

        <div class="w-full mb-12">
            <div class="space-y-4">
                <!-- Niveles desbloqueados -->
                <router-link v-for="level in unlockedLevels" :key="level.id" :to="'/nivel/' + level.id"
                    class="w-full block">
                    <Card
                        class="rounded-xl text-white overflow-hidden shadow-lg transition-transform transform hover:scale-105 focus:outline-none"
                        :style="{ backgroundColor: level.color }">
                        <div class="relative p-4 cursor-pointer">
                            <div
                                class="absolute -left-7 -top-7 w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
                                <span class="text-2xl font-bold">{{ level.id }}</span>
                            </div>
                            <div class="-mt-3 text-center">
                                <h2 class="text-sm font-semibold">{{ level.titleSpanish }}</h2>
                                <h1 class="text-xl font-bold mt-1">{{ getLanguageTitle(level) }}</h1>
                                <p class="text-sm mt-2">{{ level.description }}</p>
                            </div>
                            <div class="mt-6">
                                <div class="h-2 bg-white/30 rounded-full overflow-hidden">
                                    <div class="h-2 bg-white"
                                        :style="{ width: `${(level.completedUnits / level.units) * 100}%` }"></div>
                                </div>
                                <p class="text-xs text-center mt-2">{{ level.completedUnits }}/{{ level.units }}
                                    unidades
                                </p>
                            </div>
                        </div>
                    </Card>
                </router-link>

                <!-- Niveles bloqueados -->
                <div v-for="level in lockedLevels" :key="level.id" class="w-full block">
                    <Card class="rounded-xl text-white overflow-hidden shadow-lg opacity-60 cursor-pointer"
                        :style="{ backgroundColor: level.color }">
                        <div class="relative p-4">
                            <div
                                class="absolute -left-7 -top-7 w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
                                <span class="text-2xl font-bold">{{ level.id }}</span>
                            </div>
                            <!-- Icono de candado -->
                            <div class="absolute top-2 right-2">
                                <svg class="w-6 h-6 text-white/80" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd"
                                        d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
                                        clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="-mt-3 text-center">
                                <h2 class="text-sm font-semibold">{{ level.titleSpanish }}</h2>
                                <h1 class="text-xl font-bold mt-1">{{ getLanguageTitle(level) }}</h1>
                                <!-- <p class="text-sm mt-2">{{ level.description }}</p> -->

                                <!-- Requisito para desbloquear -->
                                <div class="mt-3 p-2 bg-black/20 rounded-lg">
                                    <p class="text-xs text-white/80">🔒 {{ level.unlockRequirement }}</p>
                                </div>
                            </div>
                            <div class="mt-6">
                                <div class="h-2 bg-white/20 rounded-full overflow-hidden">
                                    <div class="h-2 bg-white/40"
                                        :style="{ width: `${(level.completedUnits / level.units) * 100}%` }"></div>
                                </div>
                                <p class="text-xs text-center mt-2 text-white/70">{{ level.completedUnits }}/{{
                                    level.units }}
                                    unidades
                                </p>
                            </div>
                        </div>
                    </Card>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { onMounted, computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { LanguageService } from '../data/services/LanguageService.js'
import { LocalStorageService } from '../data/storage/LocalStorageService.js'
import { getLearningRepository } from '../data/repositories/RepositoryFactory.js';

import Badge from '../components/Badge.vue'
import Card from '../components/Card.vue'

export default {
    name: 'Inicio',
    components: {
        Badge,
        Card
    },
    setup() {
        const authStore = useAuthStore()
        const router = useRouter()
        const learningRepo = getLearningRepository();
        const languageService = new LanguageService()

        const currentLanguageLevels = ref([])

        const loadLevels = () => {
            if (!authStore.selectedLanguage) {
                currentLanguageLevels.value = []
                return
            }

            const freshRepo = getLearningRepository();
            const levels = freshRepo.getLevelsWithUnlockCheck(authStore.selectedLanguage)

            // USAR LocalStorageService DIRECTAMENTE
            const progress = LocalStorageService.getProgress(authStore.selectedLanguage)

            levels.forEach(level => {
                const levelProgress = progress.levels?.[level.id]
                if (levelProgress) {
                    level.completedUnits = levelProgress.completedUnits || 0
                }
            })

            currentLanguageLevels.value = levels
        }

        const unlockedLevels = computed(() => {
            return currentLanguageLevels.value.filter(level => !level.locked)
        })

        const lockedLevels = computed(() => {
            return currentLanguageLevels.value.filter(level => level.locked)
        })

        const currentLanguageData = computed(() => {
            if (!authStore.selectedLanguage) return null
            return languageService.getLanguageInfo(authStore.selectedLanguage)
        })

        const goToLanguageSelection = () => {
            router.push('/select-language')
        }

        onMounted(() => {
            if (!authStore.selectedLanguage) {
                router.push('/select-language')
            } else {
                loadLevels()
            }
        })

        const unwatch = router.afterEach(() => {
            loadLevels()
        })

        return {
            currentLanguageLevels,
            unlockedLevels,
            lockedLevels,
            currentLanguageData,
            goToLanguageSelection,
            loadLevels
        }
    },
    methods: {
        getLanguageTitle(level) {
            return level.titleNative || level.titleNahuatl || level.title
        }
    }
}
</script>