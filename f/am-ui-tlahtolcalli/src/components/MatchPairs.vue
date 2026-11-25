<template>
    <!-- "Selecciona los pares" (src/data/lessonPlan.js → matchExercise): náhuatl | español.
         Cada pareja se revisa al tocarla; al completar todas emite "done" con los errores. -->
    <!-- Una sola cuadrícula (fila por fila) para que las dos columnas queden alineadas aunque un texto ocupe 2 líneas -->
    <div class="grid grid-cols-2 gap-3 md:gap-4 w-full" translate="no">
        <template v-for="(_, k) in left" :key="k">
            <button v-for="(col, c) in columns" :key="`${c}-${col.order[k]}`" type="button"
                :disabled="matched.has(col.order[k]) || done" :class="tileClass(c, col.order[k])"
                class="tl-choice min-h-[64px] md:min-h-[56px] px-3 py-2 text-base md:text-lg flex items-center justify-center text-center break-words"
                @click="pick(c, col.order[k])">
                {{ col.text(col.order[k]) }}
            </button>
        </template>
    </div>
</template>

<script>
const LEFT = 0;
const RIGHT = 1;

export default {
    name: 'MatchPairs',
    props: {
        pairs: { type: Array, required: true },  // [{ word, meaning }]
        left: { type: Array, required: true },   // orden de la columna en la lengua
        right: { type: Array, required: true },  // orden de la columna en español
    },
    emits: ['done'],
    data() {
        return {
            sel: [null, null],      // índice de pareja elegido en cada columna
            matched: new Set(),
            flash: null,            // { ok, l, r } durante la animación de acierto/error
            mistakes: 0,
            done: false,
        };
    },
    computed: {
        columns() {
            return [
                { order: this.left, text: i => this.pairs[i].word },
                { order: this.right, text: i => this.pairs[i].meaning },
            ];
        },
    },
    methods: {
        tileClass(c, i) {
            const f = this.flash;
            if (f && (c === LEFT ? f.l : f.r) === i) return f.ok ? 'is-correct' : 'is-wrong';
            if (this.matched.has(i)) return 'opacity-40';
            return this.sel[c] === i ? 'is-selected' : '';
        },
        pick(c, i) {
            if (this.flash && !this.flash.ok) return; // esperar a que pase el parpadeo de error
            this.sel[c] = this.sel[c] === i ? null : i;
            const [l, r] = this.sel;
            if (l === null || r === null) return;

            const ok = l === r;
            this.flash = { ok, l, r };
            this.sel = [null, null];
            if (ok) this.matched.add(l);
            else this.mistakes++;

            setTimeout(() => {
                if (this.flash && this.flash.l === l && this.flash.r === r) this.flash = null;
                if (ok && this.matched.size === this.pairs.length && !this.done) {
                    this.done = true;
                    this.$emit('done', this.mistakes);
                }
            }, ok ? 350 : 550);
        },
    },
};
</script>
