<template>
    <div class="bg-[#0A2136] text-white">
        <Header variant="simple" title="Perfil" class="md:hidden pt-6 md:pt-5" />

        <main class="container mx-auto px-4 py-1 md:py-2 pb-16 md:pb-20">
            <div class="max-w-md mx-auto">
                <!-- ✅ CORRECCIÓN: Mostrar solo si userData existe -->
                <div v-if="userData" class="bg-gray-800 rounded-lg p-3 pb-[1px] md:p-4 md:pb-[2px] mb-3 md:mb-4">
                    <UserProfile :user="userData" />
                </div>

                <!-- ✅ Mostrar loading mientras se carga -->
                <div v-else class="bg-gray-800 rounded-lg p-4 mb-4 text-center">
                    <div class="animate-pulse">Cargando perfil...</div>
                </div>

                <Tab :tabs="[
                    { value: 'achievements', label: 'Logros' },
                    { value: 'settings', label: 'Ajustes' }
                ]" v-model="currentTab" />

                <!-- logros con progreso (1%-99%) -->
                <div v-if="currentTab === 'achievements'" class="mt-3 md:mt-4">
                    <!-- Sección de "Mis logros" con grid -->
                    <Card class="bg-gray-800 rounded-lg p-3 md:p-4 mb-3 md:mb-4">
                        <h3 class="font-bold mb-2 md:mb-3 flex items-center gap-2">
                            <span>🏆</span>
                            Mis logros
                        </h3>

                        <!-- Grid adaptable según cantidad de logros -->
                        <div class="grid gap-2 md:gap-3" :class="{
                            'grid-cols-1 max-w-xs mx-auto': achievementsWithProgress.length === 1,
                            'grid-cols-2 max-w-md mx-auto': achievementsWithProgress.length === 2,
                            'grid-cols-3 max-w-lg mx-auto': achievementsWithProgress.length === 3,
                            'grid-cols-4': achievementsWithProgress.length >= 4
                        }">
                            <div v-for="achievement in achievementsWithProgress" :key="achievement.id"
                                class="aspect-square rounded-lg flex flex-col items-center justify-center p-2 cursor-pointer bg-gray-700/30 hover:bg-gray-700/50 transition-colors"
                                @click="selectedAchievement = achievement" :title="achievement.requirement">
                                <div class="text-2xl mb-1 opacity-30">
                                    {{ achievement.icon }}
                                </div>
                                <p class="text-[10px] text-center truncate w-full text-gray-500">
                                    {{ achievement.title }}
                                </p>
                                <!-- Barra de progreso -->
                                <div class="w-full mt-1 bg-gray-600 rounded-full h-1">
                                    <div class="bg-green-500 h-1 rounded-full transition-all duration-300"
                                        :style="{ width: achievement.progress.percentage + '%' }"></div>
                                </div>
                                <p class="text-[8px] text-gray-400 mt-1">
                                    {{ Math.round(achievement.progress.percentage) }}%
                                </p>
                            </div>
                        </div>

                        <!-- Mensaje si no hay logros con progreso -->
                        <div v-if="achievementsWithProgress.length === 0 && !loading"
                            class="text-center py-8 text-gray-500">
                            <div class="text-4xl mb-2">⏳</div>
                            <p class="text-sm">Completa más lecciones para ver el progreso de logros</p>
                            <p class="text-xs mt-1">Los logros aparecerán aquí cuando empieces a progresar</p>
                        </div>
                    </Card>

                    <!-- Lista de logros desbloqueados -->
                    <AchievementsList :achievements="unlockedAchievements" />
                </div>

                <div v-if="currentTab === 'settings'" class="mt-3 md:mt-4 space-y-3 md:space-y-4">
                    <SettingsPanel :preferredLanguage="preferredLanguage" :soundEffects="soundEffects"
                        :autoPronunciation="autoPronunciation" :darkMode="darkMode"
                        @update:preferredLanguage="preferredLanguage = $event"
                        @update:soundEffects="soundEffects = $event"
                        @update:autoPronunciation="autoPronunciation = $event" @update:darkMode="darkMode = $event" />

                    <Card class="bg-gray-800 rounded-lg p-4">
                        <h3 class="font-bold mb-3">Información de la cuenta</h3>
                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <span class="text-gray-400">Usuario</span>
                                <span>{{ userData.username }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Miembro desde</span>
                                <span class="truncate">{{ userData.joinDate }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Idioma actual</span>
                                <span>{{ currentLanguageName }}</span>
                            </div>
                        </div>
                        <div class="mt-4 space-y-2">
                            <button
                                class="w-full bg-gray-700 border-gray-600 hover:bg-gray-600 rounded p-2 cursor-no-drop">
                                Editar perfil
                            </button>
                            <button
                                class="w-full bg-gray-700 border-gray-600 hover:bg-gray-600 rounded p-2 cursor-no-drop">
                                Cambiar contraseña
                            </button>

                            <!-- BOTÓN PARA LIMPIAR LOCALSTORAGE -->
                            <button @click="clearLocalStorage"
                                class="w-full bg-yellow-600 hover:bg-yellow-700 rounded p-2 transition-colors">
                                🗑️ Limpiar Datos Locales
                            </button>

                            <button @click="logout" class="w-full bg-red-500 hover:bg-red-600 rounded p-2 md:hidden">
                                Cerrar sesión
                            </button>
                        </div>
                    </Card>
                </div>
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

import Header from '../components/vHeader.vue';
import Card from '../components/Card.vue';
import Tab from '../components/Tab.vue';

import UserProfile from '../components/UserProfile.vue';
import AchievementsList from '../components/AchievementsList.vue';
import SettingsPanel from '../components/SettingsPanel.vue';

import { getUserRepository } from '../data/repositories/RepositoryFactory.js';
import { LanguageService } from '../data/services/LanguageService.js';
import { ProgressService } from '../data/services/ProgressService.js';
import { LocalStorageService } from '../data/storage/LocalStorageService.js';

const currentTab = ref('achievements');
const preferredLanguage = ref('nhce');
const soundEffects = ref(true);
const autoPronunciation = ref(true);
const darkMode = ref(true);
const selectedAchievement = ref(null);
const loading = ref(true);
const error = ref(null);

// Inicializar userData como ref y cargar datos
const userData = ref(null);
const userRepo = getUserRepository();

// Servicios
let progressService = null;
let allAchievements = ref([]);

// Computed para logros desbloqueados
const unlockedAchievements = computed(() => {
    return allAchievements.value.filter(a => a.earned);
});

// Cargar datos del usuario y logros al montar
onMounted(() => {
    loadUserData();
    loadAchievements();
});

// Función para cargar datos del usuario
const loadUserData = () => {
    try {
        // console.log('👤 Cargando datos del usuario...');
        const user = userRepo.getUser(1);
        // console.log('👤 Usuario cargado:', user);
        userData.value = user;
    } catch (error) {
        console.error('Error loading user data:', error);
        // Crear usuario temporal si hay error
        userData.value = {
            name: "Usuario",
            username: "usuario",
            level: 1,
            xp: 0,
            xpToNextLevel: 1000,
            joinDate: new Date().toLocaleDateString()
        };
    }
};

const loadAchievements = async () => {
    try {
        loading.value = true;
        error.value = null;

        // Inicializar servicio
        progressService = new ProgressService();

        // Verificar que el método existe
        if (typeof progressService.getAllAchievementsWithProgress === 'function') {
            const achievements = progressService.getAllAchievementsWithProgress(1);

            // Asignar directamente al ref reactivo
            allAchievements.value = Array.isArray(achievements) ? achievements : [];

            // console.log('Logros cargados exitosamente:', allAchievements.value);
            // console.log('Logros desbloqueados:', unlockedAchievements.value);
        } else {
            throw new Error('Método getAllAchievementsWithProgress no disponible');
        }

    } catch (err) {
        // console.error('Error loading achievements:', err);
        error.value = 'No se pudieron cargar los logros. Usando datos de respaldo.';

        // Usar datos de respaldo
        allAchievements.value = getFallbackAchievements();
    } finally {
        loading.value = false;
    }
};

const achievementsWithProgress = computed(() => {
    return allAchievements.value.filter(achievement => {
        // Mostrar solo logros NO desbloqueados Y con progreso entre 1% y 99%
        return !achievement.earned &&
            achievement.progress &&
            achievement.progress.percentage > 0 &&
            achievement.progress.percentage < 100;
    });
});

// Obtener nombre del idioma actual
const authStore = useAuthStore();
const languageService = new LanguageService();
const currentLanguageName = computed(() => {
    if (!authStore.selectedLanguage) return 'No seleccionado';
    const langInfo = languageService.getLanguageInfo(authStore.selectedLanguage);
    return langInfo?.name || 'Idioma no encontrado';
});

// Función para limpiar localStorage
const clearLocalStorage = () => {
    if (confirm('¿Estás seguro de que quieres limpiar todos los datos locales? Se perderá tu progreso actual.')) {
        LocalStorageService.clearAll();
        alert('✅ Datos locales limpiados correctamente. La página se recargará.');
        setTimeout(() => {
            window.location.reload();
        }, 1000);
    }
};

// Función de logout
const router = useRouter()
const logout = () => {
    authStore.logout()
    router.push('/login')
}
</script>