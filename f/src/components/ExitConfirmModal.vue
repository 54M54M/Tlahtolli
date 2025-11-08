<template>
    <div v-if="show" class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50 p-4">
        <div class="bg-gray-800 border border-gray-700 rounded-lg max-w-md w-full p-6">
            <div class="flex justify-between items-start mb-4">
                <h3 class="text-2xl font-semibold text-yellow-400">¿Salir de la lección?</h3>
            </div>
            <p class="text-gray-300 mb-6">Si sales ahora, perderás el progreso de esta lección. ¿Estás seguro?</p>
            <div class="flex flex-col space-y-3 sm:flex-row sm:space-y-0 sm:space-x-3 sm:justify-end">
                <button @click="handleClose"
                    class="bg-[#31771c] hover:bg-[#58cc02] text-white py-2 px-4 rounded-lg transition-colors">
                    Continuar lección
                </button>
                <button @click="handleConfirm"
                    class="bg-gray-700 hover:bg-gray-600 text-white py-2 px-4 rounded-lg transition-colors">
                    Salir
                </button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'ExitConfirmModal',
    props: {
        show: {
            type: Boolean,
            default: false
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