<template>
    <Card class="text-center md:px-10">
        <!-- Título principal -->
        <h2 class="text-xl font-semibold mb-4">{{ title }}</h2>

        <!-- Imagen de Toch -->
        <TochImage :performance="performance" :lessonTime="lessonTime" />

        <!-- Métricas de desempeño: misma altura en las 3 (título a 2 renglones fijos, valor centrado) -->
        <div class="grid grid-cols-3 gap-3 md:gap-4 mb-6">
            <div v-for="m in metrics" :key="m.key" :class="m.bg" class="rounded-xl p-1 flex flex-col">
                <div class="min-h-[2.6em] px-1 flex items-center justify-center text-[11px] md:text-[15px] leading-tight font-bold uppercase text-surface-0">
                    {{ m.label }}
                </div>
                <div class="flex-1 bg-surface-0 rounded-lg py-4 md:py-5 flex items-center justify-center">
                    <span :class="m.color" class="text-lg md:text-2xl font-bold">{{ m.value }}</span>
                </div>
            </div>
        </div>

        <!-- Mensaje de estadísticas (solo para QuickLevel) -->
        <p v-if="showStats" class="mb-4 text-gray-300">
            Has completado {{ correctAnswersCount }} de {{ totalExercises }} ejercicios correctamente.
        </p>

        <!-- Terminada sin conexión: se envía al reconectar -->
        <div v-if="pendingSync" role="status" class="mb-4 p-3 rounded-lg bg-amber-500/10 border border-amber-500/40 text-sm text-amber-200">
            Sin conexión: tu avance quedó guardado en este dispositivo y se enviará cuando vuelva el internet.
            La experiencia y los desbloqueos se actualizan en ese momento.
        </div>

        <!-- Sección de desbloqueo -->
        <div v-if="showUnlockSection && !pendingSync" class="mb-4">
            <!-- Mensaje de desbloqueo exitoso -->
            <div v-if="unlockedNextLevelUnit && performance >= 0.8" class="p-4 bg-green-900/20 rounded-lg">
                <!--h3 class="font-semibold text-green-400 mb-2">¡Nuevo Nivel Desbloqueado!</h3>
                <p class="text-sm">¡Felicidades! Has desbloqueado la Unidad 1 del Nivel {{ nextLevelId }}</p-->
                <div class="mt-2 flex items-center justify-center gap-2">
                    <span class="w-2 h-2 bg-green-400 rounded-full"></span>
                    <span class="text-sm">Nivel {{ nextLevelNum || '' }}, unidad 1 disponible</span>
                </div>
            </div>

            <!-- Mensaje de nivel insuficiente -->
            <div v-else-if="performance < 0.8" class="p-2 bg-yellow-900/20 rounded-lg">
                <h3 class="font-semibold text-yellow-400 mb-2">Sigue practicando</h3>
                <p class="text-sm">Necesitas al menos 80% de aciertos para desbloquear el siguiente nivel.</p>
            </div>
        </div>

        <!-- Botón de acción -->
        <div class="flex flex-col fixed bottom-0 left-0 right-0 p-4 bg-surface-0 md:static md:p-0 md:bg-transparent">
            <button type="button" @click="leave"
                class="bg-turquesa-deep hover:bg-turquesa-deeper text-white font-extrabold py-3 px-6 rounded-lg transition-colors w-full">
                {{ buttonText }}
            </button>
        </div>

    </Card>
</template>

<script>
import Card from './Card.vue';
import TochImage from './TochImage.vue';
import { leaveTo } from '../router/leave.js';

export default {
    name: "CompletionMessage",
    components: {
        Card,
        TochImage
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

        // Se terminó sin conexión (quedó en la cola de envíos)
        pendingSync: {
            type: Boolean,
            default: false
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
        },
        /** Número del nivel que ve la persona (levelNum), no el id de la BD */
        nextLevelNum: {
            type: [String, Number],
            default: null
        },
        earnedExp: {
            type: Number,
            default: null
        }
    },
    computed: {
        // Calcular EXP basado en desempeño y tiempo
        totalExp() {
            // Si se proporcionó earnedExp, usarlo directamente
            if (this.earnedExp !== null) {
                return this.earnedExp;
            }

            // Fallback al cálculo antiguo
            const baseExp = 100;
            const performanceBonus = Math.round(this.performance * 50);
            const timeBonus = this.calculateTimeBonus();

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

        metrics() {
            return [
                { key: 'exp', label: 'EXP totales', value: `${this.totalExp} EXP`, bg: 'bg-cempasuchil', color: 'text-cempasuchil' },
                { key: 'pct', label: this.performanceMessage, value: `${Math.round(this.performance * 100)}%`, bg: 'bg-turquesa', color: 'text-turquesa' },
                { key: 'time', label: this.timeMessage, value: this.formattedTime, bg: 'bg-azul-maya', color: 'text-azul-maya' },
            ];
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
        /** Salir sin dejar la lección en el historial (src/router/leave.js). */
        leave() {
            leaveTo(this.$router, this.backRoute);
        },
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