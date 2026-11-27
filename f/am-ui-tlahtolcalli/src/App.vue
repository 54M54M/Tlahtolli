<template>
  <Layout />
  <!-- PWA: aviso de versión nueva y pantalla sin conexión -->
  <UpdatePrompt />
  <OfflineScreen />
  <!-- Solo en el front de desarrollo: recuerda en qué sitio estás -->
  <div v-if="isDevSite" class="fixed bottom-2 left-2 z-[200] pointer-events-none select-none
              text-[10px] font-bold uppercase tracking-widest px-2 py-1 rounded bg-amber-500 text-black shadow">
    Desarrollo
  </div>
</template>

<script>
import { onMounted } from 'vue'
import Layout from './layouts/Layout.vue'
import UpdatePrompt from './components/UpdatePrompt.vue'
import OfflineScreen from './components/OfflineScreen.vue'
import { useAuthStore } from './stores/auth.js'
import { useEnergyStore } from './stores/energy.js'
import { IS_DEV_SITE } from './api/apiClient.js'
import { setupRefreshOnReturn } from './data/freshness.js'

export default {
  name: 'App',
  components: { Layout, UpdatePrompt, OfflineScreen },
  setup() {
    const authStore = useAuthStore()
    const energyStore = useEnergyStore()

    const isDevSite = IS_DEV_SITE

    onMounted(async () => {
      // 1. Inicializar auth PRIMERO — resuelve el usuario real desde la API
      await authStore.initialize()
      setupRefreshOnReturn()

      // 2. Solo inicializar energía si tenemos un userId válido
      const userId = authStore.user?.id
      if (userId) {
        try {
          await energyStore.initializeEnergy(userId)
        } catch (err) {
          console.error('[App] Error inicializando energía:', err)
        }
      }
    })

    return { isDevSite }
  },
}
</script>