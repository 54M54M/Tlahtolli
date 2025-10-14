<template>
    <div v-if="authStore.isAuthenticated" class="flex flex-col min-h-screen bg-[#0A2136] text-white">
        <div class="flex flex-1">
            <!-- Desktop Sidebar (hidden on mobile, variant selection and lesson) -->
            <DesktopAside v-if="!isVariantSelectionRoute && !isLessonRoute"
                class="hidden md:block border-r border-gray-700 fixed h-full z-20 w-60 bg-[#0A2136]" />

            <!-- Main Content Area -->
            <main class="flex-grow pt-16 pb-20 md:pt-8 md:pb-4 relative z-10 w-full" :class="{
                'md:ml-0 lg:mr-0': isVariantSelectionRoute || isLessonRoute,
                'md:ml-60 lg:mr-96': !isVariantSelectionRoute && !isLessonRoute
            }">
                <div class="w-full px-4 mx-auto max-w-xl">
                    <router-view />
                </div>
            </main>

            <!-- Progress Sidebar (hidden on mobile, variant selection and lesson) -->
            <DesktopProgressAside v-if="!isVariantSelectionRoute && !isLessonRoute"
                class="hidden lg:block border-l border-gray-700 fixed h-full z-20 right-0 w-96 bg-[#0A2136]" />
        </div>

        <!-- Mobile Navigation (hidden on desktop, variant selection and lesson) -->
        <MobileNav v-if="!isVariantSelectionRoute && !isLessonRoute"
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
import { computed } from 'vue'
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

        // Computed property para verificar si estamos en la ruta de selección de variante
        const isVariantSelectionRoute = computed(() => {
            return route.name === 'VariantSelection'
        })

        // Computed property para verificar si estamos en una lección
        const isLessonRoute = computed(() => {
            return route.name === 'Lesson' || route.path.includes('/leccion/')
        })

        return {
            authStore,
            isVariantSelectionRoute,
            isLessonRoute,
            isAuthenticated: computed(() => !!authStore.user)
        }
    }
}
</script>