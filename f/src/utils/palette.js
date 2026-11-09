// src/utils/palette.js
// Colores de datos (niveles, idiomas, rarezas) resueltos en el frontend.
// El color es presentación: no se guarda en la base de datos. Todo sale de los
// tokens definidos en src/style.css, así un cambio de paleta o de tema se hace
// en un solo lugar y sin tocar datos.

/** Ciclo de colores de nivel (level-1 … level-6 del sistema de diseño). */
const LEVEL_TOKENS = ['turquesa', 'azul-maya', 'cempasuchil', 'grana', 'barro', 'tezontle']

/** Color de identidad por familia lingüística. */
const FAMILY_TOKENS = {
    'uto-aztec': 'turquesa',
    maya: 'azul-maya',
}

/** Color de identidad por prefijo de código cuando no hay familia. */
const CODE_PREFIX_TOKENS = [
    ['nh', 'turquesa'],   // náhuatl: nhce, nhcl, nhhu…
    ['tk', 'azul-maya'],  // tének: tkoc…
    ['hus', 'azul-maya'], // huasteco (código ISO)
]

const RARITY_TOKENS = {
    common: 'turquesa',
    rare: 'azul-maya',
    epic: 'grana',
    legendary: 'cempasuchil',
}

/**
 * Color CSS de un token. Con alpha < 1 devuelve la versión translúcida.
 * token('turquesa') → 'rgb(var(--turquesa))'
 * token('turquesa', 0.25) → 'rgb(var(--turquesa) / 0.25)'
 */
export function token(name, alpha = 1) {
    return alpha >= 1 ? `rgb(var(--${name}))` : `rgb(var(--${name}) / ${alpha})`
}

export function levelToken(levelNum) {
    const n = Math.max(1, Number(levelNum) || 1)
    return LEVEL_TOKENS[(n - 1) % LEVEL_TOKENS.length]
}

/** Color de un nivel (y de sus unidades) a partir de su número. */
export function levelColor(levelNum, alpha = 1) {
    return token(levelToken(levelNum), alpha)
}

/** Acepta un código ('nhce') o un objeto idioma ({ code, family }). */
export function languageToken(lang) {
    const family = typeof lang === 'object' ? lang?.family : null
    if (family && FAMILY_TOKENS[family]) return FAMILY_TOKENS[family]

    const code = String(typeof lang === 'object' ? lang?.code ?? lang?.id ?? '' : lang ?? '').toLowerCase()
    const match = CODE_PREFIX_TOKENS.find(([prefix]) => code.startsWith(prefix))
    return match ? match[1] : 'turquesa'
}

export function languageColor(lang, alpha = 1) {
    return lang ? token(languageToken(lang), alpha) : token('ink-muted', alpha)
}

export function rarityColor(rarity, alpha = 1) {
    return token(RARITY_TOKENS[rarity] || 'turquesa', alpha)
}

/** Plugin: expone los helpers en todas las plantillas como $levelColor, $languageColor… */
export const palettePlugin = {
    install(app) {
        app.config.globalProperties.$token = token
        app.config.globalProperties.$levelColor = levelColor
        app.config.globalProperties.$languageColor = languageColor
        app.config.globalProperties.$rarityColor = rarityColor
    },
}
