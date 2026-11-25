// Arma la secuencia de una lección (estilo Duolingo) con lo que ya hay en la base:
// los ejercicios escritos de la unidad + el vocabulario de la unidad + el de las unidades anteriores.
//
//   1. Palabra nueva   → la frase en la lengua; el usuario arma la traducción con fichas
//   2. Reconocer       → "Selecciona la traducción correcta" (español → lengua), unos ejercicios después
//   3. Ejercicios de la unidad (los de la base), intercalados con
//   4. Repaso          → palabras de unidades anteriores (español ↔ lengua)
//   5. Armar la frase  → frases de varias palabras: se arman en la lengua con fichas
//   6. Error anterior  → lo que se falló se repite al final (una vez)
//
// No necesita contenido nuevo: si la unidad no tiene vocabulario, la lección queda como antes
// (solo los ejercicios de la base). Los ejercicios generados no dan XP propia: la XP de la lección sigue
// siendo la de los ejercicios de la base (ver LessonView.calculateEarnedPoints).

export const BADGE = {
    NEW: 'new',          // Palabra nueva
    REVIEW: 'review',    // Repaso
    MISTAKE: 'mistake',  // Error anterior
}

const LIMITS = {
    intros: 4,      // palabras nuevas presentadas con fichas
    recognize: 3,   // "selecciona la traducción" de palabras nuevas
    reviews: 2,     // palabras de unidades anteriores
    builds: 2,      // frases de varias palabras para armar en la lengua
    distractors: 3, // fichas de más en cada banco
    pairs: 5,       // parejas en "Selecciona los pares" (mínimo 4)
}

const CHARACTERS = ['citlali', 'coltzin', 'neza', 'tonatiuh']
const PUNCT = /[¿?¡!.,;:"“”«»]/g

// ── utilidades ────────────────────────────────────────────────────────────────

export function shuffle(list, rnd = Math.random) {
    const a = [...list]
    for (let i = a.length - 1; i > 0; i--) {
        const j = Math.floor(rnd() * (i + 1));
        [a[i], a[j]] = [a[j], a[i]]
    }
    return a
}

/** Palabras de una frase, sin signos (para fichas y para comparar). */
export function tokenize(text) {
    return String(text ?? '')
        .replace(PUNCT, ' ')
        .split(/\s+/)
        .map(t => t.trim())
        .filter(Boolean)
}

/** Para comparar respuestas: minúsculas, sin signos, espacios simples. Conserva macrones y acentos. */
export function normalize(text) {
    return tokenize(text).join(' ').toLocaleLowerCase('es')
}

/**
 * Traducciones aceptadas de una entrada de vocabulario (ya listas para fichas, ver tileText):
 *   "¿cómo estás? (lit. ¿cómo vives?)" → ["¿cómo estás?"]
 *   "pase / bienvenido(a)"             → ["pase", "bienvenido(a)"]
 *   "su nombre (de él o ella)"         → ["el nombre de él/ella"]
 */
export function translationsOf(translation) {
    return String(translation ?? '')
        .replace(/\(lit\.[^)]*\)/gi, '')
        .split('/')
        .map(s => tileText(s))
        .filter(Boolean)
}

/**
 * Traducción lista para armarse con fichas (sin paréntesis que dejen fichas como "(de" o "ella)"):
 *   "su nombre (de él o ella)" → "el nombre de él/ella"
 *   "mi nombre (formal)"       → "mi nombre formal"
 *   "contento(a)"              → "contento(a)"   (pegado a la palabra: se queda igual, es una sola ficha)
 */
export function tileText(text) {
    let su = false
    const out = String(text ?? '')
        .replace(/\(lit\.[^)]*\)/gi, '')
        .replace(/\s\(([^)]*)\)/g, (_, inner) => {
            const body = inner.trim().replace(/\s+o\s+/g, '/').replace(/\s*\/\s*/g, '/')
            if (/^de\s/i.test(body)) su = true
            return ' ' + body
        })
        .replace(/\s+/g, ' ')
        .trim()
    // "su nombre de él/ella" → "el nombre de él/ella": el "de ..." ya dice de quién es
    return su ? out.replace(/^su\s/i, 'el ') : out
}

/** Vocabulario como lista [{ word, translation, pronunciation }], venga como objeto o arreglo. */
export function vocabList(vocab) {
    if (!vocab) return []
    const list = Array.isArray(vocab)
        ? vocab
        : Object.entries(vocab).map(([word, v]) => ({ word, ...(v || {}) }))
    const seen = new Set()
    return list.filter(v => {
        const key = normalize(v?.word)
        if (!key || !translationsOf(v.translation).length || seen.has(key)) return false
        seen.add(key)
        return true
    })
}

function pickCharacter(authored, rnd) {
    const fromUnit = authored.map(e => e.character).filter(Boolean)
    const pool = fromUnit.length ? fromUnit : CHARACTERS
    return pool[Math.floor(rnd() * pool.length)]
}

/** Fichas de distracción: palabras de otras frases que no estén en la respuesta. */
function distractorTiles(answerTokens, sourcePhrases, count, rnd) {
    const used = new Set(answerTokens.map(t => t.toLocaleLowerCase('es')))
    const pool = []
    for (const phrase of shuffle(sourcePhrases, rnd)) {
        for (const tok of tokenize(phrase)) {
            const key = tok.toLocaleLowerCase('es')
            if (!used.has(key)) { used.add(key); pool.push(tok) }
        }
    }
    return shuffle(pool, rnd).slice(0, count)
}


// ── opciones de opción múltiple ───────────────────────────────────────────────

/** Siempre 4 opciones. */
export const OPTIONS = 4

export const isQuestion = (text) => /\?\s*$/.test(String(text ?? '').trim())
const stripQuestion = (text) => String(text ?? '').replace(/[¿?]/g, '').replace(/\s+/g, ' ').trim()

/**
 * Distractores sin repetir: primero del mismo tipo que la correcta (pregunta con pregunta, frase con frase),
 * así el signo "?" no delata la respuesta; si no alcanzan, se completan con las del otro tipo.
 */
export function pickDistractors(correct, candidates, count, rnd = Math.random) {
    const seen = new Set([normalize(correct)])
    const unique = []
    for (const c of shuffle(candidates, rnd)) {
        const key = normalize(c)
        if (key && !seen.has(key)) { seen.add(key); unique.push(c) }
    }
    const q = isQuestion(correct)
    const same = unique.filter(c => isQuestion(c) === q)
    const other = unique.filter(c => isQuestion(c) !== q)
    return [...same, ...other].slice(0, count)
}

/**
 * Los signos de las opciones siguen al texto de la burbuja:
 *   "¿Cómo estás?"     → todas con signo: [Kēn tinemi?] [Kēn motōka?] [Timoittaske?] [Ximopanōlti?]
 *   "pase / bienvenido" → todas sin signo
 * En español se ponen los dos signos (¿…?); en la lengua solo el de cierre, como se escribe en el curso.
 * Sin texto en la burbuja: si se mezclan, se quitan a todas.
 */
export function matchQuestions(options, prompt, spanishOptions = false) {
    if (!String(prompt ?? '').trim()) {
        const qs = options.filter(isQuestion).length
        return qs === 0 || qs === options.length ? options : options.map(stripQuestion)
    }
    if (!isQuestion(prompt)) return options.map(stripQuestion)
    return options.map(o => {
        const base = stripQuestion(o)
        return spanishOptions ? `¿${base}?` : `${base}?`
    })
}

/**
 * Ejercicio de opción múltiple de la base: lo completa a 4 opciones con vocabulario del mismo idioma que sus
 * opciones (lengua o español) y pone los signos de pregunta según la burbuja (matchQuestions). La correcta se conserva.
 */
export function completeChoices(ex, vocab, rnd = Math.random) {
    if (ex?.type === 'word-bank') return cleanTiles(ex)
    if (ex?.type !== 'multiple-choice' || !Array.isArray(ex.options)) return ex
    const correct = ex.options[ex.correctAnswer]
    if (correct === undefined) return ex
    let options = [...ex.options]
    const words = vocab.map(v => v.word)
    const natives = vocab.map(v => translationsOf(v.translation)[0])
    const has = list => options.filter(o => list.some(w => normalize(w) === normalize(o))).length
    const spanish = has(natives) > has(words) // ¿las opciones están en español o en la lengua?
    if (options.length < OPTIONS) {
        const source = spanish ? natives : words
        const extra = pickDistractors(correct, [...options.filter(o => o !== correct), ...source], OPTIONS - 1, rnd)
            .filter(o => !options.some(x => normalize(x) === normalize(o)))
        options = shuffle([...options, ...extra].slice(0, OPTIONS), rnd)
    }
    options = matchQuestions(options, ex.answer, spanish)
    const key = normalize(correct)
    return { ...ex, options, correctAnswer: options.findIndex(o => normalize(o) === key) }
}

/** Fichas de un ejercicio de la base: fuera las de distracción con paréntesis sueltos ("(de", "ella)"). */
function cleanTiles(ex) {
    if (!Array.isArray(ex.tiles)) return ex
    const answer = new Set((ex.accepted || []).flatMap(a => tokenize(a)).map(t => t.toLocaleLowerCase('es')))
    const tiles = ex.tiles.filter(t => answer.has(String(t).toLocaleLowerCase('es')) || !/[()]/.test(t))
    return tiles.length === ex.tiles.length ? ex : { ...ex, tiles }
}

// ── generadores de ejercicios ─────────────────────────────────────────────────

/** Palabra nueva: la frase en la lengua; se arma la traducción al español con fichas. */
function introExercise(v, all, ctx) {
    const [main, ...alts] = translationsOf(v.translation)
    const answer = tokenize(main).map(t => t.toLocaleLowerCase('es'))
    const others = all.filter(o => o !== v).flatMap(o => translationsOf(o.translation))
    return {
        type: 'word-bank',
        generated: true,
        badge: BADGE.NEW,
        question: 'Traduce esta frase',
        answer: v.word,                       // se muestra en la burbuja (con pista al tocarla)
        tiles: shuffle([...answer, ...distractorTiles(answer, others, LIMITS.distractors, ctx.rnd)
            .map(t => t.toLocaleLowerCase('es'))], ctx.rnd),
        accepted: [main, ...alts],
        explanation: `${v.word}: ${v.translation}`,
        character: pickCharacter(ctx.authored, ctx.rnd),
        vocabWord: v.word,
    }
}

/** Opción múltiple generada. direction 'to-target': español → lengua; 'to-native': lengua → español. */
function choiceExercise(v, all, ctx, direction, badge) {
    const toTarget = direction === 'to-target'
    const label = x => toTarget ? x.word : translationsOf(x.translation)[0]
    const correct = label(v)
    const candidates = [...all, ...ctx.extra].map(label)
    const others = pickDistractors(correct, candidates, OPTIONS - 1, ctx.rnd)
    if (others.length < OPTIONS - 1) return null // sin 4 opciones distintas no se muestra
    const prompt = toTarget ? translationsOf(v.translation)[0] : v.word
    const options = matchQuestions(shuffle([correct, ...others], ctx.rnd), prompt, !toTarget)
    return {
        type: 'multiple-choice',
        generated: true,
        badge,
        question: toTarget ? 'Selecciona la traducción correcta' : '¿Qué significa?',
        answer: prompt,
        options,
        correctAnswer: options.findIndex(o => normalize(o) === normalize(correct)),
        explanation: `${v.word}: ${v.translation}`,
        character: pickCharacter(ctx.authored, ctx.rnd),
        vocabWord: v.word,
    }
}

/** Armar la frase en la lengua: el español en la burbuja, fichas con las palabras en la lengua. */
function buildExercise(v, all, ctx) {
    const answer = tokenize(v.word)
    const others = all.filter(o => o !== v).map(o => o.word)
    return {
        type: 'word-bank',
        generated: true,
        badge: null,
        question: `Arma la frase en ${ctx.languageName}`,
        answer: translationsOf(v.translation)[0],
        tiles: shuffle([...answer, ...distractorTiles(answer, others, LIMITS.distractors, ctx.rnd)], ctx.rnd),
        accepted: [v.word],
        explanation: `${v.word}: ${v.translation}`,
        character: pickCharacter(ctx.authored, ctx.rnd),
        vocabWord: v.word,
        targetLanguage: true,
    }
}

// ── plan ──────────────────────────────────────────────────────────────────────

/**
 * @param {object}   p
 * @param {object[]} p.exercises    ejercicios de la unidad (de la base)
 * @param {object}   p.vocabulary   vocabulario de la unidad (objeto { palabra: {...} } o arreglo)
 * @param {object[]} [p.review]     vocabulario de unidades anteriores (para repasar)
 * @param {object[]} [p.extra]      vocabulario de otras unidades (solo para completar opciones a 4)
 * @param {string}   [p.languageName]
 * @param {function} [p.rnd]        aleatorio (para pruebas)
 * @returns {object[]} ejercicios en orden
 */
export function buildLessonPlan({ exercises = [], vocabulary, review = [], extra = [], languageName = 'la lengua', rnd = Math.random }) {
    const reviewList = vocabList(review)
    const allVocab = vocabList([...vocabList(vocabulary), ...reviewList, ...vocabList(extra)])
    // Los de la base también salen con 4 opciones y signos uniformes
    const authored = exercises.map(e => ({ ...completeChoices(e, allVocab, rnd), generated: false }))
    const reviewKeys = new Set(reviewList.map(v => normalize(v.word)))
    // Nuevas = las de la unidad que no se vieron en unidades anteriores
    const unitList = vocabList(vocabulary)
    const fresh = unitList.filter(v => !reviewKeys.has(normalize(v.word)))
    if (!unitList.length) return authored

    const ctx = { authored, rnd, languageName, extra: vocabList(extra) }
    const pool = [...unitList, ...reviewList] // para opciones y fichas de distracción

    // Primero las de una sola idea (más cortas), luego las frases
    const byLength = [...fresh].sort((a, b) => tokenize(a.word).length - tokenize(b.word).length)
    const intros = byLength.slice(0, LIMITS.intros)

    const plan = []
    // 1–2. Presentar cada palabra y reconocer la anterior un par de pasos después (repetición espaciada)
    intros.forEach((v, i) => {
        plan.push(introExercise(v, pool, ctx))
        if (i > 0 && i - 1 < LIMITS.recognize) {
            const ex = choiceExercise(intros[i - 1], pool, ctx, 'to-target', null)
            if (ex) plan.push(ex)
        }
    })
    if (intros.length && intros.length - 1 < LIMITS.recognize) {
        const ex = choiceExercise(intros[intros.length - 1], pool, ctx, 'to-target', null)
        if (ex) plan.push(ex)
    }

    // 3–4. Ejercicios de la unidad intercalados con repaso de unidades anteriores
    const reviews = shuffle(reviewList, rnd).slice(0, LIMITS.reviews)
        .map((v, i) => choiceExercise(v, pool, ctx, i % 2 ? 'to-target' : 'to-native', BADGE.REVIEW))
        .filter(Boolean)
    const middle = shuffle(authored, rnd)
    reviews.forEach((ex, i) => {
        const at = Math.min(middle.length, Math.floor(((i + 1) * middle.length) / (reviews.length + 1)) + i)
        middle.splice(at, 0, ex)
    })
    plan.push(...middle)

    // 5. Selecciona los pares con lo ya visto (presentadas + repaso; si no alcanza, el resto de la unidad)
    const seen = intros.length + reviewList.length >= 4 ? [...intros, ...reviewList] : [...unitList, ...reviewList]
    const pairs = matchExercise(vocabList(seen), rnd)
    if (pairs) plan.push(pairs)

    // 6. Armar frases de varias palabras (las de la unidad primero)
    const phrases = [...unitList].filter(v => tokenize(v.word).length > 1)
    shuffle(phrases, rnd).slice(0, LIMITS.builds).forEach(v => plan.push(buildExercise(v, pool, ctx)))

    return plan.map((ex, i) => ({ ...ex, planIndex: i }))
}

/**
 * "Selecciona los pares": náhuatl a la izquierda, español a la derecha, las dos columnas revueltas.
 * Solo palabras ya vistas y sin parejas que se confundan (misma traducción, o una contenida en otra:
 * "Kwalli" / "Kwalli ninemi"). Sin 4 parejas posibles no sale.
 */
export function matchExercise(seen, rnd = Math.random) {
    const has = (a, b) => (' ' + a + ' ').includes(' ' + b + ' ') || (' ' + b + ' ').includes(' ' + a + ' ')
    const picked = []
    for (const v of shuffle(seen, rnd)) {
        const meanings = translationsOf(v.translation)
        if (!meanings.length) continue
        const w = normalize(v.word)
        const ms = meanings.map(normalize)
        const clash = picked.some(p => has(p.w, w) || p.ms.some(a => ms.some(b => has(a, b))))
        if (clash || !w) continue
        picked.push({ word: v.word, meaning: meanings[0], w, ms })
        if (picked.length === LIMITS.pairs) break
    }
    if (picked.length < 4) return null
    const idx = picked.map((_, i) => i)
    return {
        type: 'match',
        generated: true,
        question: 'Selecciona los pares',
        pairs: picked.map(({ word, meaning }) => ({ word, meaning })),
        left: shuffle(idx, rnd),
        right: shuffle(idx, rnd),
    }
}

/** Copia de un ejercicio fallado para repetirlo al final ("Error anterior"). */
export function mistakeRetry(ex, rnd = Math.random) {
    const copy = { ...ex, badge: BADGE.MISTAKE, isRetry: true }
    if (ex.type === 'word-bank' && Array.isArray(ex.tiles)) copy.tiles = shuffle(ex.tiles, rnd)
    if (ex.type === 'match' && Array.isArray(ex.pairs)) {
        copy.left = shuffle(ex.left, rnd)
        copy.right = shuffle(ex.right, rnd)
    }
    if (ex.type === 'multiple-choice' && Array.isArray(ex.options)) {
        const correct = ex.options[ex.correctAnswer]
        copy.options = shuffle(ex.options, rnd)
        copy.correctAnswer = copy.options.indexOf(correct)
    }
    return copy
}

/** ¿Las fichas elegidas forman una respuesta aceptada? */
export function checkWordBank(selectedTiles, accepted) {
    const got = normalize(selectedTiles.join(' '))
    return (accepted || []).some(a => normalize(a) === got)
}
