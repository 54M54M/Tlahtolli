<!-- HAY QUE VER SI PUEDO OBTENER LOS PORCENTAJES DE AVANCE DE LOS LOGROS -->
<template>
    <div class="bg-[#0A2136] text-white">
        <Header variant="simple" title="Perfil" class="md:hidden pt-6 md:pt-5" />

        <main class="container mx-auto py-1 md:py-2 pb-16 md:pb-20">
            <div class="md:w-full">
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

                        <!-- Loading state -->
                        <div v-if="loading" class="text-center py-6">
                            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-white mx-auto"></div>
                        </div>

                        <!-- Grid adaptable según cantidad de logros -->
                        <div v-else-if="achievementsWithProgress.length > 0" class="grid gap-2 md:gap-3" :class="{
                            'grid-cols-1 max-w-xs mx-auto': achievementsWithProgress.length === 1,
                            'grid-cols-2 max-w-md mx-auto': achievementsWithProgress.length === 2,
                            'grid-cols-3 max-w-lg mx-auto': achievementsWithProgress.length === 3,
                            'grid-cols-4': achievementsWithProgress.length >= 4
                        }">
                            <div v-for="achievement in achievementsWithProgress" :key="achievement.achievement.id"
                                class="aspect-square rounded-lg flex flex-col items-center justify-center p-2 cursor-pointer bg-gray-700/30 hover:bg-gray-700/50 transition-colors"
                                @click="selectedAchievement = achievement" :title="achievement.achievement.requirement">
                                <div class="text-2xl mb-1 opacity-30">
                                    {{ achievement.achievement.icon }}
                                </div>
                                <p class="text-[10px] text-center truncate w-full text-gray-500">
                                    {{ achievement.achievement.title }}
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
                        <div v-else-if="!loading" class="text-center py-8 text-gray-500">
                            <div class="text-4xl mb-2">⏳</div>
                            <p class="text-sm">Completa más lecciones para ver el progreso de logros</p>
                            <p class="text-xs mt-1">Los logros aparecerán aquí cuando empieces a progresar</p>
                        </div>
                    </Card>

                    <!-- Logros desbloqueados -->
                    <Card class="bg-gray-800 rounded-lg p-3 md:p-4">
                        <h3 class="font-bold mb-3">Logros desbloqueados</h3>

                        <div v-if="loading" class="text-center py-4">
                            <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-white mx-auto"></div>
                        </div>

                        <template v-else-if="earnedAchievements.length > 0">
                            <div v-for="ach in earnedAchievements" :key="ach.achievement.id"
                                class="flex items-center gap-3 p-3 bg-gray-700/30 rounded-lg mb-2 transition-transform hover:scale-[1.02]">
                                <div class="w-10 h-10 rounded-lg flex items-center justify-center text-xl flex-shrink-0"
                                    :style="{ backgroundColor: getRarityColor(ach.achievement.rarity) + '20', color: getRarityColor(ach.achievement.rarity) }">
                                    {{ ach.achievement.icon }}
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h4 class="font-medium text-sm">{{ ach.achievement.title }}</h4>
                                    <p class="text-xs text-gray-400 truncate">{{ ach.achievement.description }}</p>
                                    <div class="flex items-center gap-2 mt-1">
                                        <span class="text-xs text-green-400">+{{ ach.achievement.xpReward }} XP</span>
                                        <span v-if="ach.earnedAt" class="text-xs text-gray-500">
                                            {{ formatDate(ach.earnedAt) }}
                                        </span>
                                    </div>
                                </div>
                                <span v-if="ach.achievement.rarity !== 'common'"
                                    class="text-xs px-2 py-1 rounded-full text-white flex-shrink-0"
                                    :style="{ backgroundColor: getRarityColor(ach.achievement.rarity) }">
                                    {{ rarityText(ach.achievement.rarity) }}
                                </span>
                            </div>
                        </template>

                        <div v-else class="text-gray-400 text-sm text-center py-4">
                            <div class="text-4xl mb-2">🏆</div>
                            <p>No has desbloqueado logros todavía.</p>
                            <p class="text-xs mt-1">¡Completa lecciones para desbloquear logros!</p>
                        </div>
                    </Card>
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
                                <span>{{ userData?.username }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-400">Miembro desde</span>
                                <span class="truncate">{{ userData?.joinDate }}</span>
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
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';

import Header from '../components/vHeader.vue';
import Card from '../components/Card.vue';
import Tab from '../components/Tab.vue';
import UserProfile from '../components/UserProfile.vue';
import SettingsPanel from '../components/SettingsPanel.vue';

import { achievementsApi } from '../api/apiClient.js';
import { LanguageService } from '../data/services/LanguageService.js';
import { LocalStorageService } from '../data/storage/LocalStorageService.js';

// ── Estado ──────────────────────────────────────────────────────────────────
const currentTab = ref('achievements');
const preferredLanguage = ref('nhce');
const soundEffects = ref(true);
const autoPronunciation = ref(true);
const darkMode = ref(true);
const loading = ref(false);
const allAchievements = ref([]);  // [{achievement: {...}, earned: bool, earnedAt: date}]
const selectedAchievement = ref(null);

const authStore = useAuthStore();
const languageService = new LanguageService();
const router = useRouter();

// ── Datos del usuario desde el store (ya cargado por auth.initialize) ──────
const userData = computed(() => {
    if (!authStore.user) return null;
    const u = authStore.user;
    return {
        id: u.id,
        name: u.fullName || u.full_name || 'UserDemo',
        username: u.username,
        email: u.email,
        level: u.userLevel || u.user_level || 1,
        xp: u.xp || 0,
        xpToNextLevel: 1000,
        streak: u.streak || 0,
        joinDate: u.joinDate || u.join_date || '',
    };
});

const currentLanguageName = computed(() => {
    if (!authStore.selectedLanguage) return 'No seleccionado';
    return languageService.getLanguageInfo(authStore.selectedLanguage)?.name || 'Idioma no encontrado';
});

// ── Logros computados desde la API ───────────────────────────────────────────
const earnedAchievements = computed(() =>
    allAchievements.value.filter(a => a.earned)
);

const achievementsWithProgress = computed(() => {
    return allAchievements.value.filter(achievement => {
        // Mostrar solo logros NO desbloqueados Y con progreso entre 1% y 99%
        return !achievement.earned &&
            achievement.progress &&
            achievement.progress.percentage > 0 &&
            achievement.progress.percentage < 100;
    });
});

// ── Helpers ──────────────────────────────────────────────────────────────────
const RARITY_COLORS = {
    common: '#58CC02',
    rare: '#1CB0F6',
    epic: '#A560E8',
    legendary: '#FF4B4B',
};

const getRarityColor = (rarity) => RARITY_COLORS[rarity] || '#58CC02';

const rarityText = (rarity) => ({
    common: 'Común',
    rare: 'Raro',
    epic: 'Épico',
    legendary: 'Legendario'
}[rarity] || rarity);

const formatDate = (dateInput) => {
    if (!dateInput) return '';
    try {
        return new Date(dateInput).toLocaleDateString('es-MX', {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        });
    } catch {
        return '';
    }
};

// ── Carga de datos ───────────────────────────────────────────────────────────
const loadAchievements = async () => {
    if (!authStore.user?.id) return;
    loading.value = true;
    try {
        const result = await achievementsApi.getWithStatus(authStore.user.id);
        allAchievements.value = Array.isArray(result) ? result : [];
    } catch (err) {
        console.error('[ProfileView] loadAchievements:', err);
        allAchievements.value = [];
    } finally {
        loading.value = false;
    }
};

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

// ── Logout ───────────────────────────────────────────────────────────────────
const logout = () => {
    authStore.logout();
    router.push('/login');
};

// ── Montaje ──────────────────────────────────────────────────────────────────
onMounted(() => {
    loadAchievements();
});
</script>