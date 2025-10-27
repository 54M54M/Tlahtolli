<template>
    <div class="bg-[#0A2136]">
        <Header variant="simple" :title="'Estadisticas'" class="md:hidden pt-6 md:pt-5" />
        <!-- ProgressAside adaptado para móvil -->
        <ProgressAside :class="statsClasses" />

        <!-- easter egg -->
        <div v-if="screenWidth >= 768" class="text-4xl pt-40 italic text-center py-2">
            <h1>
                ¿Cómo llegaste aquí? 👀 <br>
                ¿Qué haces en esta sección secreta?
            </h1>
        </div>

    </div>
</template>

<script>
import ProgressAside from '../components/ProgressAside.vue'
import Header from '../components/vHeader.vue';
import { ref, onMounted, onUnmounted, computed } from 'vue'

export default {
    name: 'StatsView',
    components: {
        ProgressAside,
        Header
    },
    setup() {
        const screenWidth = ref(0)
        const screenHeight = ref(0)

        // Computed para las clases del ProgressAside
        const statsClasses = computed(() => {
            const base = 'pt-4 pb-20'

            if (screenWidth.value >= 768) {
                return `${base} max-w-lg mx-auto`
            } else {
                return `${base} w-full`
            }
        })

        // Función para actualizar dimensiones
        const updateDimensions = () => {
            screenWidth.value = window.innerWidth
            screenHeight.value = window.innerHeight
        }

        onMounted(() => {
            updateDimensions()
            window.addEventListener('resize', updateDimensions)
        })

        onUnmounted(() => {
            window.removeEventListener('resize', updateDimensions)
        })

        return {
            screenWidth,
            screenHeight,
            statsClasses
        }
    }
}
</script>