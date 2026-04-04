<template>
    <div class="language-group-selector">
        <!-- Grupos de idiomas desplegables -->
        <div class="space-y-3">
            <!-- Grupo dinámico para cada grupo de idiomas -->
            <div v-for="group in groupedLanguages" :key="group.id"
                class="rounded-lg overflow-hidden border border-gray-700">

                <!-- Botón del grupo -->
                <button @click="toggleGroup(group.id)"
                    class="w-full p-4 text-left flex items-center justify-between bg-gray-800 hover:bg-gray-750 transition-colors">

                    <div class="flex items-center space-x-3">
                        <div class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold"
                            :style="{ backgroundColor: group.color }">
                            {{ getGroupFlag(group.languages) }}
                        </div>
                        <div class="text-left">
                            <h3 class="font-bold text-lg text-white">{{ group.name }}</h3>
                            <p class="text-sm text-gray-400">{{ group.description }}</p>
                        </div>
                    </div>

                    <svg :class="['transform transition-transform', expandedGroups.has(group.id) ? 'rotate-180' : 'rotate-0']"
                        width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="6 9 12 15 18 9"></polyline>
                    </svg>
                </button>

                <!-- Contenido expandido del grupo -->
                <div v-if="expandedGroups.has(group.id)" class="bg-gray-900 border-t border-gray-700">
                    <div class="p-3 space-y-2">
                        <div v-for="lang in group.languages" :key="lang.code" @click="selectVariant(lang.code)"
                            class="p-3 rounded-lg flex items-center cursor-pointer hover:bg-gray-800 transition-colors"
                            :style="{ backgroundColor: selectedLanguage === lang.code ? `${lang.color}33` : 'transparent' }">

                            <div class="mr-3 flex-shrink-0">
                                <div class="w-6 h-6 rounded border-2 flex items-center justify-center transition-all"
                                    :style="{
                                        borderColor: lang.color,
                                        backgroundColor: selectedLanguage === lang.code ? lang.color : 'transparent'
                                    }">
                                    <svg v-if="selectedLanguage === lang.code" width="14" height="14"
                                        viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                            </div>

                            <div class="flex-1">
                                <p class="font-semibold">{{ lang.name }}</p>
                                <p class="text-sm text-gray-300">{{ lang.nativeName }}</p>
                            </div>

                            <div class="w-8 h-8 rounded-full flex items-center justify-center text-white ml-2"
                                :style="{ backgroundColor: lang.color }">
                                {{ lang.flag }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { LanguageService } from '../data/services/LanguageService'

const props = defineProps({
    initialLanguage: {
        type: String,
        default: null
    },
    // Nueva prop para recibir idiomas desde fuera
    languages: {
        type: Array,
        default: null
    }
})

const emit = defineEmits(['language-selected'])

const languageService = new LanguageService()
const selectedLanguage = ref(props.initialLanguage)
const expandedGroups = ref(new Set())

// Función para transformar los idiomas de la API al formato que espera el componente
const transformLanguages = (langs) => {
    if (!langs || !Array.isArray(langs)) return []

    return langs.map(lang => ({
        code: lang.code?.toLowerCase() || lang.id?.toLowerCase(),
        name: lang.langName || lang.lang_name || lang.name,
        nativeName: lang.nativeName || lang.native_name || '',
        flag: lang.flag || '🌐',
        color: lang.color || '#58CC02',
        family: lang.family || lang.langName || lang.lang_name || 'Otros'
    }))
}

// Obtener los idiomas a usar (desde prop o desde el servicio)
const getLanguages = () => {
    if (props.languages) {
        return transformLanguages(props.languages)
    }
    // Si no hay prop, usar el servicio
    const groups = languageService.getLanguageGroups()
    const allLanguages = []
    groups.forEach(group => {
        allLanguages.push(...group.languages)
    })
    return allLanguages
}

// Agrupar idiomas por familia
const groupedLanguages = computed(() => {
    const languages = getLanguages()
    const groupsMap = new Map()

    languages.forEach(lang => {
        const familyKey = lang.family || 'Otros'

        if (!groupsMap.has(familyKey)) {
            groupsMap.set(familyKey, {
                id: familyKey,
                name: familyKey,
                description: `Idiomas ${familyKey}`,
                color: lang.color || '#58CC02',
                languages: []
            })
        }

        groupsMap.get(familyKey).languages.push(lang)
    })

    return Array.from(groupsMap.values())
})

// Obtener el emoji de bandera del primer idioma del grupo para mostrar en el encabezado
const getGroupFlag = (languages) => {
    if (languages.length > 0 && languages[0].flag) {
        return languages[0].flag
    }
    return '🌐'
}

// Función para alternar grupo
const toggleGroup = (groupId) => {
    if (expandedGroups.value.has(groupId)) {
        expandedGroups.value.delete(groupId)
    } else {
        expandedGroups.value.add(groupId)
    }
}

// Seleccionar variante
const selectVariant = (languageCode) => {
    selectedLanguage.value = languageCode
    emit('language-selected', languageCode)
}

// Expandir grupo del idioma inicial cuando cambia
watch(() => props.initialLanguage, (newLang) => {
    if (newLang) {
        const languages = getLanguages()
        const lang = languages.find(l => l.code === newLang)
        if (lang) {
            const familyKey = lang.family || 'Otros'
            if (!expandedGroups.value.has(familyKey)) {
                expandedGroups.value.add(familyKey)
            }
        }
    }
}, { immediate: true })

// Actualizar selectedLanguage cuando cambia initialLanguage
watch(() => props.initialLanguage, (newLang) => {
    if (newLang) {
        selectedLanguage.value = newLang
    }
})
</script>

<style scoped>
.language-group-selector {
    width: 100%;
}

.bg-gray-750 {
    background-color: #374151;
}

/* Estilos para el checkbox personalizado */
.w-6.h-6.rounded.border-2 {
    transition: all 0.2s ease;
}

/* Estilo para el hover en las opciones de idioma */
.hover\:bg-gray-800:hover {
    background-color: rgba(31, 41, 55, 0.8);
}

/* Animación para la flecha */
.transform {
    transition: transform 0.3s ease;
}
</style>