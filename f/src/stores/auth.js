import { defineStore } from 'pinia'
import { userData } from '../lib/data.js'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        selectedVariant: null,
        isNewUser: true
    }),

    getters: {
        isAuthenticated: (state) => !!state.user,
        hasSelectedVariant: (state) => !!state.selectedVariant
    },

    actions: {
        login() {
            this.user = userData

            // Verificar si hay variante guardada en localStorage
            const savedVariant = localStorage.getItem('selectedVariant')
            if (savedVariant) {
                this.selectedVariant = savedVariant
                this.isNewUser = false
            } else {
                this.selectedVariant = null
                this.isNewUser = true
            }
        },

        logout() {
            this.user = null
            this.selectedVariant = null
            this.isNewUser = true
            localStorage.removeItem('selectedVariant')
        },

        setVariant(variantId) {
            this.selectedVariant = variantId
            this.isNewUser = false
            localStorage.setItem('selectedVariant', variantId)
        },

        // Método para inicializar el estado desde localStorage
        initialize() {
            const savedVariant = localStorage.getItem('selectedVariant')
            if (savedVariant) {
                this.selectedVariant = savedVariant
                this.isNewUser = false
            }
        }
    },

    persist: {
        key: 'auth-storage',
        paths: ['user', 'selectedVariant', 'isNewUser']
    }
})