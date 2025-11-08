<template>
    <div class="mx-auto">
        <div class="mb-4">
            <!-- Search Input -->
            <div class="relative mb-3 md:mb-4">
                <Search class="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
                <input type="text" placeholder="Buscar palabra..."
                    class="pl-9 text-xs md:text-sm bg-gray-800 border-gray-700 text-white w-full p-2 rounded border focus:outline-none focus:ring-1 focus:ring-blue-500"
                    :value="searchTerm" @input="$emit('update:searchTerm', $event.target.value)" />
            </div>

            <!-- Filters -->
            <div class="flex flex-col gap-2 md:gap-4">
                <!-- Category Select -->
                <select :value="selectedCategory" @change="$emit('update:selectedCategory', $event.target.value)"
                    class="text-xs md:text-sm bg-gray-800 border-gray-700 text-white w-full p-2 rounded border focus:outline-none focus:ring-1 focus:ring-blue-500">
                    <option value="all">Todas las categorías</option>
                    <option v-for="category in categories" :key="category" :value="category">{{ category }}
                    </option>
                </select>
            </div>
        </div>

        <!-- Dictionary Entries -->
        <div class="space-y-2 md:space-y-3 mb-4">
            <div v-if="paginatedEntries.length > 0">
                <Card v-for="(entry, index) in paginatedEntries" :key="index"
                    class="border border-gray-700 bg-[#1f2937] mb-2 md:mb-4">
                    <div class="flex justify-between items-start p-3 md:p-4">
                        <div class="flex-1 min-w-0 mr-2">
                            <h3 class="text-base md:text-lg font-bold text-white truncate">{{ entry.spanish }}
                            </h3>
                            <div class="mt-1 md:mt-2 space-y-1">
                                <!-- Mostrar traducción según el idioma -->
                                <div class="flex items-center gap-1 md:gap-2">
                                    <span class="text-xs font-medium" :style="{ color: currentLanguageColor }">
                                        {{ currentLanguageName }}:
                                    </span>
                                    <span class="italic text-xs md:text-sm truncate">{{ entry.getNativeWord()
                                    }}</span>
                                    <button class="hover:opacity-80 transition-opacity"
                                        :style="{ color: currentLanguageColor }"
                                        @click="$emit('speak', entry.getNativeWord(), selectedLanguage)">
                                        <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                    </button>
                                </div>

                                <!-- Mostrar pronunciación si está disponible -->
                                <div v-if="entry.pronunciation" class="flex items-center gap-1 md:gap-2">
                                    <span class="text-xs font-medium text-gray-400">Pronunciación:</span>
                                    <span class="text-xs text-gray-400 truncate">{{ entry.pronunciation }}</span>
                                </div>
                            </div>
                            <p class="mt-1 md:mt-2 text-xs text-gray-400" v-if="entry.example">
                                <span class="font-medium">Ejemplo:</span> {{ entry.example }}
                            </p>
                        </div>
                        <Badge class="bg-[#2b4a2c] text-[#48cc11] flex-shrink-0 text-xs md:text-sm px-2 py-1">{{
                            entry.category }}
                        </Badge>
                    </div>
                </Card>
            </div>
            <div v-else class="text-center py-4 md:py-6">
                <p class="text-gray-400 text-xs md:text-sm">No se encontraron resultados para "{{ searchTerm }}"
                </p>
            </div>
        </div>

        <!-- Paginación con formato [ 1 | 2 | ... | n | m ] -->
        <div v-if="totalPages > 1" class="flex justify-center items-center space-x-1 mb-4 md:mb-1">
            <!-- Botón Anterior -->
            <button @click="goToPage(currentPage - 1)" :disabled="currentPage === 1"
                class="p-[5px] rounded border border-gray-600 bg-gray-700 text-white disabled:opacity-40 disabled:cursor-not-allowed hover:bg-gray-600 transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                </svg>
            </button>

            <!-- Primera página -->
            <button v-if="showFirstPage" @click="goToPage(1)" :class="[
                'rounded border transition-colors',
                1 === currentPage
                    ? 'text-sm px-[13px] py-[5px] bg-blue-500 border-blue-500 text-white'
                    : 'text-xs px-3 py-1 bg-gray-700 border-gray-600 text-white hover:bg-gray-600'
            ]">
                1
            </button>

            <!-- Puntos suspensivos después de la primera página -->
            <span v-if="showLeftEllipsis" class="text-gray-400 px-1">...</span>

            <!-- Páginas del medio -->
            <button v-for="page in middlePages" :key="page" @click="goToPage(page)" :class="[
                'rounded border transition-colors',
                page === currentPage
                    ? 'text-sm px-[13px] py-[5px] bg-blue-500 border-blue-500 text-white'
                    : 'text-xs px-3 py-1 bg-gray-700 border-gray-600 text-white hover:bg-gray-600'
            ]">
                {{ page }}
            </button>

            <!-- Puntos suspensivos antes de la última página -->
            <span v-if="showRightEllipsis" class="text-gray-400 px-1">...</span>

            <!-- Última página -->
            <button v-if="showLastPage" @click="goToPage(totalPages)" :class="[
                'rounded border transition-colors',
                totalPages === currentPage
                    ? 'text-sm px-[13px] py-[5px] bg-blue-500 border-blue-500 text-white'
                    : 'text-xs px-3 py-1 bg-gray-700 border-gray-600 text-white hover:bg-gray-600'
            ]">
                {{ totalPages }}
            </button>

            <!-- Botón Siguiente -->
            <button @click="goToPage(currentPage + 1)" :disabled="currentPage === totalPages"
                class="p-[5px] rounded border border-gray-600 bg-gray-700 text-white disabled:opacity-40 disabled:cursor-not-allowed hover:bg-gray-600 transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
            </button>
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import Card from '../../components/Card.vue';
import Badge from '../../components/Badge.vue';

// import { getDictionaryRepository } from '../../data/repositories/RepositoryFactory.js';
// const dictionaryRepo = getDictionaryRepository();

const props = defineProps({
    searchTerm: String,
    selectedCategory: String,
    selectedLanguage: String,
    currentLanguageName: String,
    currentLanguageColor: String,
    categories: Array,
    filteredEntries: Array,
    entriesPerPage: {
        type: Number,
        default: 8
    }
});

const currentPage = ref(1);

// Computed properties para la paginación
const totalPages = computed(() => {
    return Math.ceil(props.filteredEntries.length / props.entriesPerPage);
});

const paginatedEntries = computed(() => {
    const start = (currentPage.value - 1) * props.entriesPerPage;
    const end = start + props.entriesPerPage;
    return props.filteredEntries.slice(start, end);
});

// Lógica para el formato [ 1 | 2 | ... | n | m ]
const showFirstPage = computed(() => {
    return currentPage.value > 3;
});

const showLastPage = computed(() => {
    return currentPage.value < totalPages.value - 2;
});

const showLeftEllipsis = computed(() => {
    return currentPage.value > 4;
});

const showRightEllipsis = computed(() => {
    return currentPage.value < totalPages.value - 3;
});

const middlePages = computed(() => {
    const pages = [];

    if (totalPages.value <= 5) {
        // Si hay 5 páginas o menos, mostrar todas
        for (let i = 1; i <= totalPages.value; i++) {
            pages.push(i);
        }
    } else {
        // Mostrar páginas alrededor de la página actual
        let start = Math.max(2, currentPage.value - 1);
        let end = Math.min(totalPages.value - 1, currentPage.value + 1);

        // Ajustar para mostrar 3 páginas en el medio cuando sea posible
        if (currentPage.value <= 3) {
            start = 2;
            end = 4;
        } else if (currentPage.value >= totalPages.value - 2) {
            start = totalPages.value - 3;
            end = totalPages.value - 1;
        }

        for (let i = start; i <= end; i++) {
            pages.push(i);
        }
    }

    return pages;
});

// Métodos de navegación
const goToPage = (page) => {
    if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page;
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
};

// Resetear a página 1 cuando cambian los filtros o búsqueda
const resetPagination = () => {
    currentPage.value = 1;
};

defineEmits(['update:searchTerm', 'update:selectedCategory', 'speak']);
defineExpose({ resetPagination });
</script>