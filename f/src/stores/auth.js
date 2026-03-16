// src/stores/auth.js
import { defineStore } from 'pinia'
import { usersApi, languagesApi, progressApi, learningApi } from '../api/apiClient.js'

// Username del usuario demo — el ID real lo resuelve la API
const DEMO_USERNAME = 'tetecuhtli'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        selectedLanguage: null,   // código string: 'nhce', 'tkoc'…
        selectedLangId: null,   // ID numérico en la BD
        isNewUser: true,
        isInitialized: false,
    }),

    getters: {
        isAuthenticated: (state) => !!state.user,
        hasSelectedLanguage: (state) => !!state.selectedLanguage,
        isLanguageReady: (state) => state.isInitialized && !!state.selectedLanguage,
    },

    actions: {
        // ── inicialización ─────────────────────────────────────────────────────

        async initialize() {
            try {
                // 1. Obtener usuario por username (no por ID hardcodeado)
                const user = await usersApi.getByUsername(DEMO_USERNAME)
                if (!user) throw new Error('Usuario demo no encontrado')
                this.user = user

                // 2. Si tiene idioma activo en la BD, usarlo
                if (user.currentLang) {
                    this.selectedLangId = user.currentLang
                    const lang = await languagesApi.getById(user.currentLang)
                    if (lang) {
                        this.selectedLanguage = lang.code.toLowerCase()
                        this.isNewUser = false
                    }
                } else {
                    // Fallback a localStorage mientras no haya idioma en BD
                    const saved = localStorage.getItem('selectedLanguage')
                    if (saved) {
                        this.selectedLanguage = saved
                        this.isNewUser = false
                    }
                }

                this.isInitialized = true
                console.log('[auth] Usuario cargado:', this.user.username, '(ID:', this.user.id, ')')
            } catch (err) {
                console.error('[auth] initialize error:', err)
                this._fallbackToLocalStorage()
            }
        },

        async login() {
            await this.initialize()
        },

        logout() {
            this.user = null
            this.selectedLanguage = null
            this.selectedLangId = null
            this.isNewUser = true
            this.isInitialized = false
            localStorage.removeItem('selectedLanguage')
        },

        // ── cambio de idioma ───────────────────────────────────────────────────

        async setLanguage(languageCode) {
            try {
                const langs = await languagesApi.getAll()
                const lang = langs.find(l => l.code.toLowerCase() === languageCode.toLowerCase())
                if (!lang) throw new Error(`Idioma no encontrado: ${languageCode}`)

                const updatedUser = await usersApi.switchLanguage(this.user.id, lang.id)
                this.user = updatedUser
                this.selectedLanguage = languageCode
                this.selectedLangId = lang.id
                this.isNewUser = false

                localStorage.setItem('selectedLanguage', languageCode)
                await this._initProgress(lang.id)

                console.log('[auth] Idioma establecido:', languageCode, '→ ID', lang.id)
            } catch (err) {
                console.error('[auth] setLanguage error:', err)
                throw err
            }
        },

        // ── datos del usuario ──────────────────────────────────────────────────

        async refreshUser() {
            try {
                if (!this.user?.id) return
                this.user = await usersApi.getById(this.user.id)
            } catch (err) {
                console.error('[auth] refreshUser error:', err)
            }
        },

        // ── privados ───────────────────────────────────────────────────────────

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

        _fallbackToLocalStorage() {
            const saved = localStorage.getItem('selectedLanguage')
            if (saved) {
                this.selectedLanguage = saved
                this.isNewUser = false
            }
            this.isInitialized = true
            console.warn('[auth] Fallback a localStorage — API no devolvió usuario')
        },
    },

    persist: {
        key: 'auth-storage',
        paths: ['user', 'selectedLanguage', 'selectedLangId', 'isNewUser', 'isInitialized'],
    },
})