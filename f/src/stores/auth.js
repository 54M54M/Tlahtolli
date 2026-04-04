import { defineStore } from 'pinia'
import { usersApi, languagesApi, progressApi, learningApi } from '../api/apiClient.js'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        selectedLanguage: null,     // código string: 'nhce', 'tkoc'…
        selectedLangId: null,       // ID numérico en la BD
        selectedLangObj: null,      // objeto completo del idioma (con icon/emoji/color de la BD)
        isNewUser: true,
        isInitialized: false,
    }),

    getters: {
        isAuthenticated: (state) => !!state.user,
        hasSelectedLanguage: (state) => !!state.selectedLanguage,
        isLanguageReady: (state) => state.isInitialized && !!state.selectedLanguage,
    },

    actions: {
        // ── Login con credenciales ─────────────────────────────────────────────
        async login(username, password) {
            const DEMO_PASSWORD = 'demo1234'
            if (password !== DEMO_PASSWORD) {
                throw new Error('Contraseña incorrecta.')
            }

            const user = await usersApi.getByUsername(username)
            if (!user) {
                throw new Error('Usuario no encontrado.')
            }

            this.user = user
            this.selectedLanguage = null
            this.selectedLangId = null
            this.selectedLangObj = null
            this.isNewUser = true
            this.isInitialized = true

            localStorage.removeItem('selectedLanguage')

            console.log('[auth] Login exitoso:', user.username, '(ID:', user.id, ')')
        },

        // ── Inicialización silenciosa (al recargar con sesión persistida) ──────
        async initialize() {
            if (this.isInitialized && this.user && this.selectedLangId) {
                return
            }

            if (this.user) {
                try {
                    this.user = await usersApi.getById(this.user.id)
                } catch (err) {
                    console.warn('[auth] initialize refresh user:', err.message)
                }

                // Resolver selectedLangId y selectedLangObj si faltan
                if (this.selectedLanguage && (!this.selectedLangId || !this.selectedLangObj)) {
                    try {
                        const langs = await languagesApi.getAll()
                        const lang = langs.find(l =>
                            l.code.toLowerCase() === this.selectedLanguage.toLowerCase()
                        )
                        if (lang) {
                            this.selectedLangId = lang.id
                            this.selectedLangObj = lang
                            console.log('[auth] selectedLangId recuperado:', lang.id)
                        }
                    } catch (err) {
                        console.warn('[auth] initialize resolve langId:', err.message)
                    }
                }
            }

            this.isInitialized = true
        },

        logout() {
            this.user = null
            this.selectedLanguage = null
            this.selectedLangId = null
            this.selectedLangObj = null
            this.isNewUser = true
            this.isInitialized = false
            localStorage.removeItem('selectedLanguage')
        },

        // ── Cambio de idioma (recibe código string: 'nhce', 'tkoc'…) ──────────
        async setLanguage(languageCode) {
            try {
                const langs = await languagesApi.getAll()
                const lang = langs.find(l => l.code.toLowerCase() === languageCode.toLowerCase())
                if (!lang) throw new Error(`Idioma no encontrado: ${languageCode}`)

                const updatedUser = await usersApi.switchLanguage(this.user.id, lang.id)
                this.user = updatedUser
                this.selectedLanguage = languageCode
                this.selectedLangId = lang.id
                this.selectedLangObj = lang        // ← objeto completo (icon/emoji/color de la BD)
                this.isNewUser = false

                localStorage.setItem('selectedLanguage', languageCode)
                await this._initProgress(lang.id)

                console.log('[auth] Idioma establecido:', languageCode, '→ ID', lang.id)
            } catch (err) {
                console.error('[auth] setLanguage error:', err)
                throw err
            }
        },

        // ── Alias para vHeader que llama setSelectedLanguage(id | code) ────────
        async setSelectedLanguage(languageIdOrCode) {
            if (typeof languageIdOrCode === 'number') {
                const langs = await languagesApi.getAll()
                const lang = langs.find(l => l.id === languageIdOrCode)
                if (!lang) throw new Error(`Idioma no encontrado por ID: ${languageIdOrCode}`)
                return this.setLanguage(lang.code)
            }
            return this.setLanguage(languageIdOrCode)
        },

        // ── Refrescar datos del usuario ────────────────────────────────────────
        async refreshUser() {
            try {
                if (!this.user?.id) return
                this.user = await usersApi.getById(this.user.id)
            } catch (err) {
                console.error('[auth] refreshUser error:', err)
            }
        },

        // ── Privados ───────────────────────────────────────────────────────────
        async _initProgress(languageId) {
            try {
                const levels = await learningApi.getLevels(languageId, this.user.id)
                if (!levels?.length) return
                const units = await learningApi.getUnits(levels[0].id, this.user.id)
                if (!units?.length) return
                await progressApi.init(this.user.id, units[0].id)
            } catch (err) {
                console.warn('[auth] _initProgress:', err.message)
            }
        },
    },

    persist: {
        key: 'auth-storage',
        paths: ['user', 'selectedLanguage', 'selectedLangId', 'selectedLangObj', 'isNewUser', 'isInitialized'],
    },
})