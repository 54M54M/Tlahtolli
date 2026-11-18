import { defineStore } from 'pinia'
import { usersApi, authApi, languagesApi, progressApi, learningApi } from '../api/apiClient.js'

// "Verificar más tarde" del modal de correo: dura hasta cerrar sesión o volver a iniciarla
function clearVerifyLater() {
    try {
        Object.keys(sessionStorage).filter(k => k.startsWith('verifyEmailLater:')).forEach(k => sessionStorage.removeItem(k))
    } catch { /* sin almacenamiento */ }
}

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        token: null,                // JWT del backend (Authorization: Bearer)
        tokenExp: null,             // expiración en epoch segundos
        selectedLanguage: null,     // código string: 'nhn'…
        selectedLangId: null,       // ID numérico en la BD
        selectedLangObj: null,      // objeto completo del idioma (con icon/emoji/color de la BD)
        isNewUser: true,
        isInitialized: false,
    }),

    getters: {
        isAuthenticated: (state) => !!state.user && !!state.token && (!state.tokenExp || state.tokenExp * 1000 > Date.now()),
        isAdmin: (state) => state.user?.role === 'admin',
        hasSelectedLanguage: (state) => !!state.selectedLanguage,
        isLanguageReady: (state) => state.isInitialized && !!state.selectedLanguage,

        /** Idioma actual normalizado desde ct_languages (null si no hay idioma). */
        currentLanguage: (state) => {
            const l = state.selectedLangObj
            if (!l) return null
            return {
                id: l.id,
                code: l.code,
                name: l.langName ?? l.lang_name ?? l.name ?? l.code,
                nativeName: l.nativeName ?? l.native_name ?? '',
                flag: l.flag || '🌐',
                family: l.family ?? null,
                writingSystem: l.writingSystem ?? l.writing_system ?? null,
            }
        },
    },

    actions: {
        // ── Login con credenciales ─────────────────────────────────────────────
        async login(username, password) {
            const res = await authApi.login(username, password)
            await this._startSession(res)
        },

        // ── Login / registro con Google (ID token del botón de Google) ────────
        async loginWithGoogle(credential) {
            const res = await authApi.google(credential)
            await this._startSession(res)
            return res
        },

        async _startSession(res) {
            const { token, expiresAt, isNewUser, ...user } = res || {}
            if (!user || !user.id || !token) {
                throw new Error('Usuario o contraseña incorrectos.')
            }

            this.user = user
            this.token = token
            this.tokenExp = expiresAt ?? null
            this.selectedLanguage = null
            this.selectedLangId = null
            this.selectedLangObj = null
            this.isNewUser = true
            this.isInitialized = true

            localStorage.removeItem('selectedLanguage')
            clearVerifyLater()   // el aviso de verificar correo vuelve a salir en cada inicio de sesión

            // Usuario existente → restaurar el último idioma guardado en BD (currentLang)
            if (user.currentLang) {
                await this._restoreLanguage(user.currentLang)
            }

            console.log('[auth] Login exitoso:', user.username, '(ID:', user.id, ')',
                this.selectedLanguage ? `→ idioma ${this.selectedLanguage}` : '→ sin idioma')
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
            this.token = null
            this.tokenExp = null
            this.selectedLanguage = null
            this.selectedLangId = null
            this.selectedLangObj = null
            this.isNewUser = true
            this.isInitialized = false
            localStorage.removeItem('selectedLanguage')
            clearVerifyLater()
        },

        // ── Cambio de idioma (recibe código string: 'nhn'…) ──────────
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

        // Restaura el idioma a partir de su ID sin volver a llamar a switchLanguage
        // ni a _initProgress: el usuario ya tiene ese idioma y su progreso en BD.
        // Si el idioma ya no existe o falla la consulta, se queda sin idioma y el
        // router lo manda al selector.
        async _restoreLanguage(languageId) {
            try {
                const langs = await languagesApi.getAll()
                const lang = langs?.find(l => l.id === languageId)
                if (!lang) {
                    console.warn('[auth] currentLang sin idioma válido:', languageId)
                    return
                }
                this.selectedLanguage = lang.code
                this.selectedLangId = lang.id
                this.selectedLangObj = lang
                this.isNewUser = false
                localStorage.setItem('selectedLanguage', lang.code)
            } catch (err) {
                console.warn('[auth] _restoreLanguage:', err.message)
            }
        },

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
        paths: ['user', 'token', 'tokenExp', 'selectedLanguage', 'selectedLangId', 'selectedLangObj', 'isNewUser', 'isInitialized'],
    },
})