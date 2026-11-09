/** @type {import('tailwindcss').Config} */

// ── Sistema visual Tlahtolcalli ─────────────────────────────────────────────
// Los tokens semánticos (surface-0, turquesa, cempasuchil…) viven en
// src/style.css como canales RGB, así aceptan opacidad: bg-turquesa/20.
// Las escalas de Tailwind (gray, green, blue, red, yellow…) se reasignan a la
// paleta de la marca para que las clases existentes adopten los colores nuevos.
const token = (name) => `rgb(var(--${name}) / <alpha-value>)`

const neutral = {
  50: '#f6f3ec', 100: '#ece6da', 200: '#e5e5e5', 300: '#d4d4d4', 400: '#a3a3a3',
  500: '#a3a3a3', 600: '#56666a', 700: '#2e3f45', 750: '#26363b', 800: '#1f2d32',
  900: '#162125', 950: '#0e1517',
}
const turquesa = {
  50: '#e6f6f2', 100: '#cfe7df', 200: '#b0e8da', 300: '#8fdcc8', 400: '#4cc7ab',
  500: '#2bb59a', 600: '#1f9580', 700: '#146b5b', 800: '#0f5a4c', 900: '#173b35', 950: '#0f2925',
}
const azulMaya = {
  50: '#eaf4f9', 100: '#d7eaf3', 200: '#c4e1ee', 300: '#9fcde2', 400: '#6fb5d4',
  500: '#4f9fc4', 600: '#3f8db1', 700: '#2c7092', 800: '#1f536d', 900: '#163b4d', 950: '#0f2633',
}
const cempasuchil = {
  50: '#fef6e4', 100: '#fcebc4', 200: '#fadc9c', 300: '#f9d27a', 400: '#f6bd45',
  500: '#f2a516', 600: '#c98510', 700: '#9c650c', 800: '#6e470a', 900: '#3a2e14', 950: '#271f0d',
}
// Ya no se usa en el código (los errores van con los tokens error / error-deep /
// error-soft). Se conserva para que cualquier clase red-* nueva siga en paleta.
const error = {
  50: '#fff0ee', 100: '#ffdcd7', 200: '#ffc7c0', 300: '#ffb3aa', 400: '#ff8a7d',
  500: '#ff6b5b', 600: '#c94335', 700: '#a8352a', 800: '#7d271f', 900: '#3d1d1a', 950: '#2a1412',
}
const grana = {
  50: '#fdeef0', 100: '#f9d9de', 200: '#f5c1c9', 300: '#f5aab4', 400: '#ec6f80',
  500: '#d9566a', 600: '#b83d52', 700: '#a3213a', 800: '#7a1a2c', 900: '#3b1e25', 950: '#2a1519',
}

export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Figtree', '"Segoe UI"', 'system-ui', 'sans-serif'],
        display: ['"Bricolage Grotesque"', '"Segoe UI"', 'system-ui', 'sans-serif'],
      },
      colors: {
        // Tokens semánticos
        'surface-0': token('surface-0'),
        'surface-1': token('surface-1'),
        'surface-2': token('surface-2'),
        'surface-3': token('surface-3'),
        'surface-4': token('surface-4'),
        'surface-5': token('surface-5'),
        'surface-6': token('surface-6'),
        'line': token('line'),
        'ink': token('ink'),
        'ink-muted': token('ink-muted'),
        'ink-on-color': token('ink-on-color'),
        'turquesa': token('turquesa'),
        'turquesa-soft': token('turquesa-soft'),
        'turquesa-deep': token('turquesa-deep'),
        'turquesa-deeper': token('turquesa-deeper'),
        'cempasuchil': token('cempasuchil'),
        'cempasuchil-soft': token('cempasuchil-soft'),
        'grana': token('grana'),
        'grana-soft': token('grana-soft'),
        'azul-maya': token('azul-maya'),
        'barro': token('barro'),
        'tezontle': token('tezontle'),
        'error': token('error'),
        'error-deep': token('error-deep'),
        'error-soft': token('error-soft'),

        // Escalas de Tailwind reasignadas a la paleta
        gray: neutral, slate: neutral, zinc: neutral, neutral: neutral, stone: neutral,
        green: turquesa, emerald: turquesa, teal: turquesa, lime: turquesa,
        blue: azulMaya, sky: azulMaya, cyan: azulMaya, indigo: azulMaya,
        yellow: cempasuchil, amber: cempasuchil, orange: cempasuchil,
        red: error, rose: grana, pink: grana, fuchsia: grana, purple: grana, violet: grana,
      },
    },
  },
  plugins: [],
}
