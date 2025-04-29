import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // Escucha en todas las interfaces de red (incluyendo la IP local 192.168.1.75)
    port: 5173,      // Puerto opcional (puedes omitirlo si usas el predeterminado)
    strictPort: true, // Evita que Vite cambie el puerto si está ocupado
  },
});