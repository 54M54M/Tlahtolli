<template>
    <div class="flex flex-col items-center text-white min-h-screen mt-[-47px] md:mt-[-20px] md:pt-1">

        <Header variant="homeview" title="¿Que vamos aprender hoy?" class="mt-[-3%] md:mt-3"
            @show-all="goToLanguageSelection" @energy-click="() => { }" @language-changed="handleLanguageUpdate" />

        <!-- Loading skeleton -->
        <div v-if="loading" class="w-full space-y-4 mt-4">
            <div v-for="i in 3" :key="i" class="animate-pulse rounded-xl h-40 bg-gray-800 w-full"></div>
        </div>

        <!-- Error -->
        <div v-else-if="error" class="w-full mt-8 text-center text-red-400">
            <p>No se pudo conectar con el servidor.</p>
            <button @click="loadLevels" class="mt-3 px-4 py-2 bg-gray-700 rounded-lg text-sm">
                Reintentar
            </button>
        </div>

        <!-- Niveles -->
        <div v-else class="w-full mb-16 md:mb-4 pt-[1%]">
            <div class="space-y-4">

                <!-- Niveles desbloqueados -->
                <router-link v-for="level in unlockedLevels" :key="level.id" :to="'/nivel/' + level.id"
                    class="w-full block">
                    <Card
                        class="rounded-xl text-white overflow-hidden shadow-lg transition-transform transform hover:scale-105"
                        :style="{ backgroundColor: level.color }">
                        <div class="relative p-4 cursor-pointer">
                            <div
                                class="absolute -left-7 -top-7 w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
                                <span class="text-2xl font-bold">{{ level.levelNum }}</span>
                            </div>
                            <div class="-mt-3 text-center">
                                <h2 class="text-sm font-semibold">{{ level.title }}</h2>
                                <h1 class="text-xl font-bold mt-1">{{ level.titleNative }}</h1>
                                <p class="text-sm mt-2">{{ level.description }}</p>
                            </div>
                            <div class="mt-6">
                                <div class="h-2 bg-white/30 rounded-full overflow-hidden">
                                    <div class="h-2 bg-white"
                                        :style="{ width: `${(level.completedUnits / level.totalUnits) * 100}%` }"></div>
                                </div>
                                <p class="text-xs text-center mt-2">
                                    {{ level.completedUnits }}/{{ level.totalUnits }} unidades
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
                                <span class="text-2xl font-bold">{{ level.levelNum }}</span>
                            </div>
                            <div class="absolute top-2 right-2">
                                <svg class="w-6 h-6 text-white/80" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd"
                                        d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"
                                        clip-rule="evenodd" />
                                </svg>
                            </div>
                            <div class="-mt-3 text-center">
                                <h2 class="text-sm font-semibold">{{ level.title }}</h2>
                                <h1 class="text-xl font-bold mt-1">{{ level.titleNative }}</h1>
                                <div class="mt-3 p-2 bg-black/20 rounded-lg">
                                    <p class="text-xs text-white/80">🔒 {{ level.unlockReq }}</p>
                                </div>
                            </div>
                            <div class="mt-6">
                                <div class="h-2 bg-white/20 rounded-full overflow-hidden">
                                    <div class="h-2 bg-white/40"
                                        :style="{ width: `${(level.completedUnits / level.totalUnits) * 100}%` }"></div>
                                </div>
                                <p class="text-xs text-center mt-2 text-white/70">
                                    {{ level.completedUnits }}/{{ level.totalUnits }} unidades
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
import { useAuthStore } from '../stores/auth.js'
import { useEnergyStore } from '../stores/energy.js'
import { learningApi } from '../api/apiClient.js'
import { onMounted, computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { LanguageService } from '../data/services/LanguageService.js'
import Header from '../components/vHeader.vue'
import Badge from '../components/Badge.vue'
import Card from '../components/Card.vue'

export default {
    name: 'Inicio',
    components: { Badge, Card, Header },
    setup() {
        const authStore = useAuthStore()
        const energyStore = useEnergyStore()
        const router = useRouter()
        const languageService = new LanguageService()

        const levels = ref([])
        const loading = ref(false)
        const error = ref(false)

        const unlockedLevels = computed(() => levels.value.filter(l => !l.locked))
        const lockedLevels = computed(() => levels.value.filter(l => l.locked))

        const loadLevels = async () => {
            if (!authStore.selectedLangId || !authStore.user) {
                console.warn('[HomeView] loadLevels abortado — selectedLangId:', authStore.selectedLangId)
                return
            }

            loading.value = true
            error.value = false
            try {
                levels.value = await learningApi.getLevels(
                    authStore.selectedLangId,
                    authStore.user.id
                )
            } catch (err) {
                console.error('[HomeView] loadLevels:', err)
                error.value = true
            } finally {
                loading.value = false
            }
        }

        const goToLanguageSelection = () => router.push('/select-language')

        const handleLanguageUpdate = async () => {
            await loadLevels()
        }

        // Watcher: si selectedLangId llega tarde (initialize() async todavía resolviendo),
        // dispara loadLevels automáticamente sin recargar la página.
        watch(
            () => authStore.selectedLangId,
            (newId, oldId) => {
                if (newId && newId !== oldId && levels.value.length === 0) {
                    console.log('[HomeView] selectedLangId disponible vía watch:', newId)
                    loadLevels()
                }
            }
        )

        onMounted(async () => {
            if (!authStore.selectedLanguage) {
                router.push('/select-language')
                return
            }

            const userId = authStore.user?.id || 1
            await energyStore.initializeEnergy(userId)

            // Si selectedLangId ya está listo (persist funcionó), carga directo.
            // Si no, llamar initialize() para que lo resuelva; el watch lo detectará.
            if (authStore.selectedLangId) {
                await loadLevels()
            } else {
                console.warn('[HomeView] selectedLangId null al montar, llamando initialize...')
                await authStore.initialize()
                // initialize puede haberlo resuelto sincrónicamente; intentar de nuevo
                if (authStore.selectedLangId) {
                    await loadLevels()
                }
                // Si aún sigue null, el watch lo atrapará cuando Pinia lo reactive
            }
        })

        return {
            levels, loading, error,
            unlockedLevels, lockedLevels,
            loadLevels, goToLanguageSelection,
            handleLanguageUpdate,
            authStore, energyStore,
        }
    },
    methods: {
        getLanguageTitle(level) {
            return level.titleNative || level.title
        },
    },
}
</script>