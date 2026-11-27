// Reportar un problema: datos del ejercicio que acompañan al reporte (ReportModal.vue).

const text = v => (v == null ? '' : String(v))
const list = v => (Array.isArray(v) ? v.map(text).filter(Boolean).join(' / ') : text(v))

/**
 * Resume el ejercicio y lo que respondió la persona.
 * @param ex       ejercicio actual (lessonPlan.js o de la BD)
 * @param answer   { selected, text, bankSel } según el tipo de ejercicio
 */
export function exerciseReport(ex = {}, { selected = null, text: typed = '', bankSel = [] } = {}) {
    const options = Array.isArray(ex.options) ? ex.options.map(text) : []
    let userAnswer = ''
    let correctAnswer = ''
    if (ex.type === 'multiple-choice') {
        userAnswer = selected != null ? text(options[selected]) : ''
        correctAnswer = text(options[ex.correctAnswer])
    } else if (ex.type === 'fill-blank') {
        userAnswer = text(typed)
        correctAnswer = list(ex.correctAnswer)
    } else if (ex.type === 'word-bank') {
        const tiles = ex.tiles || []
        userAnswer = bankSel.map(i => tiles[i]).join(' ')
        correctAnswer = list(ex.accepted)
    }
    return {
        exerciseId: ex.id ?? null,
        exerciseType: text(ex.type),
        question: text(ex.question),
        prompt: text(ex.answer || ex.vocabWord),
        options,
        userAnswer,
        correctAnswer,
    }
}

/** Motivos que se pueden marcar; dependen de si la respuesta se tomó como correcta. */
export function reportReasons(isCorrect) {
    return [
        isCorrect
            ? { id: 'no-debio-aceptarse', label: 'Mi respuesta no debió ser aceptada' }
            : { id: 'debio-aceptarse', label: 'Mi respuesta debió ser aceptada' },
        { id: 'traduccion', label: 'La traducción o la respuesta correcta tiene un error' },
        { id: 'pista', label: 'La pronunciación o el desglose de una palabra está mal' },
        { id: 'imagen', label: 'Una imagen no se ve bien o no aparece' },
        { id: 'otro', label: 'Algo más salió mal' },
    ]
}
