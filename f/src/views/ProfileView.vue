<template>
    <div class="bg-[#0A2136] text-white">
        <Header variant="simple" title="Perfil" class="md:hidden pt-6 md:pt-5" />

        <main class="container mx-auto px-4 py-1 md:py-2 pb-16 md:pb-20">
            <div class="max-w-md mx-auto">
                <div class="bg-gray-800 rounded-lg p-3 pb-[1px] md:p-4 md:pb-[2px] mb-3 md:mb-4">
                    <UserProfile :user="userData" />
                </div>

                <Tab :tabs="[
                    { value: 'achievements', label: 'Logros' },
                    { value: 'settings', label: 'Ajustes' }
                ]" v-model="currentTab" />

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
                            <button
                                class="w-full bg-gray-700 border-gray-600 hover:bg-gray-600 rounded p-2 cursor-no-drop">
                                Editar perfil
                            </button>
                            <button
                                class="w-full bg-gray-700 border-gray-600 hover:bg-gray-600 rounded p-2 cursor-no-drop">
                                Cambiar contraseña
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
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

import Header from '../components/vHeader.vue';
import Card from '../components/Card.vue';
import Tab from '../components/Tab.vue';

import UserProfile from '../components/UserProfile.vue';
import AchievementsList from '../components/AchievementsList.vue';
import SettingsPanel from '../components/SettingsPanel.vue';

import { userData, achievementsData } from '../lib/data.js';

const currentTab = ref('achievements');
const preferredDialect = ref('all');
const soundEffects = ref(true);
const autoPronunciation = ref(true);
const darkMode = ref(true);

const unlockedAchievements = computed(() =>
    achievementsData.filter(a => a.earned)
);

// Función de logout
const authStore = useAuthStore()
const router = useRouter()

const logout = () => {
    authStore.logout()
    router.push('/login')
}
</script>