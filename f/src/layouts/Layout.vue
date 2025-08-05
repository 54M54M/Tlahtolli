<template>
    <div class="flex flex-col min-h-screen bg-[#0A2136] text-white">
        <div class="flex flex-1">
            <!-- Desktop Sidebar (hidden on mobile) -->
            <DesktopAside class="hidden md:block border-r border-gray-700 fixed h-full z-20 w-60 bg-[#0A2136]" />

            <!-- Main Content Area -->
            <main class="flex-grow pt-16 pb-20 md:pt-8 md:pb-4 relative z-10 md:ml-60 lg:mr-96 w-full">
                <div class="w-full px-4 mx-auto max-w-xl">
                    <router-view />
                </div>
            </main>

            <!-- Progress Sidebar (hidden on mobile) -->
            <DesktopProgressAside
                class="hidden lg:block border-l border-gray-700 fixed h-full z-20 right-0 w-96 bg-[#0A2136]" />
        </div>

        <!-- Mobile Navigation (hidden on desktop) -->
        <MobileNav class="fixed bottom-0 w-full z-30 md:hidden border-t border-gray-700 bg-[#0A2136]" />
    </div>
</template>

<script>
import DesktopAside from '../components/DesktopAside.vue'
import DesktopProgressAside from '../components/ProgressAside.vue'
import MobileNav from '../components/MobileNav.vue'

export default {
    name: 'Layout',
    components: {
        DesktopAside,
        MobileNav,
        DesktopProgressAside
    }
}
</script>