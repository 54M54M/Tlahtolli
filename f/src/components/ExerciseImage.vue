<template>
    <div class="w-36 h-36 md:w-48 md:h-48 object-cover rounded-lg">
        <img :src="currentImage" :alt="altText" :class="imageClasses" @error="handleImageError" />
    </div>
</template>

<script>
import placeholder from '../assets/300x300.png';

// Importar todas las imágenes disponibles
const imageContext = import.meta.glob('../assets/exercises/*.webp', { eager: true });

// Mapeo de nombres de personajes para consistencia
const CHARACTER_MAP = {
    'citlali': 'citlali',
    'coltzin': 'coltzin',
    'neza': 'neza',
    'tonatiuh': 'tonatiuh',
    'xochitl': 'xochitl',
    'ctllall': 'citlali' // Fallback para typo común
};

export default {
    name: "ExerciseImage",
    props: {
        characterName: {
            type: String,
            default: 'citlali' // Default explícito
        },
        imageState: {
            type: Boolean,
            default: true
        },
        altText: {
            type: String,
            default: 'Ejercicio'
        },
        showAnswer: {
            type: Boolean,
            default: false
        },
        customClasses: {
            type: String,
            default: 'w-36 h-36 md:w-48 md:h-48 object-cover rounded-lg bg-gray-700'
        }
    },
    computed: {
        currentImage() {
            const normalizedCharacter = this.normalizeCharacterName(this.characterName);
            const stateSuffix = this.imageState ? 'true' : 'false';
            const imageName = `${normalizedCharacter}-${stateSuffix}.webp`;

            console.log(`🖼️ Buscando imagen: ${imageName}`);
            console.log(`📁 Imágenes disponibles:`, Object.keys(imageContext));

            // Buscar imagen exacta
            const imagePath = Object.keys(imageContext).find(path =>
                path.includes(imageName)
            );

            if (imagePath && imageContext[imagePath]) {
                console.log(`✅ Imagen encontrada: ${imageName}`);
                return imageContext[imagePath].default;
            }

            // Fallback: estado opuesto
            const fallbackStateSuffix = !this.imageState ? 'true' : 'false';
            const fallbackImageName = `${normalizedCharacter}-${fallbackStateSuffix}.webp`;
            const fallbackPath = Object.keys(imageContext).find(path =>
                path.includes(fallbackImageName)
            );

            if (fallbackPath && imageContext[fallbackPath]) {
                console.log(`🔄 Usando fallback: ${fallbackImageName}`);
                return imageContext[fallbackPath].default;
            }

            // Fallback: cualquier imagen del personaje
            const anyCharacterPath = Object.keys(imageContext).find(path =>
                path.toLowerCase().includes(normalizedCharacter.toLowerCase())
            );

            if (anyCharacterPath && imageContext[anyCharacterPath]) {
                console.log(`🔍 Usando imagen alternativa: ${anyCharacterPath}`);
                return imageContext[anyCharacterPath].default;
            }

            console.warn(`🚨 Usando placeholder para: ${normalizedCharacter}`);
            return placeholder;
        },
        imageClasses() {
            return this.customClasses;
        }
    },
    methods: {
        normalizeCharacterName(name) {
            if (!name) return 'citlali';

            const normalized = name.toLowerCase().trim();
            return CHARACTER_MAP[normalized] || 'citlali';
        },
        handleImageError(event) {
            console.error('Error cargando imagen del personaje:', {
                originalName: this.characterName,
                normalizedName: this.normalizeCharacterName(this.characterName),
                imageState: this.imageState,
                event: event
            });

            this.$emit('image-error', {
                characterName: this.characterName,
                imageState: this.imageState
            });
        }
    }
};
</script>