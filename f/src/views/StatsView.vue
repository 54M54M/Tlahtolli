<template>
    <div class="bg-[#0A2136]">
        <Header variant="simple" :title="'Estadisticas'" class="md:hidden pt-6 md:pt-5" />
        <!-- ProgressAside adaptado para móvil -->
        <ProgressAside class="pt-4 pb-20" />

        <!-- easter egg -->
        <div class="hidden md:block text-4xl pt-40 italic text-center py-2">
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

export default {
    name: 'StatsView',
    components: {
        ProgressAside,
        Header
    }
}
</script>