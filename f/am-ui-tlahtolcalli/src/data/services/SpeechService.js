/* 

BUG - EN MOBILE EL TTS EN ALGUNAS PALABRAS PRONUNCIA LETRA POR LETRA EN LUGAR DE SILABA POR SILABA, LO CUAL SI SE HACE EN DESK

*/

export class SpeechService {
    static getDefaultVoice() {
        const voices = speechSynthesis.getVoices();

        // Priorizar voces en español de México
        const preferredVoices = [
            'Google español de México', // Desktop Windows
            'Google español de México', // Chrome general
            'Español mexicano', // Varios navegadores
            'es-MX', // Cualquier voz con este locale
            'es-US', // Fallback a español US
            'es-ES'  // Fallback a español España
        ];

        // Buscar voces preferidas
        for (const voiceName of preferredVoices) {
            const voice = voices.find(v =>
                v.name.includes(voiceName) ||
                v.lang.includes(voiceName) ||
                v.name.toLowerCase().includes('mexican') ||
                v.name.toLowerCase().includes('mexico')
            );
            if (voice) return voice;
        }

        // Si no encuentra voces preferidas, buscar cualquier voz en español
        const spanishVoice = voices.find(v => v.lang.startsWith('es-'));
        if (spanishVoice) return spanishVoice;

        // Si no hay voces en español, usar la primera disponible
        return voices[0] || null;
    }

    static getMobileOptimizedSettings() {
        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

        if (isMobile) {
            return {
                rate: 0.8,      // Más lento en mobile
                pitch: 1.0,     // Tono normal
                volume: 0.8,    // Volumen ligeramente más bajo
                lang: 'es-MX'   // Forzar español mexicano
            };
        }

        return {
            rate: 0.9,
            pitch: 1.0,
            volume: 0.7,
            lang: 'es-MX'
        };
    }

    static speakWord(word, language = 'es-MX', voiceName = null, volume = null, pronunciation = null) {
        if ('speechSynthesis' in window) {
            // Cancelar cualquier speech en curso
            speechSynthesis.cancel();

            // Usar la pronunciación específica si está disponible
            const textToSpeak = pronunciation || word;

            const utterance = new SpeechSynthesisUtterance(textToSpeak);

            // Obtener configuración optimizada para el dispositivo
            const settings = this.getMobileOptimizedSettings();

            utterance.lang = settings.lang;
            utterance.rate = settings.rate;
            utterance.pitch = settings.pitch;
            utterance.volume = volume !== null ? volume : settings.volume;

            // Seleccionar voz automáticamente si no se especifica
            let voiceToUse = null;
            if (voiceName) {
                const voices = speechSynthesis.getVoices();
                voiceToUse = voices.find(voice =>
                    voice.name === voiceName || voice.lang === voiceName
                );
            }

            // Si no se encontró voz específica, usar la voz por defecto
            if (!voiceToUse) {
                voiceToUse = this.getDefaultVoice();
            }

            if (voiceToUse) {
                utterance.voice = voiceToUse;
            }

            // Para mobile, agregar pequeña pausa antes de hablar
            if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                setTimeout(() => {
                    speechSynthesis.speak(utterance);
                }, 100);
            } else {
                speechSynthesis.speak(utterance);
            }

            return true;
        }
        return false;
    }

    static speakText(text, language = 'es-MX', voiceName = null, volume = null, pronunciation = null) {
        return this.speakWord(text, language, voiceName, volume, pronunciation);
    }

    // Método específico para palabras con pronunciación - optimizado para mobile
    static speakVocabularyItem(vocabularyItem, language = 'es-MX') {
        if (!vocabularyItem) return false;

        // En mobile, usar la palabra en lugar de la pronunciación si es muy larga
        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
        let textToSpeak;

        if (isMobile && vocabularyItem.pronunciation && vocabularyItem.pronunciation.length > 20) {
            textToSpeak = vocabularyItem.word; // Usar palabra original en mobile para textos largos
        } else {
            textToSpeak = vocabularyItem.pronunciation || vocabularyItem.word;
        }

        return this.speakWord(textToSpeak, language, null, null);
    }

    // Método mejorado para hablar opciones de ejercicios
    static speakExerciseOption(option, vocabularyList = []) {
        if (!option) return false;

        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

        // Buscar si la opción coincide con alguna palabra del vocabulario
        const matchingVocabulary = vocabularyList.find(item =>
            item.word === option || item.translation === option
        );

        let textToSpeak = option;

        // En mobile, ser más conservador con la pronunciación
        if (matchingVocabulary) {
            if (isMobile) {
                // En mobile, preferir la palabra original para evitar deletreo
                textToSpeak = matchingVocabulary.word;
            } else if (matchingVocabulary.pronunciation) {
                // En desktop, usar pronunciación si está disponible
                textToSpeak = matchingVocabulary.pronunciation;
            }
        }

        // Configuración específica para mobile
        const settings = this.getMobileOptimizedSettings();
        if (isMobile) {
            settings.rate = 0.75; // Aún más lento para opciones individuales
        }

        return this.speakWord(textToSpeak, settings.lang, null, settings.volume);
    }

    static isSupported() {
        return 'speechSynthesis' in window;
    }

    // Obtener lista de voces disponibles
    static getVoices() {
        return speechSynthesis.getVoices();
    }

    // Obtener voces filtradas por idioma
    static getVoicesByLang(language) {
        const voices = speechSynthesis.getVoices();
        return voices.filter(voice => voice.lang.startsWith(language));
    }

    // Esperar a que las voces estén cargadas
    static async waitForVoices() {
        return new Promise((resolve) => {
            const voices = speechSynthesis.getVoices();
            if (voices.length) {
                resolve(voices);
            } else {
                speechSynthesis.addEventListener('voiceschanged', () => {
                    resolve(speechSynthesis.getVoices());
                });
            }
        });
    }

    // Nuevo método: Verificar compatibilidad del TTS
    static async checkTTSCompatibility() {
        if (!this.isSupported()) {
            return { supported: false, message: 'TTS no soportado en este navegador' };
        }

        await this.waitForVoices();
        const voices = this.getVoices();
        const spanishVoices = this.getVoicesByLang('es');

        return {
            supported: true,
            voices: voices.length,
            spanishVoices: spanishVoices.length,
            defaultVoice: this.getDefaultVoice()?.name || 'No disponible',
            isMobile: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
        };
    }
}