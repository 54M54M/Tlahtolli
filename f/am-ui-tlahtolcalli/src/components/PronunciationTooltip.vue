<template>
  <div ref="containerRef" class="pronunciation-tooltip-container inline-block relative">
    <!-- Palabra con subrayado punteado -->
    <span class="pronunciation-word border-b-2 border-dotted transition-colors duration-200" :class="{
            'border-gray-400 hover:border-blue-400': !showResult,
            'border-green-400': showResult && isCorrect,
            'border-error': showResult && !isCorrect
        }" @mouseenter="handleMouseEnter" @mouseleave="showTooltip = false">
            <slot>{{ word }}</slot>
        </span>

    <!-- Tooltip -->
    <div v-if="showTooltip && (pronunciation || translation || parts.length)"
         class="pronunciation-tooltip absolute z-50 text-white rounded-xl shadow-2xl text-sm transform -translate-x-1/2 left-1/2 transition-all duration-300"
         :class="[tooltipPositionClass, tooltipVisibilityClass]" :style="tooltipStyle">

      <!-- Una sola tarjeta: pronunciación arriba y, si hay desglose, una tabla "parte | significado" -->
      <div class="rounded-lg overflow-hidden border border-line bg-surface-0 grid grid-cols-[minmax(0,auto)_1fr]">
        <div v-if="pronunciation" class="col-span-2 px-3 py-2"
             :class="{ 'border-b border-line': parts.length }">
          <span class="text-blue-200 font-semibold text-sm tracking-wide">{{ pronunciation }}</span>
        </div>
        <template v-for="(p, i) in parts" :key="i">
          <span class="px-3 py-1.5 font-semibold text-white whitespace-nowrap border-r border-line"
                :class="{ 'border-t': i > 0 }">{{ p.form }}</span>
          <span class="px-3 py-1.5 text-gray-300 border-line" :class="{ 'border-t': i > 0 }">{{ p.meaning }}</span>
        </template>
      </div>

      <!-- Flecha del tooltip - posición dinámica -->
      <div class="absolute w-3 h-3 transform rotate-45 bg-surface-0 border border-line -z-10"
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
    /** Desglose de la palabra (columna breakdown de ct_vocabulary): "no- = mi; tōka = nombre" */
    breakdown: {
      type: String,
      default: ''
    },
    language: {
      type: String,
      default: null
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
    parts() {
      return String(this.breakdown || '')
          .split(';')
          .map(row => {
            const [form, ...rest] = row.split('=')
            return { form: (form || '').trim(), meaning: rest.join('=').trim() }
          })
          .filter(p => p.form && p.meaning);
    },
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
  background: linear-gradient(135deg, rgba(90, 169, 204, 0.1), rgba(43, 181, 154, 0.1));
  border-radius: inherit;
  z-index: -1;
}
</style>