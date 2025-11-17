<!--
NO SE MUETRA EL TOOLTIP, SE ILUMINA LA RESPUESTA CORRECTA
-- analizar todos estos archivos --
--->
<template>
    <div ref="containerRef" class="pronunciation-tooltip-container inline-block relative">
        <!-- Palabra con subrayado punteado -->
        <span class="pronunciation-word border-b-2 border-dotted transition-colors duration-200" :class="{
            'border-gray-400 hover:border-blue-400': !showResult,
            'border-green-400': showResult && isCorrect,
            'border-red-400': showResult && !isCorrect
        }" @mouseenter="handleMouseEnter" @mouseleave="showTooltip = false">
            <slot>{{ word }}</slot>
        </span>

        <!-- Tooltip -->
        <div v-if="showTooltip && (pronunciation || translation)"
            class="pronunciation-tooltip absolute z-50 text-white rounded-xl shadow-2xl text-sm transform -translate-x-1/2 left-1/2 transition-all duration-300"
            :class="[tooltipPositionClass, tooltipVisibilityClass]" :style="tooltipStyle">

            <!-- Contenido principal del tooltip -->
            <div class="flex flex-col gap-2">
                <!-- Pronunciación -->
                <div v-if="pronunciation"
                    class="flex items-center gap-2 rounded-lg px-3 py-2 bg-[#0a2136] border border-[#37464f]">
                    <span class="text-blue-200 font-semibold text-sm tracking-wide">
                        {{ pronunciation }}
                    </span>
                </div>
            </div>

            <!-- Flecha del tooltip - posición dinámica -->
            <div class="absolute w-3 h-3 transform rotate-45 bg-[#37464f] border border-[#37464f] -z-10"
                :class="arrowPositionClass">
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'PronunciationTooltip',
    props: {
        word: {
            type: String,
            default: ''
        },
        pronunciation: {
            type: String,
            default: ''
        },
        translation: {
            type: String,
            default: ''
        },
        example: {
            type: String,
            default: ''
        },
        language: {
            type: String,
            default: 'nhce'
        },
        showResult: {
            type: Boolean,
            default: false
        },
        isCorrect: {
            type: Boolean,
            default: false
        },
        exerciseType: {
            type: String,
            default: 'multiple-choice'
        }
    },
    data() {
        return {
            showTooltip: false,
            tooltipPosition: 'bottom' // 'bottom' o 'top'
        };
    },
    mounted() {
        // console.log('🎯 PronunciationTooltip montado:', {
        //     word: this.word,
        //     pronunciation: this.pronunciation,
        //     translation: this.translation
        // });
    },
    computed: {
        tooltipVisibilityClass() {
            return this.showTooltip ?
                'opacity-100 visible scale-100 translate-y-0' :
                'opacity-0 invisible scale-95 -translate-y-1';
        },
        tooltipPositionClass() {
            return this.tooltipPosition === 'bottom'
                ? 'top-full mt-2'
                : 'bottom-full mb-2';
        },
        arrowPositionClass() {
            if (this.tooltipPosition === 'bottom') {
                return '-top-1.5 left-1/2 -translate-x-1/2 border-r border-b';
            } else {
                return '-bottom-1.5 left-1/2 -translate-x-1/2 border-l border-t';
            }
        },
        tooltipStyle() {
            // Asegurar que el tooltip no se salga de la pantalla horizontalmente
            return {
                // 'min-width': '200px',
                'max-width': '300px',
                'width': 'max-content'

            };
        }
    },
    methods: {
        handleMouseEnter() {
            this.showTooltip = true;
            this.$nextTick(() => {
                this.checkTooltipPosition();
            });
        },
        checkTooltipPosition() {
            if (!this.showTooltip || !this.$refs.containerRef) return;

            const container = this.$refs.containerRef;
            const containerRect = container.getBoundingClientRect();
            const viewportHeight = window.innerHeight;

            // Estimamos la altura del tooltip
            const estimatedTooltipHeight = 120; // Altura aproximada del tooltip con contenido

            // Si no hay suficiente espacio abajo (dejamos 20px de margen), mostramos arriba
            if (containerRect.bottom + estimatedTooltipHeight > viewportHeight - 20) {
                this.tooltipPosition = 'top';
            } else {
                this.tooltipPosition = 'bottom';
            }
        }
    }
}
</script>

<style scoped>
.pronunciation-tooltip-container {
    position: relative;
    display: inline-block;
}

.pronunciation-word {
    position: relative;
    transition: all 0.2s ease-in-out;
}

.pronunciation-tooltip {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    white-space: normal;
    pointer-events: auto;
    backdrop-filter: blur(10px);
}

.pronunciation-tooltip::before {
    content: '';
    position: absolute;
    top: -1px;
    left: -1px;
    right: -1px;
    bottom: -1px;
    background: linear-gradient(135deg, rgba(59, 130, 246, 0.1), rgba(16, 185, 129, 0.1));
    border-radius: inherit;
    z-index: -1;
}
</style>