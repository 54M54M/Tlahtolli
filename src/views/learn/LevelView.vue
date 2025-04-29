<template>
    <div class="mt-[70px] mb-[73px]">
        <Header :title="currentLevel.titleNahuatl" :subtitle="currentLevel.titleSpanish" @show-all="handleShowAll"
            :color="currentLevel.color" />

        <div class="space-y-4">

            <!-- Contenedor general -->
            <div v-for="unit in currentUnits" :key="unit.id" class="rounded-xl p-4 space-y-4"
                :style="{ backgroundColor: unit.color }">

                <!-- Iterar sobre las unidades del nivel -->
                <div class="rounded-xl p-4 space-y-4 text-white" :style="{ backgroundColor: unit.color }">

                    <!-- Sección de unidad -->
                    <div class="flex items-center gap-2">
                        <div
                            class="bg-white/20 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold">
                            {{ unit.id }}
                        </div>
                        <h3 class="font-bold">{{ unit.title }}</h3>
                        <div v-if="unit.completed" class="ml-auto text-white text-lg font-bold">✓</div>
                    </div>

                    <!-- Objetivo -->
                    <div class="bg-white/20 rounded-lg p-4">
                        <h4 class="font-bold mb-1">Objetivo</h4>
                        <p class="text-sm">{{ unit.objective }}</p>
                    </div>

                    <!-- Vocabulario Clave -->
                    <div class="bg-white/20 rounded-lg p-4" v-if="unit.vocabulary">
                        <h4 class="font-bold mb-3">Vocabulario clave</h4>
                        <ul class="space-y-2">
                            <li v-for="(word, index) in unit.vocabulary" :key="index"
                                class="flex justify-between items-center bg-white/10 p-2 rounded">
                                <span>
                                    {{ word.nahuatl }} <br>
                                    <span class="text-xs text-white/80">({{ word.spanish }})</span>
                                </span>
                                <button class="text-white/70 hover:text-white">🔊</button>
                            </li>
                        </ul>
                    </div>

                    <!-- Gramática básica -->
                    <div class="bg-white/20 rounded-lg p-4" v-if="unit.grammar">
                        <h4 class="font-bold mb-1">Gramática básica</h4>
                        <p class="text-sm">{{ unit.grammar }}</p>
                    </div>

                    <!-- Botón Reparar lección -->
                    <router-link :to="'/leccion/' + unit.id">
                        <button class="w-full bg-white text-black py-2 mt-4 rounded hover:bg-gray-100 font-bold">
                            {{ unit.completed ? 'Repasar lección' : 'Empezar lección' }}
                        </button>
                    </router-link>
                </div>

            </div>
        </div>
    </div>
</template>

<script>
import Header from '../../components/vHeader.vue';
import Badge from '../../components/Badge.vue';
import { levels, levelUnits } from '../../lib/data.js';

export default {
    name: 'Level',
    components: {
        Header,
        Badge
    },
    props: {
        id: {
            type: [String, Number],
            required: true
        }
    },
    data() {
        return {
            allLevels: levels,
            allUnits: levelUnits
        };
    },
    computed: {
        currentLevel() {
            const level = this.allLevels.find(level => level.id === Number(this.id)) || {};
            return {
                ...level,
                color: level.color || '#58cc02' // Color por defecto si no existe
            };
        },
        currentUnits() {
            return this.allUnits[this.id] || [];
        }
    },
    methods: {
        handleShowAll() {
            // Lógica para mostrar todas las variantes
        }
    }
};
</script>