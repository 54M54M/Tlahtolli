<template>
    <div class="md:mt-[70px] mt-[35px] mb-[73px]">
        <Header :title="currentLevel.titleNahuatl" :subtitle="currentLevel.titleSpanish" @show-all="handleShowAll"
            :color="currentLevel.color" />

        <div class="space-y-4">
            <!-- Contenedor general -->
            <div v-for="unit in currentUnits" :key="unit.id" class="rounded-xl p-4 space-y-4 relative"
                :class="{ 'opacity-60': isUnitLocked(unit) }"
                :style="{ backgroundColor: isUnitLocked(unit) ? '#6B7280' : unit.color }">

                <!-- Overlay de bloqueo para unidad -->
                <div v-if="isUnitLocked(unit) && !isLevelLocked"
                    class="absolute inset-0 bg-gray-800/70 rounded-xl flex items-center justify-center z-10">
                    <div class="text-center p-4">
                        <div class="text-3xl mb-2">🔒</div>
                        <p class="font-bold text-white mb-1">Unidad Bloqueada</p>
                        <p class="text-sm text-white/80">{{ unit.unlockRequirement || 'Completa la unidad anterior' }}
                        </p>
                    </div>
                </div>

                <!-- Overlay de bloqueo para nivel completo -->
                <div v-if="isLevelLocked"
                    class="absolute inset-0 bg-gray-800/70 rounded-xl flex items-center justify-center z-10">
                    <div class="text-center p-4">
                        <div class="text-3xl mb-2">🔒</div>
                        <p class="font-bold text-white mb-1">Nivel Bloqueado</p>
                        <p class="text-sm text-white/80">{{ currentLevel.unlockRequirement }}</p>
                    </div>
                </div>

                <!-- Iterar sobre las unidades del nivel -->
                <div class="rounded-xl p-4 space-y-4 text-white">
                    <!-- Sección de unidad -->
                    <div class="flex items-center gap-2">
                        <div
                            class="bg-white/20 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold">
                            {{ unit.id }}
                        </div>
                        <h3 class="font-bold">{{ unit.title }}</h3>
                        <div v-if="unit.completed && !isUnitLocked(unit) && !isLevelLocked"
                            class="ml-auto text-white text-lg font-bold">✓</div>
                    </div>

                    <!-- Objetivo -->
                    <div class="bg-white/20 rounded-lg p-4">
                        <h4 class="font-bold mb-1">Objetivo</h4>
                        <p class="text-sm">{{ unit.objective }}</p>
                    </div>

                    <!-- Vocabulario Clave -->
                    <!-- <div class="bg-white/20 rounded-lg p-4" v-if="unit.vocabulary">
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
                    </div> -->

                    <!-- Gramática básica -->
                    <div class="bg-white/20 rounded-lg p-4" v-if="unit.grammar">
                        <h4 class="font-bold mb-1">Gramática básica</h4>
                        <p class="text-sm">{{ unit.grammar }}</p>
                    </div>

                    <!-- Botón para unidades desbloqueadas -->
                    <router-link :to="'/leccion/' + unit.id" v-if="!isUnitLocked(unit) && !isLevelLocked">
                        <button class="w-full bg-white text-black py-2 mt-4 rounded hover:bg-gray-100 font-bold">
                            {{ unit.completed ? 'Repasar lección' : 'Empezar lección' }}
                        </button>
                    </router-link>

                    <!-- Botón deshabilitado para unidades bloqueadas -->
                    <button v-else disabled
                        class="w-full bg-gray-400 text-gray-200 py-2 mt-4 rounded font-bold cursor-not-allowed">
                        {{ isLevelLocked ? 'Nivel Bloqueado' : 'Unidad Bloqueada' }}
                    </button>
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
                color: level.color || '#1f2937' // Color por defecto si no existe
            };
        },
        currentUnits() {
            return this.allUnits[this.id] || [];
        },
        isLevelLocked() {
            return this.currentLevel.locked || false;
        }
    },
    methods: {
        handleShowAll() {
            // Lógica para mostrar todas las variantes
        },
        isUnitLocked(unit) {
            // Si el nivel está bloqueado, todas las unidades están bloqueadas
            if (this.isLevelLocked) return true;

            // Si la unidad tiene la propiedad locked, usarla
            if (unit.locked !== undefined) return unit.locked;

            // Lógica adicional: bloquear unidades basado en unidades anteriores completadas
            // Por ejemplo, si la unidad anterior no está completada
            const previousUnit = this.currentUnits.find(u => u.id === unit.id - 1);
            if (previousUnit && !previousUnit.completed) {
                return true;
            }

            return false;
        }
    }
};
</script>