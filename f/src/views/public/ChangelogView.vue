<template>
    <DocPage title="Novedades">
        <template #intro>
            <p>Lo que cambia en Tlahtolcalli, versión por versión. ¿Encontraste un error o tienes una idea?
                Escríbenos a <a class="lnk" :href="`mailto:${MAIL}?subject=Sugerencia`">{{ MAIL }}</a>.</p>
        </template>

        <ol class="mt-10 relative border-l border-line ml-2">
            <li v-for="(r, i) in CHANGELOG" :key="r.date + r.title" class="pl-6 pb-10 last:pb-0 relative">
                <span class="absolute -left-[7px] top-2 w-3 h-3 rounded-full"
                    :class="i === 0 ? 'bg-turquesa ring-4 ring-turquesa/20' : 'bg-line'"></span>
                <div class="flex flex-wrap items-baseline gap-x-3 gap-y-1 mb-1">
                    <h2 class="!m-0 text-xl md:text-2xl font-bold">{{ r.title }}</h2>
                    <span v-if="r.version" class="text-xs font-semibold px-2 py-0.5 rounded-full bg-surface-2 border border-line text-gray-300 tabular-nums">v{{ r.version }}</span>
                </div>
                <p class="!mt-0 text-sm text-gray-400 mb-4"><time :datetime="r.date">{{ formatChangelogDate(r.date) }}</time></p>
                <ul class="space-y-2">
                    <li v-for="it in r.items" :key="it.text" class="flex gap-3 items-start">
                        <span class="shrink-0 mt-0.5 text-[11px] font-bold uppercase tracking-wider px-2 py-0.5 rounded"
                            :class="TYPES[it.type].cls">{{ TYPES[it.type].label }}</span>
                        <span>{{ it.text }}</span>
                    </li>
                </ul>
            </li>
        </ol>
    </DocPage>
</template>

<script setup>
import DocPage from '../../components/public/DocPage.vue'
import { CHANGELOG, formatChangelogDate } from '../../data/changelog'

const MAIL = 'contacto.tlahtolcalli@gmail.com'
const TYPES = {
    nuevo: { label: 'Nuevo', cls: 'bg-turquesa/15 text-turquesa' },
    mejora: { label: 'Mejora', cls: 'bg-azul-maya/15 text-azul-maya' },
    correccion: { label: 'Corrección', cls: 'bg-cempasuchil/15 text-cempasuchil' },
}
</script>
