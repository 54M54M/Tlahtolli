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
        <div class="space-y-2 md:space-y-3 mb-8 md:mb-10">
            <div v-if="filteredEntries.length > 0">
                <Card v-for="(entry, index) in filteredEntries" :key="index"
                    class="border border-gray-700 bg-[#1f2937] mb-2 md:mb-4">
                    <div class="flex justify-between items-start p-3 md:p-4">
                        <div class="flex-1 min-w-0 mr-2">
                            <h3 class="text-base md:text-lg font-bold text-white truncate">{{ entry.spanish }}
                            </h3>
                            <div class="mt-1 md:mt-2 space-y-1">
                                <!-- Si es "all", mostrar todas las variantes -->
                                <template v-if="selectedVariant === 'all'">
                                    <div class="flex items-center gap-1 md:gap-2">
                                        <span class="text-xs font-medium" style="color: #F0983E">CE:</span>
                                        <span class="italic text-xs md:text-sm truncate">{{ entry.central }}</span>
                                        <button class="hover:text-opacity-80" style="color: #F0983E"
                                            @click="$emit('speak', entry.central, 'central')">
                                            <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                        </button>
                                    </div>
                                    <div class="flex items-center gap-1 md:gap-2">
                                        <span class="text-xs font-medium" style="color: #CF3E81">OR:</span>
                                        <span class="italic text-xs md:text-sm truncate">{{ entry.oriental }}</span>
                                        <button class="hover:text-opacity-80" style="color: #CF3E81"
                                            @click="$emit('speak', entry.oriental, 'oriental')">
                                            <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                        </button>
                                    </div>
                                    <div class="flex items-center gap-1 md:gap-2">
                                        <span class="text-xs font-medium" style="color: #5DC7A4">OC:</span>
                                        <span class="italic text-xs md:text-sm truncate">{{ entry.occidental }}</span>
                                        <button class="hover:text-opacity-80" style="color: #5DC7A4"
                                            @click="$emit('speak', entry.occidental, 'occidental')">
                                            <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                        </button>
                                    </div>
                                </template>
                                <!-- Si es una variante específica, mostrar solo esa -->
                                <template v-else>
                                    <div class="flex items-center gap-1 md:gap-2">
                                        <span class="text-xs font-medium" :style="{ color: currentVariantColor }">
                                            {{ currentVariantName }}:
                                        </span>
                                        <span class="italic text-xs md:text-sm truncate">{{ entry.nahuatl
                                        }}</span>
                                        <button class="hover:opacity-80 transition-opacity"
                                            :style="{ color: currentVariantColor }"
                                            @click="$emit('speak', entry.nahuatl, selectedVariant)">
                                            <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                        </button>
                                    </div>
                                </template>
                            </div>
                            <p class="mt-1 md:mt-2 text-xs text-gray-400">
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
    </div>
</template>

<script setup>
import Card from '../../components/Card.vue';
import Badge from '../../components/Badge.vue';

defineProps({
    searchTerm: String,
    selectedCategory: String,
    selectedVariant: String,
    currentVariantName: String,
    currentVariantColor: String,
    categories: Array,
    filteredEntries: Array
});

defineEmits(['update:searchTerm', 'update:selectedCategory', 'speak']);
</script>