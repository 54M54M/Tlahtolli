<template>
    <div v-if="show" class="fixed bottom-0 left-0 right-0 bg-gray-800 border-t border-gray-700 p-4 z-50">
        <div class="max-w-2xl mx-auto">
            <div class="flex justify-between items-start mb-2">
                <h3 class="text-lg font-semibold md:text-xl" :class="titleClass">{{ title }}</h3>
            </div>
            <p class="text-gray-300 mb-4 md:text-xl">{{ message }}</p>
            <div class="flex justify-end p-[4px]">
                <button @click="handleContinue"
                    :class="[isCorrect ? 'bg-[#31771c] hover:bg-[#58cc02]' : 'bg-red-700 hover:bg-red-600']"
                    class="w-full md:w-auto md:float-right py-5 md:py-3 px-8 rounded-lg text-lg font-medium">
                    Entendido
                </button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'FeedbackModal',
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
        }
    },
    computed: {
        titleClass() {
            return this.isCorrect ? 'text-green-400' : 'text-red-400';
        }
    },
    methods: {
        handleContinue() {
            this.$emit('continue');
        }
    }
};
</script>