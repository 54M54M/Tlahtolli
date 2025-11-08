<template>
    <div v-if="show" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50 p-4">
        <div class="bg-gray-800 border border-gray-700 rounded-lg max-w-md w-full p-6">
            <div class="flex justify-between items-start mb-4">
                <h3 class="text-lg font-semibold text-yellow-400">{{ title }}</h3>
                <button @click="handleClose" class="text-gray-400 hover:text-white">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd"
                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                            clip-rule="evenodd" />
                    </svg>
                </button>
            </div>
            <p class="text-gray-300 mb-6">{{ message }}</p>
            <div class="flex justify-end space-x-3">
                <button @click="handleClose"
                    class="bg-gray-600 hover:bg-gray-700 text-white py-2 px-4 rounded-lg transition-colors">
                    {{ closeButtonText }}
                </button>
                <button @click="handleConfirm"
                    class="bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded-lg transition-colors">
                    {{ confirmButtonText }}
                </button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'WarningModal',
    props: {
        show: {
            type: Boolean,
            default: false
        },
        title: {
            type: String,
            default: '¡Espera, no te vayas!'
        },
        message: {
            type: String,
            default: 'Perderás tu progreso si te rindes ahora'
        },
        closeButtonText: {
            type: String,
            default: 'Seguir aprendiendo'
        },
        confirmButtonText: {
            type: String,
            default: 'Terminar sesión'
        }
    },
    methods: {
        handleClose() {
            this.$emit('close');
        },
        handleConfirm() {
            this.$emit('confirm');
        }
    }
};
</script>