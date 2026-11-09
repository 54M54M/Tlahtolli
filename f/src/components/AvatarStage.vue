<template>
  <!-- Escenario animado detrás del avatar (solo en el login).
       Cada usuario tiene UNA forma (burbujas, picos o nubes) y sus propios
       movimientos; todo comparte un color y una opacidad de grupo, así las
       zonas encimadas no se oscurecen y se lee como una sola mancha. -->
  <div class="relative shrink-0" :style="{ width: `${stageSize}px`, height: `${stageSize}px` }">
    <svg class="absolute inset-0 w-full h-full overflow-visible" viewBox="0 0 200 200" aria-hidden="true">
      <g :fill="tint" opacity="0.32" class="avatar-stage-tint">
        <g ref="pulseRef">
          <circle cx="100" cy="100" r="52" />
          <g ref="itemsRef" :key="config.key">
            <template v-if="config.kind === 'picos'">
              <polygon v-for="(it, i) in config.items" :key="i" points="100,100 100,100 100,100" />
            </template>
            <template v-else>
              <circle v-for="(it, i) in config.items" :key="i" cx="100" cy="100" :r="it.r" />
            </template>
          </g>
        </g>
      </g>
    </svg>
    <div class="absolute inset-0 flex items-center justify-center">
      <UserAvatar :name="name" :size="size" />
    </div>
  </div>
</template>

<script setup>
// Fondo animado del avatar en el login, al estilo del loader de SICS: siempre en
// movimiento y con un parámetro de velocidad.
//
// · La forma sale del usuario (determinista): el mismo usuario siempre tiene la
//   misma forma, el mismo número de piezas y los mismos movimientos.
//     burbujas → orbitan cada una a su ritmo y en su sentido, entrando y saliendo
//     picos    → salen hacia afuera y regresan, uno tras otro
//     nubes    → medios círculos en el borde que se inflan y desinflan mientras giran
// · Mientras el usuario escribe, el reloj de la animación acelera; al dejar de
//   escribir frena suavemente hasta el ritmo base.
import { computed, onBeforeUnmount, onMounted, ref, watch, nextTick } from 'vue'
import { blobatar } from 'blobatar'
import UserAvatar from './UserAvatar.vue'

const props = defineProps({
  /** Usuario que se está escribiendo. */
  name: { type: String, default: '' },
  /** Tamaño del avatar en px; el escenario mide ~2 veces eso. */
  size: { type: Number, default: 72 },
})

const DEFAULT_SEED = 'tlahtolcalli'
const IDLE_RATE = 1       // velocidad del reloj en reposo
const FAST_RATE = 4.5     // velocidad del reloj mientras cambia el avatar
const SETTLE_MS = 450     // tiempo sin teclear para considerarlo "seleccionado"
const ACCEL = 6           // qué tan rápido acelera (mayor = más brusco)
const DECEL = 1.6         // qué tan rápido frena

const stageSize = computed(() => Math.round(props.size * 2.05))
const seed = computed(() => (props.name || '').trim().toLowerCase() || DEFAULT_SEED)

// Color del fondo: el del cuerpo del blob, así cambia con el avatar
const tint = computed(() => {
  const match = blobatar(seed.value).match(/<g fill="(#[0-9a-fA-F]{3,8})"/)
  return match ? match[1] : 'rgb(var(--turquesa))'
})

// ── Aleatorio determinista por usuario ────────────────────────────────────────
function hash(str) {
  let h = 2166136261
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i)
    h = Math.imul(h, 16777619)
  }
  return h >>> 0
}
function rng(seedNum) {
  let a = seedNum
  return () => {
    a = (a + 0x6d2b79f5) | 0
    let t = Math.imul(a ^ (a >>> 15), 1 | a)
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296
  }
}
const between = (rand, min, max) => min + rand() * (max - min)
const TAU = Math.PI * 2

const KINDS = ['burbujas', 'picos', 'nubes']

function buildConfig(s) {
  const rand = rng(hash(`stage:${s}`))
  const kind = KINDS[Math.floor(rand() * KINDS.length)]

  if (kind === 'burbujas') {
    const n = 6 + Math.floor(rand() * 4)
    return {
      kind, key: `${kind}:${s}`,
      items: Array.from({ length: n }, () => ({
        r: between(rand, 3.5, 10),
        orbit: between(rand, 62, 82),          // radio medio de la órbita
        swing: between(rand, 12, 24),          // cuánto entra y sale
        spin: between(rand, 0.35, 1.1) * (rand() < 0.5 ? -1 : 1), // sentido y ritmo de giro
        breathe: between(rand, 0.6, 1.6),      // ritmo de entrar/salir
        a0: rand() * TAU,
        p0: rand() * TAU,
      })),
    }
  }

  if (kind === 'picos') {
    const n = 6 + Math.floor(rand() * 5)
    const drift = between(rand, 0.05, 0.2) * (rand() < 0.5 ? -1 : 1)
    return {
      kind, key: `${kind}:${s}`, drift,
      items: Array.from({ length: n }, (_, i) => ({
        angle: (TAU / n) * i + between(rand, -0.15, 0.15),
        half: between(rand, 0.14, 0.24),       // medio ancho de la base (rad)
        reach: between(rand, 18, 36),          // cuánto sale
        speed: between(rand, 1.1, 1.9),
        p0: (TAU / n) * i * 1.0 + rand() * 0.6, // desfase: salen uno tras otro
      })),
    }
  }

  const n = 7 + Math.floor(rand() * 5)
  const drift = between(rand, 0.12, 0.3) * (rand() < 0.5 ? -1 : 1)
  return {
    kind, key: `${kind}:${s}`, drift,
    items: Array.from({ length: n }, (_, i) => ({
      angle: (TAU / n) * i + between(rand, -0.12, 0.12),
      r: between(rand, 12, 18),
      puff: between(rand, 0.15, 0.3),            // cuánto se infla
      speed: between(rand, 0.8, 1.6),
      p0: rand() * TAU,
    })),
  }
}

const config = computed(() => buildConfig(seed.value))

// ── Animación ─────────────────────────────────────────────────────────────────
const pulseRef = ref(null)
const itemsRef = ref(null)

let rafId = 0
let last = 0
let clock = 0
let rate = IDLE_RATE
let target = IDLE_RATE
let settleTimer = 0

const reducedMotion = typeof window !== 'undefined'
    && window.matchMedia?.('(prefers-reduced-motion: reduce)').matches

const pt = (r, a) => `${(100 + r * Math.cos(a)).toFixed(2)},${(100 + r * Math.sin(a)).toFixed(2)}`

function draw() {
  const cfg = config.value
  const nodes = itemsRef.value?.children || []
  const energy = (rate - IDLE_RATE) / (FAST_RATE - IDLE_RATE) // 0 en reposo, 1 a tope
  const t = clock

  cfg.items.forEach((it, i) => {
    const node = nodes[i]
    if (!node) return

    if (cfg.kind === 'burbujas') {
      const r = it.orbit + Math.sin(t * it.breathe + it.p0) * (it.swing + 6 * energy)
      const a = it.a0 + t * it.spin
      node.setAttribute('cx', (100 + r * Math.cos(a)).toFixed(2))
      node.setAttribute('cy', (100 + r * Math.sin(a)).toFixed(2))
    } else if (cfg.kind === 'picos') {
      const out = 0.5 + 0.5 * Math.sin(t * it.speed - it.p0) // 0 adentro, 1 afuera
      const a = it.angle + t * cfg.drift
      const tip = 50 + it.reach * out * (1 + 0.25 * energy)
      node.setAttribute('points',
          `${pt(48, a - it.half)} ${pt(tip, a)} ${pt(48, a + it.half)}`)
    } else {
      const swell = 1 + it.puff * Math.sin(t * it.speed + it.p0)
      const a = it.angle + t * cfg.drift
      const r = 54 + 4 * Math.sin(t * it.speed * 0.7 + it.p0)
      node.setAttribute('cx', (100 + r * Math.cos(a)).toFixed(2))
      node.setAttribute('cy', (100 + r * Math.sin(a)).toFixed(2))
      node.setAttribute('r', (it.r * swell).toFixed(2))
    }
  })

  const scale = 1 + 0.05 * energy
  pulseRef.value?.setAttribute('transform',
      `translate(100 100) scale(${scale.toFixed(4)}) translate(-100 -100)`)
}

function frame(now) {
  const dt = Math.min((now - (last || now)) / 1000, 0.05)
  last = now
  const k = target > rate ? ACCEL : DECEL
  rate += (target - rate) * (1 - Math.exp(-k * dt))
  clock += dt * rate
  draw()
  rafId = requestAnimationFrame(frame)
}

watch(() => props.name, () => {
  if (reducedMotion) { nextTick(draw); return }
  target = FAST_RATE
  clearTimeout(settleTimer)
  settleTimer = setTimeout(() => { target = IDLE_RATE }, SETTLE_MS)
})

onMounted(() => {
  if (reducedMotion) { draw(); return }
  rafId = requestAnimationFrame(frame)
})

onBeforeUnmount(() => {
  cancelAnimationFrame(rafId)
  clearTimeout(settleTimer)
})
</script>

<style scoped>
.avatar-stage-tint {
  transition: fill 0.4s ease;
}
</style>