<template>
    <Card class="text-center md:pt-[5%] md:pb-[6%] md:scale-125">
        <!-- Título principal -->
        <h2 class="text-xl font-semibold mb-4">{{ title }}</h2>

        <!-- Métricas de desempeño -->
        <div class="grid grid-cols-3 md:grid-cols-3 gap-4 mb-6">
            <!-- EXP TOTALES -->
            <div class="bg-[#ffc704] rounded-xl p-1">
                <div class="text-sm font-bold text-[#0A2136]">EXP TOTALES</div>
                <div class="bg-[#0A2136] rounded-xl p-4">
                    <div class="md:text-2xl font-bold text-[#ffc704] mb-1">{{ totalExp }} EXP</div>
                </div>
            </div>

            <!-- PORCENTAJE DE ACIERTOS -->
            <div class="bg-[#93d239] rounded-xl p-1">
                <div class="text-sm font-bold uppercase text-[#0A2136]">{{ performanceMessage }}</div>
                <div class="bg-[#0A2136] rounded-xl p-4">
                    <div class="md:text-2xl font-bold text-[#93d239] mb-1">{{ Math.round(performance * 100) }}%</div>
                </div>
            </div>

            <!-- TIEMPO EN LECCIÓN -->
            <div class="bg-[#46c2f7] rounded-xl p-1">
                <div class="text-sm font-bold uppercase text-[#0A2136]">{{ timeMessage }}</div>
                <div class="bg-[#0A2136] rounded-xl p-4">
                    <div class="md:text-2xl font-bold text-[#46c2f7] mb-1">{{ formattedTime }}</div>
                </div>
            </div>
        </div>

        <!-- Mensaje de estadísticas (solo para QuickLevel) -->
        <p v-if="showStats" class="mb-4 text-gray-300">
            Has completado {{ correctAnswersCount }} de {{ totalExercises }} ejercicios correctamente.
        </p>

        <!-- Sección de desbloqueo -->
        <div v-if="showUnlockSection" class="mb-4">
            <!-- Mensaje de desbloqueo exitoso -->
            <div v-if="unlockedNextLevelUnit && performance >= 0.8" class="p-4 bg-green-900/20 rounded-lg">
                <h3 class="font-semibold text-green-400 mb-2">¡Nuevo Nivel Desbloqueado!</h3>
                <p class="text-sm">¡Felicidades! Has desbloqueado la Unidad 1 del Nivel {{ nextLevelId }}</p>
                <div class="mt-2 flex items-center justify-center gap-2">
                    <span class="w-2 h-2 bg-green-400 rounded-full"></span>
                    <span class="text-sm">Nivel {{ nextLevelId }} - Unidad 1 disponible</span>
                </div>
            </div>

            <!-- Mensaje de nivel insuficiente -->
            <div v-else-if="performance < 0.8" class="p-4 bg-yellow-900/20 rounded-lg">
                <h3 class="font-semibold text-yellow-400 mb-2">Sigue practicando</h3>
                <p class="text-sm">Necesitas al menos 80% de aciertos para desbloquear el siguiente nivel.</p>
                <p class="text-sm mt-1">Obtuviste: {{ Math.round(performance * 100) }}%</p>
            </div>
        </div>

        <!-- Botón de acción -->
        <div class="flex flex-col fixed bottom-0 left-0 right-0 p-4 bg-[#0A2136] md:static md:p-0 md:bg-transparent">
            <router-link :to="backRoute" class="w-full">
                <button
                    class="bg-[#31771c] hover:bg-[#58cc02] text-white font-extrabold py-3 px-6 rounded-lg transition-colors w-full">
                    {{ buttonText }}
                </button>
            </router-link>
        </div>

    </Card>
</template>

<script>
import Card from './Card.vue';

export default {
    name: "CompletionMessage",
    components: {
        Card
    },
    props: {
        // Propiedades básicas
        title: {
            type: String,
            required: true
        },
        backRoute: {
            type: String,
            required: true
        },
        buttonText: {
            type: String,
            default: "RECIBIR EXP"
        },

        // Propiedades para QuickLevel
        showStats: {
            type: Boolean,
            default: false
        },
        correctAnswersCount: {
            type: Number,
            default: 0
        },
        totalExercises: {
            type: Number,
            default: 0
        },

        // Propiedades de desempeño
        performance: {
            type: Number,
            default: 0
        },
        lessonTime: {
            type: Number, // tiempo en segundos
            default: 0
        },

        // Propiedades de desbloqueo
        showUnlockSection: {
            type: Boolean,
            default: false
        },
        unlockedNextLevelUnit: {
            type: Boolean,
            default: false
        },
        nextLevelId: {
            type: [String, Number],
            default: null
        }
    },
    computed: {
        // Calcular EXP basado en desempeño y tiempo
        totalExp() {
            const baseExp = 100;
            const performanceBonus = Math.round(this.performance * 50); // +50 exp máximo por buen desempeño
            const timeBonus = this.calculateTimeBonus(); // Bonus por velocidad

            return baseExp + performanceBonus + timeBonus;
        },

        // Mensaje basado en porcentaje de aciertos
        performanceMessage() {
            if (this.performance >= 0.95) return "¡Increíble!";
            if (this.performance >= 0.70) return "¡Buen trabajo!";
            return "¡Bien!";
        },

        // Formatear tiempo (mm:ss)
        formattedTime() {
            const minutes = Math.floor(this.lessonTime / 60);
            const seconds = this.lessonTime % 60;
            return `${minutes}:${seconds.toString().padStart(2, '0')}`;
        },

        // Mensaje basado en tiempo
        timeMessage() {
            const minutes = Math.floor(this.lessonTime / 60);

            if (minutes < 3) return "¡Qué veloz!";
            if (minutes < 6) return "¡Imparable!";
            return "¡Buen ritmo!";
        }
    },
    methods: {
        // Calcular bonus por tiempo (más rápido = más bonus)
        calculateTimeBonus() {
            const minutes = Math.floor(this.lessonTime / 60);

            if (minutes < 3) return 30; // Bonus máximo por velocidad
            if (minutes < 6) return 20;
            if (minutes < 10) return 10;
            return 5; // Bonus mínimo
        }
    }
};
</script>