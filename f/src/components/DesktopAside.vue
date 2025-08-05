<template>
    <aside
        class="hidden md:block md:w-52 bg-[#0A2136] text-white p-4 border-r border-gray-800 fixed left-0 top-0 h-full">
        <div class="flex flex-col space-y-6 mt-8">
            <router-link to="/" class="flex items-center space-x-2 p-2 rounded hover:bg-gray-700"
                active-class="text-blue-400" exact-active-class="text-blue-500">
                <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                    </svg>
                </div>
                <span>Inicio</span>
            </router-link>

            <router-link to="/diccionario" class="flex items-center space-x-2 p-2 rounded hover:bg-gray-700"
                active-class="text-blue-400" exact-active-class="text-blue-500">
                <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
                    </svg>
                </div>
                <span>Diccionario</span>
            </router-link>

            <router-link to="/mapa" class="flex items-center space-x-2 p-2 rounded hover:bg-gray-700"
                active-class="text-blue-400" exact-active-class="text-blue-500">
                <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
                    </svg>
                </div>
                <span>Mapa</span>
            </router-link>

            <router-link to="/perfil" class="flex items-center space-x-2 p-2 rounded hover:bg-gray-700"
                active-class="text-blue-400" exact-active-class="text-blue-500">
                <div class="w-8 h-8 flex items-center justify-center">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                </div>
                <span>Perfil</span>
            </router-link>
        </div>
        
        <div class="mt-auto mb-4">
            <div class="flex items-center space-x-3 p-3 rounded-lg bg-gray-800 mb-4">
                <img :src="authStore.user?.profileImage" class="w-10 h-10 rounded-full" />
                <div>
                    <p class="font-medium">{{ authStore.user?.name }}</p>
                    <p class="text-xs text-gray-400">@{{ authStore.user?.username }}</p>
                </div>
            </div>
            <button @click="logout"
                class="w-full flex items-center space-x-2 p-3 rounded-lg bg-red-600 hover:bg-red-700 text-white transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                </svg>
                <span>Cerrar sesión</span>
            </button>
        </div>
    </aside>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

export default {
    name: 'DesktopAside',
    setup() {
        const authStore = useAuthStore()
        const router = useRouter()

        const logout = () => {
            authStore.logout()
            router.push('/login')
        }

        return {
            authStore,
            logout
        }
    }
}
</script>