<template>
    <div class="bg-surface-0 text-white pt-4">
        <!-- Mismo encabezado y espaciado que Perfil -->
        <Header variant="simple" title="Editar perfil" show-back back-route="/perfil" class="pt-6 md:pt-5" />

        <main class="container mx-auto py-1 md:py-2 pb-16 md:pb-20">
            <div class="w-full max-w-md mx-auto space-y-6">

                <!-- Foto -->
                <div class="flex flex-col items-center">
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
                                class="w-full bg-surface-1 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                        </div>
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-1 text-gray-300">Apellido(s)</label>
                            <input v-model="form.lastName" type="text"
                                class="w-full bg-surface-1 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1 text-gray-300">Usuario</label>
                        <input v-model="form.username" type="text"
                            class="w-full bg-surface-1 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1 text-gray-300">Correo electrónico</label>
                        <input v-model="form.email" type="email"
                            class="w-full bg-surface-1 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors" />
                    </div>
                </div>

                <div v-if="errorMsg" class="p-3 bg-error-soft/40 border border-error rounded-lg text-error text-sm">
                    {{ errorMsg }}
                </div>
                <div v-if="successMsg" class="p-3 bg-green-900/40 border border-green-600 rounded-lg text-green-300 text-sm">
                    {{ successMsg }}
                </div>

                <button @click="save" :disabled="loading"
                    class="w-full bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors">
                    {{ loading ? 'Guardando...' : 'Guardar cambios' }}
                </button>
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { usersApi } from '../api/apiClient'
import UserAvatar from '../components/UserAvatar.vue'
import Header from '../components/vHeader.vue'

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
