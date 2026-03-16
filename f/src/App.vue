<template>
  <Layout />
</template>

<script>
import { onMounted } from 'vue'
import Layout from './layouts/Layout.vue'
import { useAuthStore } from './stores/auth.js'
import { useEnergyStore } from './stores/energy.js'

export default {
  name: 'App',
  components: { Layout },
  setup() {
    const authStore = useAuthStore()
    const energyStore = useEnergyStore()

    onMounted(async () => {
      // 1. Inicializar auth PRIMERO — resuelve el usuario real desde la API
      await authStore.initialize()

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
  },
}
</script>