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
    </aside>
</template>

<script>
export default {
    name: 'DesktopAside'
}
</script>