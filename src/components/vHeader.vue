<template>
    <!-- Versión Simple -->
    <header v-if="variant === 'simple'"
        class="py-3 px-4 text-white w-full fixed top-0 left-0 md:left-[-70px] right-20 z-20 bg-[#0a2136]">
        <div class="max-w-xl mx-auto flex justify-center items-center">
            <h1 class="text-lg font-bold">{{ title }}</h1>
        </div>
    </header>


    <!-- Versión con Progress Bar -->
    <div v-else-if="variant === 'progress'"
        :class="['py-3 px-4 text-white w-full fixed top-0 left-0 md:left-[-70px] right-0 z-10 bg-[#0a2136]']">
        <div class="max-w-xl mx-auto">
            <div class="flex justify-between items-center mb-3 mt-2">
                <router-link :to="backRoute" class="text-white hover:underline text-sm flex items-center">
                    ← Volver
                </router-link>

                <div class="text-center -mt-3">
                    <h2 class="text-sm font-semibold">{{ subtitle }}</h2>
                    <h1 class="text-lg font-bold">{{ title }}</h1>
                </div>

                <Badge class="bg-purple-600 text-xs px-3 rounded-full hover:bg-purple-700" @click="$emit('show-all')">
                    Todas
                </Badge>
            </div>

            <div class="flex justify-center w-full">
                <div class="w-7/12">
                    <ProgressBar :current="progressCurrent" :total="progressTotal" />
                </div>
            </div>
        </div>
    </div>

    <!-- Versión Default (volver-título/subtítulo-badge) -->
    <div v-else :class="['py-3 px-4 text-white w-full fixed top-0 left-0 md:left-[-70px] right-0 z-10']"
        :style="{ backgroundColor: color }">
        <div class="max-w-xl mx-auto">
            <div class="flex justify-between items-center">
                <router-link :to="backRoute" class="text-white hover:underline text-sm flex items-center">
                    ← Volver
                </router-link>

                <div class="text-center">
                    <h2 class="text-sm font-semibold">{{ subtitle }}</h2>
                    <h1 class="text-lg font-bold">{{ title }}</h1>
                </div>

                <Badge class="bg-purple-600 text-xs px-3 py-1 rounded-full hover:bg-purple-700"
                    @click="$emit('show-all')">
                    Todas
                </Badge>
            </div>
        </div>
    </div>
</template>

<script>
import Badge from './Badge.vue';
import ProgressBar from './ProgressBar.vue';

export default {
    name: 'Header',
    components: {
        Badge,
        ProgressBar
    },
    props: {
        variant: {
            type: String,
            default: 'default',
            validator: (value) => ['simple', 'progress', 'default'].includes(value)
        },
        title: {
            type: String,
            required: true
        },
        subtitle: {
            type: String,
            default: ''
        },
        backRoute: {
            type: [String, Object],
            default: '/'
        },
        progressCurrent: {
            type: Number,
            default: 0
        },
        progressTotal: {
            type: Number,
            default: 1
        },
        color: {
            type: String,
            default: '#58cc02' // Color por defecto (verde)
        }
    },
    emits: ['show-all']
};
</script>