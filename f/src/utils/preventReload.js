// utils/preventReload.js
export const preventReload = {
    mounted() {
        this.setupPreventReload();
    },

    methods: {
        setupPreventReload() {
            // Prevenir el menú contextual (clic derecho)
            document.addEventListener('contextmenu', this.handleContextMenu);

            // Prevenir atajos de teclado para recargar
            document.addEventListener('keydown', this.handleKeyDown);

            // Prevenir el gesto de pull-to-refresh en móviles
            document.addEventListener('touchmove', this.handleTouchMove, { passive: false });
            document.addEventListener('touchstart', this.handleTouchStart, { passive: false });

            // Prevenir el evento beforeunload con un mensaje personalizado
            window.addEventListener('beforeunload', this.handleBeforeUnload);

            // Prevenir el gesto de refresh con dos dedos en iOS
            document.addEventListener('gesturestart', this.handleGesture);
            document.addEventListener('gesturechange', this.handleGesture);
            document.addEventListener('gestureend', this.handleGesture);
        },

        handleContextMenu(e) {
            e.preventDefault();
            this.showReloadWarning();
            return false;
        },

        handleKeyDown(e) {
            // Prevenir F5, Ctrl+R, Cmd+R, Ctrl+Shift+R, Cmd+Shift+R
            if (
                e.key === 'F5' ||
                (e.ctrlKey && e.key === 'r') ||
                (e.metaKey && e.key === 'r') ||
                (e.ctrlKey && e.shiftKey && e.key === 'r') ||
                (e.metaKey && e.shiftKey && e.key === 'r')
            ) {
                e.preventDefault();
                this.showReloadWarning();
                return false;
            }
        },

        handleTouchStart(e) {
            this.startY = e.touches[0].pageY;
        },

        handleTouchMove(e) {
            // Prevenir pull-to-refresh
            const currentY = e.touches[0].pageY;

            if (currentY - this.startY > 100 && window.scrollY <= 0) {
                e.preventDefault();
                this.showReloadWarning();
                return false;
            }
        },

        handleGesture(e) {
            e.preventDefault();
            this.showReloadWarning();
            return false;
        },

        handleBeforeUnload(e) {
            const message = '⚠️ ¿Estás seguro de que quieres salir? Se perderá tu progreso actual.';
            e.returnValue = message;
            return message;
        },

        showReloadWarning() {
            // Mostrar un toast o mensaje personalizado
            // this.showCustomWarning('La recarga está deshabilitada para preservar tu progreso.');
        },

        showCustomWarning(message) {
            // Crear o mostrar un componente de advertencia
            const existingWarning = document.getElementById('reload-warning');
            if (existingWarning) {
                existingWarning.remove();
            }

            const warning = document.createElement('div');
            warning.id = 'reload-warning';
            warning.innerHTML = `
            <div style="
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                background: #ff4444;
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                z-index: 10000;
                font-family: system-ui;
                font-size: 14px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                animation: slideDown 0.3s ease-out;">
                ${message}
            </div>`;

            // Agregar estilos de animación
            const style = document.createElement('style');
            style.textContent = `
            @keyframes slideDown {
                from { transform: translateX(-50%) translateY(-100%); opacity: 0; }
                to { transform: translateX(-50%) translateY(0); opacity: 1; }
            }`;
            document.head.appendChild(style);

            document.body.appendChild(warning);

            // Remover después de 3 segundos
            setTimeout(() => {
                if (warning.parentNode) {
                    warning.parentNode.removeChild(warning);
                }
            }, 3000);
        },

        beforeDestroy() {
            // Limpiar event listeners cuando el componente se destruya
            document.removeEventListener('contextmenu', this.handleContextMenu);
            document.removeEventListener('keydown', this.handleKeyDown);
            document.removeEventListener('touchmove', this.handleTouchMove);
            document.removeEventListener('touchstart', this.handleTouchStart);
            document.removeEventListener('gesturestart', this.handleGesture);
            document.removeEventListener('gesturechange', this.handleGesture);
            document.removeEventListener('gestureend', this.handleGesture);
            window.removeEventListener('beforeunload', this.handleBeforeUnload);
        }
    }
};