<template>
    <div v-if="authStore.isAuthenticated" class="flex flex-col max-h-screen bg-[#0A2136] text-white">
        <!-- Loading global mientras se inicializa el idioma -->
        <div v-if="!authStore.isLanguageReady && !isLanguageSelectionRoute"
            class="fixed inset-0 flex items-center justify-center bg-[#0A2136] z-50">
            <div class="text-center">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
                <p>Cargando tu idioma...</p>
            </div>
        </div>

        <div v-else class="flex flex-1">
            <!-- Desktop Sidebar (hidden en mobile, language selection y lesson) -->
            <DesktopAside v-if="!isLanguageSelectionRoute && !isLessonRoute"
                class="hidden md:block border-r border-[#374151] fixed h-full z-20 w-60 bg-[#0A2136]" />

            <!-- Main Content Area -->
            <main class="flex-grow pt-16 pb-20 md:pt-8 md:pb-4 relative z-10 w-full" :class="{
                'md:ml-0 lg:mr-0': isLanguageSelectionRoute || isLessonRoute,
                'md:ml-60 lg:mr-96': !isLanguageSelectionRoute && !isLessonRoute
            }">
                <div class="w-full px-4 mx-auto max-w-xl">
                    <router-view />
                </div>
            </main>

            <!-- Progress Sidebar (hidden en mobile, language selection y lesson) -->
            <DesktopProgressAside v-if="!isLanguageSelectionRoute && !isLessonRoute && authStore.isLanguageReady"
                :class="asideClasses" />
        </div>

        <!-- Mobile Navigation (hidden en desktop, language selection y lesson) -->
        <MobileNav v-if="!isLanguageSelectionRoute && !isLessonRoute && authStore.isLanguageReady"
            class="fixed bottom-0 w-full z-30 md:hidden border-t border-gray-700 bg-[#0A2136]" />
    </div>

    <!-- Mostrar solo el router-view cuando no está autenticado -->
    <div v-else class="min-h-screen bg-[#0A2136]">
        <router-view />
    </div>
</template>

<script>
import DesktopAside from '../components/DesktopAside.vue'
import DesktopProgressAside from '../components/ProgressAside.vue'
import MobileNav from '../components/MobileNav.vue'
import { useAuthStore } from '../stores/auth'
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'

export default {
    name: 'Layout',
    components: {
        DesktopAside,
        MobileNav,
        DesktopProgressAside
    },
    setup() {
        const authStore = useAuthStore()
        const route = useRoute()
        const screenHeight = ref(0)

        // Computed property para verificar si estamos en la ruta de selección de idioma
        const isLanguageSelectionRoute = computed(() => {
            return route.name === 'LanguageSelection'
        })

        // Computed property para verificar si estamos en una lección
        const isLessonRoute = computed(() => {
            return route.name === 'Leccion' || route.path.includes('/leccion/')
        })

        // ============================================================================

        const asideClasses = computed(() => {
            const base = 'hidden lg:block border-l border-gray-700 fixed z-20 right-0 w-96 bg-[#0A2136]'

            if (screenHeight.value >= 700) {
                return `${base} h-screen lg:top-0 lg:translate-y-0 lg:pt-24`
            } else {
                return `${base} h-full`
            }
        })

        const updateHeight = () => {
            screenHeight.value = window.innerHeight
        }

        onMounted(() => {
            updateHeight()
            window.addEventListener('resize', updateHeight)

            // Inicializar el store si no está inicializado
            if (!authStore.isInitialized) {
                authStore.initialize()
            }
        })

        onUnmounted(() => {
            window.removeEventListener('resize', updateHeight)
        })

        // ============================================================================

        return {
            authStore,
            isLanguageSelectionRoute,
            isLessonRoute,
            asideClasses,
            isAuthenticated: computed(() => !!authStore.user)
        }
    }
}
</script>