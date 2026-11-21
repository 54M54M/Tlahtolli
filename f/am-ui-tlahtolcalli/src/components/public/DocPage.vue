<template>
    <!-- Página de texto (privacidad, términos, novedades) con el marco público -->
    <PublicShell>
        <main class="px-4 py-12 md:py-16">
            <article class="doc container mx-auto max-w-3xl">
                <p class="text-sm font-semibold tracking-widest text-turquesa uppercase mb-3">Tlahtolcalli</p>
                <h1 class="text-4xl md:text-5xl font-bold mb-4">{{ title }}</h1>
                <p v-if="updated" class="text-sm text-gray-400 mb-8">Última actualización: {{ updated }}</p>
                <div v-if="$slots.intro" class="bg-surface-2 border border-line rounded-xl p-5 md:p-6 mb-4">
                    <slot name="intro" />
                </div>
                <slot />
            </article>
        </main>
    </PublicShell>
</template>

<script setup>
import PublicShell from './PublicShell.vue'
defineProps({ title: String, updated: String })
</script>

<style scoped>
.doc :slotted(h2) { font-size: 1.375rem; font-weight: 700; margin: 2.5rem 0 .75rem; scroll-margin-top: 6rem; }
.doc :slotted(h3) { font-size: 1.05rem; font-weight: 700; margin: 1.5rem 0 .5rem; }
.doc :slotted(p), .doc :slotted(li), .doc :deep(p), .doc :deep(li) { color: #c9cfc9; line-height: 1.7; }
.doc :deep(p + p) { margin-top: .75rem; }
.doc :deep(ul.list) { list-style: disc; padding-left: 1.25rem; margin: .5rem 0; }
.doc :deep(ul.list li + li) { margin-top: .35rem; }
.doc :deep(a.lnk) { color: rgb(var(--turquesa)); font-weight: 600; }
.doc :deep(a.lnk:hover) { text-decoration: underline; }
.doc :deep(strong) { color: #ece6da; }
.doc :deep(table) { width: 100%; border-collapse: collapse; margin: .75rem 0; font-size: .95rem; }
.doc :deep(th), .doc :deep(td) { text-align: left; padding: .6rem .75rem; border-bottom: 1px solid rgb(var(--line)); vertical-align: top; }
.doc :deep(th) { color: #ece6da; font-weight: 600; background: rgb(var(--surface-1)); }
.doc :deep(td) { color: #c9cfc9; }
</style>
