<template>
    <div class="min-h-screen bg-[#0A2136] text-white flex flex-col">

        <!-- Header -->
        <div class="flex items-center gap-3 px-4 py-4 border-b border-gray-700">
            <button @click="router.push('/perfil')" class="text-gray-400 hover:text-white transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                </svg>
            </button>
            <h1 class="text-lg font-bold">Editar perfil</h1>
        </div>

        <!-- Contenido -->
        <div class="flex-1 flex flex-col items-center px-4 py-8">
            <div class="w-full max-w-md space-y-6">

                <!-- Foto -->
                <div class="flex flex-col items-center">
                    <div class="relative">
                        <div class="w-24 h-24 rounded-full overflow-hidden bg-gray-700">
                            <img :src="placeholder" alt="Avatar" class="w-full h-full object-cover">
                        </div>
                        <button disabled title="Próximamente"
                            class="absolute bottom-0 right-0 bg-[#58CC02] rounded-full p-1.5 opacity-60 cursor-not-allowed">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                        </button>
                    </div>
                    <p class="text-xs text-gray-500 mt-2">Foto de perfil (próximamente)</p>
                </div>

                <!-- Campos -->
                <div class="space-y-4">
                    <div class="flex gap-3">
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1 text-gray-300">Nombre(s)</label>
                            <input v-model="form.firstName" type="text"
                                class="w-full bg-[#123456] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors" />
                        </div>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1 text-gray-300">Apellido(s)</label>
                            <input v-model="form.lastName" type="text"
                                class="w-full bg-[#123456] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors" />
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1 text-gray-300">Usuario</label>
                        <input v-model="form.username" type="text"
                            class="w-full bg-[#123456] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors" />
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1 text-gray-300">Correo electrónico</label>
                        <input v-model="form.email" type="email"
                            class="w-full bg-[#123456] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors" />
                    </div>
                </div>

                <div v-if="errorMsg" class="p-3 bg-red-900/40 border border-red-600 rounded-lg text-red-300 text-sm">
                    {{ errorMsg }}
                </div>
                <div v-if="successMsg" class="p-3 bg-green-900/40 border border-green-600 rounded-lg text-green-300 text-sm">
                    {{ successMsg }}
                </div>

                <button @click="save" :disabled="loading"
                    class="w-full bg-[#58CC02] hover:bg-[#4BB302] disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors">
                    {{ loading ? 'Guardando...' : 'Guardar cambios' }}
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { usersApi } from '../api/apiClient'
import placeholder from '../assets/300x300.png'

const router = useRouter()
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
        setTimeout(() => router.push('/perfil'), 800)
    } catch (err) {
        errorMsg.value = err.message || 'No se pudo actualizar el perfil.'
    } finally {
        loading.value = false
    }
}
</script>
