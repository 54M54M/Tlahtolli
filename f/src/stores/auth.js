import { defineStore } from 'pinia'
import { UserRepository } from '../data/repositories/UserRepository.js'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        selectedLanguage: null,
        isNewUser: true,
        isInitialized: false
    }),

    getters: {
        isAuthenticated: (state) => !!state.user,
        hasSelectedLanguage: (state) => !!state.selectedLanguage,
        isLanguageReady: (state) => state.isInitialized // Solo verificar inicialización
    },

    actions: {
        login() {
            const userRepo = new UserRepository()
            this.user = userRepo.getUser(1)

            // Verificar si hay idioma guardado en localStorage
            const savedLanguage = localStorage.getItem('selectedLanguage')
            if (savedLanguage) {
                this.selectedLanguage = savedLanguage
                this.isNewUser = false
            } else {
                this.selectedLanguage = null
                this.isNewUser = true
            }
            this.isInitialized = true
            console.log('Login completed - Language:', this.selectedLanguage, 'isNewUser:', this.isNewUser)
        },

        logout() {
            this.user = null
            this.selectedLanguage = null
            this.isNewUser = true
            this.isInitialized = false
            localStorage.removeItem('selectedLanguage')
        },

        setLanguage(languageCode) {
            this.selectedLanguage = languageCode
            this.isNewUser = false
            localStorage.setItem('selectedLanguage', languageCode)

            // Actualizar el idioma actual del usuario
            if (this.user) {
                const userRepo = new UserRepository()
                userRepo.switchLanguage(1, languageCode)
            }
            console.log('Language set to:', languageCode)
        },

        // Método para inicializar el estado desde localStorage
        initialize() {
            try {
                const savedLanguage = localStorage.getItem('selectedLanguage')
                console.log('Initializing auth store. Saved language:', savedLanguage)

                if (savedLanguage) {
                    this.selectedLanguage = savedLanguage
                    this.isNewUser = false
                    console.log('Restored language from localStorage:', savedLanguage)
                }
                this.isInitialized = true
                console.log('Auth store initialized successfully')
            } catch (error) {
                console.error('Error initializing auth store:', error)
                this.isInitialized = true // Marcar como inicializado incluso con error
            }
        }
    },

    persist: {
        key: 'auth-storage',
        paths: ['user', 'selectedLanguage', 'isNewUser', 'isInitialized']
    }
})