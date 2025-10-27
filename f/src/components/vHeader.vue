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
        <div class="bg-[#1f2937] rounded-xl px-4 pt-[5px] pb-5">

            <div class="max-w-xl mx-auto">
                <div class="flex justify-between items-center mb-3 mt-2">

                    <router-link :to="backRoute"
                        class="text-white text-sm flex items-center gap-2 px-3 pt-2 rounded-full transition-all duration-300 hover:scale-105">
                        <span class="font-bold">
                            <span v-if="!isMobile">← Volver</span>
                            <span v-else>

                                <svg fill="#d1d5db" height="20px" width="20px" version="1.1" id="Capa_1"
                                    xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                                    viewBox="0 0 460.775 460.775" xml:space="preserve">
                                    <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                    <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                                    <g id="SVGRepo_iconCarrier">
                                        <path
                                            d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z">
                                        </path>
                                    </g>
                                </svg>

                            </span>
                        </span>
                    </router-link>

                    <div class="text-center -mt-3">
                        <h2 class="text-sm font-semibold mb-[-5px]">
                            {{ subtitle }}
                        </h2>
                    </div>

                    <!-- Badge dinámico para versión progress -->
                    <div class="flex items-center gap-2 px-3 py-1 rounded-full transition-all duration-300 hover:scale-105 mt-[9px]"
                        :style="{
                            backgroundColor: currentVariantData.color + '40',
                            border: `2px solid ${currentVariantData.color}`
                        }" @click="$emit('show-all')">

                        <div class="w-4 h-4 rounded-full flex items-center justify-center text-white text-xs font-bold"
                            :style="{ backgroundColor: currentVariantData.color }">
                            {{ currentVariantInitial }}
                        </div>

                        <span v-if="!isMobile" class="text-xs font-semibold"
                            :style="{ color: currentVariantData.color }">
                            {{ currentVariantData.name }}
                        </span>

                    </div>
                </div>

                <div class="flex justify-center w-full mt-[-15px]">
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
                        <span v-if="!isMobile">← Volver</span>
                        <span v-else>

                            <svg fill="#d1d5db" height="20px" width="20px" version="1.1" id="Capa_1"
                                xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                                viewBox="0 0 460.775 460.775" xml:space="preserve">
                                <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                                <g id="SVGRepo_iconCarrier">
                                    <path
                                        d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z">
                                    </path>
                                </g>
                            </svg>

                        </span>
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
                    <span v-if="!isMobile" class="text-xs font-semibold" :style="{ color: currentVariantData.color }">
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

import { ref, onMounted, onBeforeUnmount } from 'vue';

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
            authStore: useAuthStore(),
            isMobile: false
        };
    },
    computed: {
        currentVariantData() {
            return dialectVariants.find(v => v.id === this.authStore.selectedVariant) || dialectVariants[3]; // 'all' por defecto
        },
        currentVariantInitial() {
            return this.currentVariantData.name.charAt(0);
        }
    },
    methods: {
        checkScreenSize() {
            this.isMobile = window.innerWidth < 768;
        }
    },
    mounted() {
        this.checkScreenSize();
        window.addEventListener('resize', this.checkScreenSize);
    },
    beforeUnmount() {
        window.removeEventListener('resize', this.checkScreenSize);
    }
};
</script>