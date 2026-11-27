<template>
    <div v-if="show" class="tl-kb fixed bottom-0 left-0 right-0 bg-gray-800 border-t border-gray-700 p-4 z-50">
        <div class="max-w-2xl mx-auto">
            <div class="flex justify-between items-start mb-2">
                <h3 class="text-lg font-semibold md:text-xl" :class="titleClass">{{ title }}</h3>
                <button v-if="reportContext" type="button" @click="reporting = true"
                    class="tl-flat -mt-1 -mr-1 p-2 rounded-lg text-gray-400 hover:text-white hover:bg-gray-700"
                    title="Reportar un problema" aria-label="Reportar un problema">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 24 24" fill="none"
                        stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M4 22V4" />
                        <path d="M4 4h12l-2 4 2 4H4" />
                    </svg>
                </button>
            </div>
            <p class="text-gray-300 mb-4 md:text-xl">{{ message }}</p>
            <div class="flex justify-end p-[4px]">
                <button @click="handleContinue"
                    :class="[isCorrect ? 'bg-turquesa-deep hover:bg-turquesa-deeper' : 'bg-error-deep hover:bg-error-deep/90']"
                    class="w-full md:w-auto md:float-right py-5 md:py-3 px-8 rounded-lg text-lg font-medium">
                    Entendido
                </button>
            </div>
        </div>
        <ReportModal :show="reporting" :is-correct="isCorrect" :context="reportContext || {}"
            @close="reporting = false" />
    </div>
</template>

<script>
import ReportModal from './ReportModal.vue';

export default {
    name: 'FeedbackModal',
    components: { ReportModal },
    data() {
        return { reporting: false };
    },
    props: {
        show: {
            type: Boolean,
            default: false
        },
        title: {
            type: String,
            default: ''
        },
        message: {
            type: String,
            default: ''
        },
        isCorrect: {
            type: Boolean,
            default: false
        },
        /** Datos del ejercicio para "Reportar un problema" (sin esto no se muestra la bandera) */
        reportContext: {
            type: Object,
            default: null
        }
    },
    watch: {
        show(v) { if (!v) this.reporting = false; }
    },
    computed: {
        titleClass() {
            return this.isCorrect ? 'text-green-400' : 'text-error';
        }
    },
    methods: {
        handleContinue() {
            if (this.reporting) return;
            this.$emit('continue');
        }
    }
};
</script>