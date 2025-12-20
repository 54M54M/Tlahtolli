<template>
  <Layout />
</template>

<script>
import { onMounted } from 'vue';
import Layout from './layouts/Layout.vue';
import { useAuthStore } from './stores/auth';
import { useEnergyStore } from './stores/energy';

export default {
  name: 'App',
  components: {
    Layout
  },
  setup() {
    // Inicializar el store de autenticación
    const authStore = useAuthStore();
    authStore.initialize();

    // INICIALIZAR ENERGÍA GLOBALMENTE
    const energyStore = useEnergyStore();

    // Sincronizar energía al iniciar la app
    const initEnergy = async () => {
      try {
        const userId = authStore.user?.id || 1;
        await energyStore.syncFromLocalStorage(userId);
        // console.log('⚡ Energía global inicializada');
      } catch (error) {
        console.error('Error inicializando energía:', error);
      }
    };
    // Ejecutar después de que el componente esté montado
    onMounted(() => {
      initEnergy();
    });
  }
}
</script>