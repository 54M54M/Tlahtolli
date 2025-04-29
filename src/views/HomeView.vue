<template>
    <div class="flex flex-col items-center text-white min-h-screen py-8 md:pt-1">
        <h1 class="text-3xl font-bold mb-6">Elige una variante</h1>

        <!-- Grupo de variantes -->
        <div class="flex flex-col items-center">
            <div class="grid grid-cols-3 gap-4 mb-6 p-2">
                <template v-for="(variant, index) in dialectVariants" :key="variant.id">
                    <Badge v-if="index < 3" @click="selectVariant(variant.id)"
                        class="flex items-center justify-center px-4 py-2 border-2 hover:scale-110 transition-transform cursor-pointer"
                        :style="{ borderColor: variant.color, 'background-color': selectedVariant === variant.id ? variant.color : 'transparent' }">
                        <p class="text-center font-semibold"
                            :style="{ color: selectedVariant === variant.id ? 'white' : variant.color }">
                            {{ variant.name }}
                        </p>
                    </Badge>
                </template>

                <template v-if="dialectVariants.length > 3">
                    <div class="col-span-3 flex justify-center">
                        <Badge @click="selectVariant(dialectVariants[3].id)"
                            class="flex items-center justify-center px-6 py-3 border-2 hover:scale-110 transition-transform cursor-pointer"
                            :style="{
                                borderColor: dialectVariants[3].color,
                                'background-color': selectedVariant === dialectVariants[3].id ? dialectVariants[3].color : 'transparent'
                            }">
                            <p class="text-center font-semibold"
                                :style="{ color: selectedVariant === dialectVariants[3].id ? 'white' : dialectVariants[3].color }">
                                {{ dialectVariants[3].name }}
                            </p>
                        </Badge>
                    </div>
                </template>
            </div>

            <p class="text-sm mb-6 text-center">
                Selecciona una variante para especializarte o estudia todas
            </p>
        </div>

        <h1 class="text-3xl font-bold mb-6">Elige un nivel</h1>

        <div class="w-full mb-12">
            <div class="space-y-4">
                <router-link v-for="level in levels" :key="level.id" :to="'/nivel/' + level.id" class="w-full block">
                    <Card
                        class="rounded-xl text-white overflow-hidden shadow-lg transition-transform transform hover:scale-105 focus:outline-none"
                        :style="{ backgroundColor: level.color }">
                        <div class="relative p-4 cursor-pointer">
                            <!-- Número en esquina superior izquierda -->
                            <div
                                class="absolute -left-7 -top-7 w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
                                <span class="text-2xl font-bold">{{ level.id }}</span>
                            </div>
                            <div class="-mt-3 text-center">
                                <h2 class="text-sm font-semibold">{{ level.titleSpanish }}</h2>
                                <h1 class="text-xl font-bold mt-1">{{ getDialectTitle(level) }}</h1>
                                <p class="text-sm mt-2">{{ level.description }}</p>
                            </div>
                            <div class="mt-6">
                                <div class="h-2 bg-white/30 rounded-full overflow-hidden">
                                    <div class="h-2 bg-white"
                                        :style="{ width: `${(level.completedUnits / level.units) * 100}%` }"></div>
                                </div>
                                <p class="text-xs text-center mt-2">{{ level.completedUnits }}/{{ level.units }}
                                    unidades
                                </p>
                            </div>
                        </div>
                    </Card>
                </router-link>
            </div>
        </div>
    </div>
</template>

<script>
import Badge from '../components/Badge.vue';
import Card from '../components/Card.vue';
import { levels, dialectVariants } from '../lib/data.js';

export default {
    name: 'Inicio',
    components: {
        Badge,
        Card
    },
    data() {
        return {
            levels: levels,
            dialectVariants: dialectVariants,
            selectedVariant: 'all' // Establecemos 'all' como valor por defecto
        };
    },
    methods: {
        selectVariant(variantId) {
            this.selectedVariant = variantId;
        },
        getDialectTitle(level) {
            if (!this.selectedVariant || this.selectedVariant === 'all') {
                return level.titleNahuatl;
            }

            if (this.selectedVariant === 'central') {
                return level.titleNahuatl + ' (Ce)'; // Central usa el título original + indicador
            } else if (this.selectedVariant === 'oriental') {
                return level.titleNahuatl.replace(/tl/g, 't') + ' (Or)'; // Cambia 'tl' por 't' + indicador
            } else if (this.selectedVariant === 'occidental') {
                return level.titleNahuatl + ' (Oc)'; // Título original + indicador
            }

            return level.titleNahuatl;
        }
    }
}
</script>