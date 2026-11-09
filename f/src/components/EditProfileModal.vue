<template>
    <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" @click.self="$emit('close')">
        <div class="w-full max-w-md bg-surface-1 rounded-lg p-6 shadow-xl">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-lg font-bold">Editar perfil</h2>
                <button @click="$emit('close')" class="text-gray-400 hover:text-white transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <!-- Foto -->
            <div class="flex flex-col items-center mb-6">
                <div class="relative">
                    <UserAvatar :name="form.username" :size="96" />
                </div>
                <p class="text-xs text-gray-400 mt-2">Tu avatar se genera a partir de tu usuario</p>
            </div>

            <!-- Campos -->
            <div class="space-y-4">
                <div class="flex gap-3">
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1 text-gray-300">Nombre(s)</label>
                        <input v-model="form.firstName" type="text"
                            class="w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                    </div>
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1 text-gray-300">Apellido(s)</label>
                        <input v-model="form.lastName" type="text"
                            class="w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Usuario</label>
                    <input v-model="form.username" type="text"
                        class="w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Correo electrónico</label>
                    <input v-model="form.email" type="email"
                        class="w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-2.5 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                </div>
            </div>

            <div v-if="errorMsg" class="mt-4 p-3 bg-error-soft/40 border border-error rounded-lg text-error text-sm">
                {{ errorMsg }}
            </div>
            <div v-if="successMsg" class="mt-4 p-3 bg-green-900/40 border border-green-600 rounded-lg text-green-300 text-sm">
                {{ successMsg }}
            </div>

            <div class="flex gap-3 mt-6">
                <button @click="$emit('close')"
                    class="flex-1 bg-gray-700 hover:bg-gray-600 text-white font-semibold py-2.5 rounded-lg transition-colors">
                    Cancelar
                </button>
                <button @click="save" :disabled="loading"
                    class="flex-1 bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-50 text-white font-semibold py-2.5 rounded-lg transition-colors">
                    {{ loading ? 'Guardando...' : 'Guardar' }}
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useAuthStore } from '../stores/auth'
import { usersApi } from '../api/apiClient'
import UserAvatar from './UserAvatar.vue'

const emit = defineEmits(['close', 'updated'])

const authStore = useAuthStore()
const loading = ref(false)
const errorMsg = ref('')
const successMsg = ref('')

const u = authStore.user
const fullNameParts = (u?.fullName || u?.full_name || '').split(' ')

const form = reactive({
    firstName: fullNameParts[0] || '',
    lastName: fullNameParts.slice(1).join(' ') || '',
    username: u?.username || '',
    email: u?.email || '',
})

const save = async () => {
    if (!form.firstName || !form.lastName || !form.username || !form.email) {
        errorMsg.value = 'Todos los campos son obligatorios.'
        return
    }
    loading.value = true
    errorMsg.value = ''
    successMsg.value = ''
    try {
        const updated = await usersApi.update(u.id, {
            username: form.username,
            fullName: `${form.firstName} ${form.lastName}`,
            email: form.email,
            currentLang: u.currentLang ?? null,
        })
        authStore.user = { ...authStore.user, ...updated }
        successMsg.value = 'Perfil actualizado correctamente.'
        setTimeout(() => emit('updated', updated), 800)
    } catch (err) {
        errorMsg.value = err.message || 'No se pudo actualizar el perfil.'
    } finally {
        loading.value = false
    }
}
</script>
