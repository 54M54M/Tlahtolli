<template>
  <Layout />
</template>

<script>
import Layout from './layouts/Layout.vue';
import { useAuthStore } from './stores/auth';

export default {
  name: 'App',
  components: {
    Layout
  },
  setup() {
    // Inicializar el store de autenticación
    const authStore = useAuthStore();
    authStore.initialize();
  }
}
</script>