/**
 * Salir de una lección o nivel rápido sin dejarlo en el historial.
 * Con push el historial quedaba home → nivel → lección → nivel, y el gesto/botón de atrás del teléfono
 * volvía a abrir la lección ya terminada. Si se llegó desde la ruta destino, se regresa a esa entrada
 * (atrás → home); si no, se reemplaza la lección por el destino.
 */
export function leaveTo(router, path) {
    const back = window.history.state?.back;
    if (back && router.resolve(back).fullPath === router.resolve(path).fullPath) {
        router.back();
    } else {
        router.replace(path);
    }
}
