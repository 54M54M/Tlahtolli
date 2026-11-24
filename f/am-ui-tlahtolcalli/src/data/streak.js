// src/data/streak.js
// Nivel de la racha según los días seguidos: cambia el color del fuego (StreakFlame.vue) y del número.
//   0 → gris · 1–49 → fuego normal · 50–199 → rojo · 200–499 → morado · 500+ → azul

export const STREAK_TIERS = [
    { min: 500, id: 'azul',    name: 'Fuego azul',    outer: '#2563EB', inner: '#67E8F9', text: 'text-sky-300',    glow: true },
    { min: 200, id: 'morado',  name: 'Fuego morado',  outer: '#7C3AED', inner: '#E879F9', text: 'text-violet-300' , glow: true },
    { min: 50,  id: 'rojo',    name: 'Fuego rojo',    outer: '#DC2626', inner: '#FB923C', text: 'text-red-400',     glow: false },
    { min: 1,   id: 'normal',  name: 'Fuego',         outer: '#F97316', inner: '#FCD34D', text: 'text-amber-300',   glow: false },
    { min: 0,   id: 'apagado', name: 'Sin racha',     outer: '#6B7280', inner: '#9CA3AF', text: 'text-gray-400',    glow: false },
]

export function streakTier(days) {
    const n = Number(days) || 0
    return STREAK_TIERS.find(t => n >= t.min) ?? STREAK_TIERS[STREAK_TIERS.length - 1]
}
