import { defineStore } from 'pinia'
import { userData } from '../lib/data.js'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        selectedVariant: localStorage.getItem('selectedVariant') || null,
        isNewUser: localStorage.getItem('selectedVariant') === null
    }),
    actions: {
        login() {
            this.user = userData
            // Verificar si es nuevo usuario (no tiene variante guardada)
            const savedVariant = localStorage.getItem('selectedVariant')
            if (!savedVariant) {
                this.isNewUser = true
            } else {
                this.selectedVariant = savedVariant
                this.isNewUser = false
            }
        },
        logout() {
            this.user = null
            this.selectedVariant = null
            this.isNewUser = false
            localStorage.removeItem('selectedVariant')
        },
        setVariant(variantId) {
            this.selectedVariant = variantId
            this.isNewUser = false
            localStorage.setItem('selectedVariant', variantId)
        }
    },
    persist: true
})