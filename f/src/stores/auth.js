import { defineStore } from 'pinia'
import { userData } from '../lib/data.js'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        selectedVariant: null,
        isNewUser: true,
        isInitialized: false // Nuevo estado
    }),

    getters: {
        isAuthenticated: (state) => !!state.user,
        hasSelectedVariant: (state) => !!state.selectedVariant,
        isVariantReady: (state) => state.isInitialized && !!state.selectedVariant // Nuevo getter
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
            this.isInitialized = true
        },

        logout() {
            this.user = null
            this.selectedVariant = null
            this.isNewUser = true
            this.isInitialized = false
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
            this.isInitialized = true
        }
    },

    persist: {
        key: 'auth-storage',
        paths: ['user', 'selectedVariant', 'isNewUser', 'isInitialized']
    }
})