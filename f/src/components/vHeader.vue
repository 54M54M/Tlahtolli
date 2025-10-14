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
        :class="['py-3 px-4 text-white w-full fixed top-0 left-0 right-0 z-10 pt-2 pb-0']">
        <div class="bg-[#1f2937] rounded-xl px-4 pt-3 pb-5">
            
            <div class="max-w-xl mx-auto">
                <div class="flex justify-between items-center mb-3 mt-2">

                    <router-link :to="backRoute"
                        class="text-white text-sm flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105">
                        <span class="font-bold">
                            ← Volver
                        </span>
                    </router-link>

                    <div class="text-center -mt-3">
                        <h2 class="text-sm font-semibold">{{ subtitle }}</h2>
                        <h1 class="text-lg font-bold">{{ title }}</h1>
                    </div>

                    <!-- Badge dinámico para versión progress -->
                    <div class="flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105"
                        :style="{
                            backgroundColor: currentVariantData.color + '40',
                            border: `2px solid ${currentVariantData.color}`
                        }" @click="$emit('show-all')">
                        <div class="w-4 h-4 rounded-full flex items-center justify-center text-white text-xs font-bold"
                            :style="{ backgroundColor: currentVariantData.color }">
                            {{ currentVariantInitial }}
                        </div>
                        <span class="text-xs font-semibold" :style="{ color: currentVariantData.color }">
                            {{ currentVariantData.name }}
                        </span>
                    </div>
                </div>

                <div class="flex justify-center w-full">
                    <div class="w-7/12">
                        <ProgressBar :current="progressCurrent" :total="progressTotal" />
                    </div>
                </div>
            </div>
            
        </div>

    </div>

    <!-- Versión Default (volver-título/subtítulo-badge) -->
    <div v-else
        :class="['text-white w-full fixed top-0 left-0 md:left-[-70px] right-0 z-10 bg-[#0a2136] pt-4 pl-4 pr-4 pb-0']">
        <div class="max-w-xl mx-auto bg-[#1f2937] rounded-xl px-4 py-3">

            <div class="flex justify-between items-center">

                <router-link :to="backRoute"
                    class="text-white text-sm flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105">
                    <span class="font-bold">
                        ← Volver
                    </span>
                </router-link>

                <div class="text-center">
                    <h2 class="text-sm font-semibold">{{ subtitle }}</h2>
                    <h1 class="text-lg font-bold">{{ title }}</h1>
                </div>

                <!-- Badge dinámico para versión default -->
                <div class="flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105"
                    :style="{
                        backgroundColor: currentVariantData.color + '40',
                        border: `2px solid ${currentVariantData.color}`
                    }" @click="$emit('show-all')">
                    <div class="w-4 h-4 rounded-full flex items-center justify-center text-white text-xs font-bold"
                        :style="{ backgroundColor: currentVariantData.color }">
                        {{ currentVariantInitial }}
                    </div>
                    <span class="text-xs font-semibold" :style="{ color: currentVariantData.color }">
                        {{ currentVariantData.name }}
                    </span>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
import Badge from './Badge.vue';
import ProgressBar from './ProgressBar.vue';
import { useAuthStore } from '../stores/auth';
import { dialectVariants } from '../lib/data.js';

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
    emits: ['show-all'],
    data() {
        return {
            authStore: useAuthStore()
        };
    },
    computed: {
        currentVariantData() {
            return dialectVariants.find(v => v.id === this.authStore.selectedVariant) || dialectVariants[3]; // 'all' por defecto
        },
        currentVariantInitial() {
            return this.currentVariantData.name.charAt(0);
        }
    }
};
</script>