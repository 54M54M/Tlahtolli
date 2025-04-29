<template>
    <div class="bg-[#0A2136] text-white">
        <Header variant="simple" title="Mi Perfil" backRoute="/" />

        <main class="container mx-auto px-4 py-6 md:py-10 pb-16 md:pb-20">
            <div class="max-w-md mx-auto">
                <UserProfile :user="userData" />

                <Tab :tabs="[
                    ...(isMobile ? [{ value: 'progress', label: 'Progreso' }] : []),
                    { value: 'achievements', label: 'Logros' },
                    { value: 'settings', label: 'Ajustes' }
                ]" v-model="currentTab" />

                <!-- Contenido de pestañas -->
                <div v-if="isMobile && currentTab === 'progress'" class="space-y-3 md:space-y-4 mt-3 md:mt-4">
                    <LearningStats :stats="stats" />
                    <DialectProgress :dialects="dialectProgress" />
                </div>

                <div v-if="currentTab === 'achievements'" class="mt-3 md:mt-4">
                    <Card class="bg-gray-800 rounded-lg p-3 md:p-4 mb-3 md:mb-4">
                        <h3 class="font-bold mb-2 md:mb-3 flex items-center gap-2">
                            <span>🏆</span>
                            Mis logros
                        </h3>
                        <div class="grid grid-cols-4 gap-2 md:gap-3">
                            <div v-for="achievement in achievementsData" :key="achievement.id"
                                class="aspect-square rounded-lg flex flex-col items-center justify-center p-2"
                                :class="achievement.earned ? 'bg-gray-700' : 'bg-gray-700/30'">
                                <div class="text-2xl mb-1" :class="achievement.earned ? 'opacity-100' : 'opacity-30'">
                                    {{ achievement.icon }}
                                </div>
                                <p class="text-[10px] text-center truncate w-full"
                                    :class="achievement.earned ? 'text-gray-300' : 'text-gray-500'">
                                    {{ achievement.title }}
                                </p>
                            </div>
                        </div>
                    </Card>

                    <AchievementsList :achievements="unlockedAchievements" />
                </div>

                <div v-if="currentTab === 'settings'" class="mt-3 md:mt-4 space-y-3 md:space-y-4">
                    <SettingsPanel :preferredDialect="preferredDialect" :soundEffects="soundEffects"
                        :autoPronunciation="autoPronunciation" :darkMode="darkMode"
                        @update:preferredDialect="preferredDialect = $event"
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
                                <span>{{ userData.joinDate }}</span>
                            </div>
                        </div>
                        <div class="mt-4 space-y-2">
                            <button class="w-full bg-gray-700 border-gray-600 hover:bg-gray-600 rounded p-2">
                                Editar perfil
                            </button>
                            <button class="w-full bg-gray-700 border-gray-600 hover:bg-gray-600 rounded p-2">
                                Cambiar contraseña
                            </button>
                            <button class="w-full bg-red-500 hover:bg-red-600 rounded p-2">
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
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
import Header from '../components/vHeader.vue';
import Card from '../components/Card.vue';
import Tab from '../components/Tab.vue';

import UserProfile from '../components/UserProfile.vue';
import LearningStats from '../components/LearningStats.vue';
import DialectProgress from '../components/DialectProgress.vue';
import AchievementsList from '../components/AchievementsList.vue';
import SettingsPanel from '../components/SettingsPanel.vue';

import { userData, achievementsData, statsData } from '../lib/data.js';

const currentTab = ref('progress');
const preferredDialect = ref('all');
const soundEffects = ref(true);
const autoPronunciation = ref(true);
const darkMode = ref(true);
const isMobile = ref(false);

// Función para verificar el tamaño de la pantalla
const checkScreenSize = () => {
    isMobile.value = window.innerWidth < 768; // 768px es el breakpoint típico para md en Tailwind
};

// Configurar el listener para cambios de tamaño
onMounted(() => {
    checkScreenSize();
    window.addEventListener('resize', checkScreenSize);

    // Si no es móvil y la pestaña actual es 'progress', cambiar a 'achievements'
    if (!isMobile.value && currentTab.value === 'progress') {
        currentTab.value = 'achievements';
    }
});

// Limpiar el listener al desmontar
onBeforeUnmount(() => {
    window.removeEventListener('resize', checkScreenSize);
});

// Datos computados
const stats = computed(() => [
    { label: 'Palabras aprendidas', value: statsData.wordsLearned },
    { label: 'Lecciones completadas', value: statsData.lessonsCompleted },
    { label: 'Lecciones perfectas', value: statsData.perfectLessons },
    { label: 'Días estudiados', value: statsData.daysStudied }
]);

const dialectProgress = computed(() => [
    { id: 'central', name: 'Central', progress: statsData.dialectProgress.central, color: '#58CC02' },
    { id: 'oriental', name: 'Oriental', progress: statsData.dialectProgress.oriental, color: '#FFA500' },
    { id: 'occidental', name: 'Occidental', progress: statsData.dialectProgress.occidental, color: '#FF4B4B' }
]);

const unlockedAchievements = computed(() =>
    achievementsData.filter(a => a.earned)
);
</script>