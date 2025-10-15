<template>
    <nav v-if="!$route.meta.hideNav" class="md:hidden bg-gray-800 text-white fixed bottom-0 left-0 right-0">
        <div class="fixed bottom-0 inset-x-0 bg-[#0A2136] border-t border-gray-700 py-3">
            <div class="container mx-auto flex justify-around items-center">
                <router-link to="/" class="flex flex-col items-center group" active-class="text-blue-400"
                    exact-active-class="text-blue-500">
                    <div
                        class="w-8 h-8 flex items-center justify-center transition-colors duration-200 group-hover:text-amber-500">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                        </svg>
                    </div>
                    <span class="text-xs mt-1 transition-colors duration-200 group-hover:text-blue-400">Inicio</span>
                </router-link>

                <router-link to="/glosario" class="flex flex-col items-center group" active-class="text-blue-400"
                    exact-active-class="text-blue-500">
                    <div
                        class="w-8 h-8 flex items-center justify-center transition-colors duration-200 group-hover:text-amber-500">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
                        </svg>
                    </div>
                    <span class="text-xs mt-1 transition-colors duration-200 group-hover:text-blue-400">Glosario</span>
                </router-link>

                <!-- <router-link to="/mapa" class="flex flex-col items-center group" active-class="text-blue-400"
                    exact-active-class="text-blue-500">
                    <div
                        class="w-8 h-8 flex items-center justify-center transition-colors duration-200 group-hover:text-amber-500">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
                        </svg>
                    </div>
                    <span class="text-xs mt-1 transition-colors duration-200 group-hover:text-blue-400">Mapa</span>
                </router-link> -->

                <!-- <router-link to="/perfil" class="flex flex-col items-center group" active-class="text-blue-400"
                    exact-active-class="text-blue-500">
                    <div
                        class="w-8 h-8 flex items-center justify-center transition-colors duration-200 group-hover:text-amber-500">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                    <span class="text-xs mt-1 transition-colors duration-200 group-hover:text-blue-400">Perfil</span>
                </router-link> -->

                <button @click="logout" class="flex flex-col items-center group"
                    exact-active-class="text-blue-500">

                    <div class="w-8 h-8 flex items-center justify-center text-red-500 group-hover:text-red-400">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
                            stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                    </div>
                    <span class="text-xs mt-1 text-red-500 group-hover:text-red-400">Salir</span>

                </button>

            </div>
        </div>
    </nav>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

export default {
    name: 'MobileNav',
    setup() {
        const authStore = useAuthStore()
        const router = useRouter()

        const logout = () => {
            authStore.logout()
            router.push('/login')
        }

        return {
            logout
        }
    }
}
</script>