<template>
    <div class="flex flex-col items-center text-white min-h-screen mt-[-20px] md:py-8 md:pt-1">
        <h1 class="text-3xl font-bold mb-6">Elige un nivel</h1>

        <div class="w-full mb-12">
            <div class="space-y-4">
                <router-link v-for="level in levels" :key="level.id" :to="'/nivel/' + level.id" class="w-full block">
                    <Card
                        class="rounded-xl text-white overflow-hidden shadow-lg transition-transform transform hover:scale-105 focus:outline-none"
                        :style="{ backgroundColor: level.color }">
                        <div class="relative p-4 cursor-pointer">
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
import { levels, dialectVariants } from '../lib/data.js'
import { useAuthStore } from '../stores/auth'
import { onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import Badge from '../components/Badge.vue'
import Card from '../components/Card.vue'

export default {
    name: 'Inicio',
    components: {
        Badge,
        Card
    },
    setup() {
        const authStore = useAuthStore()
        const router = useRouter()

        const selectedVariantData = computed(() => {
            return dialectVariants.find(v => v.id === authStore.selectedVariant) || dialectVariants[3] // 'all' por defecto
        })

        const goToVariantSelection = () => {
            router.push('/select-variant')
        }

        onMounted(() => {
            if (!authStore.selectedVariant) {
                router.push('/select-variant')
            }
        })

        return {
            levels,
            dialectVariants,
            selectedVariant: authStore.selectedVariant,
            selectedVariantData,
            goToVariantSelection
        }
    },
    methods: {
        getDialectTitle(level) {
            if (!this.selectedVariant || this.selectedVariant === 'all') {
                return level.titleNahuatl
            }

            if (this.selectedVariant === 'central') {
                return level.titleNahuatl + ' (Ce)'
            } else if (this.selectedVariant === 'oriental') {
                return level.titleNahuatl.replace(/tl/g, 't') + ' (Or)'
            } else if (this.selectedVariant === 'occidental') {
                return level.titleNahuatl + ' (Oc)'
            }

            return level.titleNahuatl
        }
    }
}
</script>