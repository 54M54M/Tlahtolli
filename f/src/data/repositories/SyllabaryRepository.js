export class SyllabaryRepository {
    constructor() {
        this.syllabaries = new Map();
        this.writingSystems = new Map();
        this.writingSystemInfo = new Map();
        this.loadInitialData();
    }

    loadInitialData() {
        // ========== INFORMACIÓN DE SISTEMAS DE ESCRITURA ==========

        // Sistema SILABARIO para Náhuatl Central
        this.writingSystems.set('nhce', 'syllabary');
        this.writingSystemInfo.set('syllabary', {
            name: 'Silabario',
            description: 'Con base en la norma escritura según el INALI',
            notes: [
                'Algunas combinaciones [consonante - vocal] no existen o no se encuentran facilmente en el idioma',
                'La "U" como vocal independiente no existe en náhuatl',
                'Las vocales largas (ā, ē, ī, ō) son distintivas y cambian el significado',
                'La "U" se usa para representar una semiconsonante con sonido "w"',
                'La "H" tiene pronunciación según el contexto, es muda en diptongos (ua, ue, ui) y se pronuncia como "J" fuera de diptongos',
                'La "c" tiene dos sonidos: [k] antes de a, o, u y [s] antes de e, i',
                'La "z" representa el sonido [s] en todas las posiciones',
                'Los dígrafos representan fonemas unitarios (tl, tz, ch, qu, hu)',
                'El dígrafo "tl" representa un fonema africado lateral',
            ]
        });

        // Sistema ALFABETO para Teenek Occidental
        this.writingSystems.set('tkoc', 'alphabet');
        this.writingSystemInfo.set('alphabet', {
            name: 'Alfabéto',
            description: 'Con base en la norma escritura según el INALI',
            notes: [
                'Oclusión glotal representada con apostrofe (ʼ)',
                'Algunas consonantes tienen variantes glotalizadas',
                'Los sonidos eyectivos se marcan con apostrofe (kʼ, chʼ, tʼ)',
                'Los sonidos eyectivos cambian el significado',
                'La oclusión glotal es un fonema independiente',
            ]
        });

        // ========== DATOS ESPECÍFICOS DE CADA IDIOMA ==========        

        // SILABARIO Náhuatl Central
        this.writingSystems.set('nhce', 'syllabary');
        this.syllabaries.set('nhce', [
            // VOCALES BÁSICAS
            {
                type: 'vowel',
                vowel: {
                    a: 'a',
                    e: 'e',
                    i: 'i',
                    o: 'o',
                    u: null
                }
            },
            // CONSONANTES BÁSICAS
            {
                type: 'consonant',
                pronunciation: 'k, s',
                letter: 'c',
                syllables: {
                    a: 'ca (ka)',
                    e: 'ce (se)',
                    i: 'ci (si)',
                    o: 'co (ko)',
                    u: null
                }
            },
            {
                type: 'consonant',
                pronunciation: 'j',
                letter: 'h',
                syllables: {
                    a: 'ha (ja)',
                    e: 'he (je)',
                    i: null,
                    o: 'ho (jo)',
                    u: null
                }
            },
            {
                type: 'consonant',
                // pronunciation: 'l',
                letter: 'l',
                syllables: {
                    a: 'la',
                    e: 'le',
                    i: 'li',
                    o: 'lo',
                    u: null
                }
            },
            {
                type: 'consonant',
                // pronunciation: 'm',
                letter: 'm',
                syllables: {
                    a: 'ma',
                    e: 'me',
                    i: 'mi',
                    o: 'mo',
                    u: null
                }
            },
            {
                type: 'consonant',
                // pronunciation: 'n',
                letter: 'n',
                syllables: {
                    a: 'na',
                    e: 'ne',
                    i: 'ni',
                    o: 'no',
                    u: null
                }
            },
            {
                type: 'consonant',
                // pronunciation: 'p',
                letter: 'p',
                syllables: {
                    a: 'pa',
                    e: 'pe',
                    i: 'pi',
                    o: 'po',
                    u: null
                }
            },
            {
                type: 'consonant',
                // pronunciation: 't',
                letter: 't',
                syllables: {
                    a: 'ta',
                    e: 'te',
                    i: 'ti',
                    o: 'to',
                    u: null
                }
            },
            {
                type: 'consonant',
                pronunciation: 'sh',
                letter: 'x',
                syllables: {
                    a: 'xa (sha)',
                    e: 'xe (she)',
                    i: 'xi (shi)',
                    o: 'xo (sho)',
                    u: null
                }
            },
            {
                type: 'consonant',
                // pronunciation: 'y',
                letter: 'y',
                syllables: {
                    a: 'ya',
                    e: 'ye',
                    i: 'yi',
                    o: 'yo',
                    u: null
                }
            },
            {
                type: 'consonant',
                pronunciation: 's',
                letter: 'z',
                syllables: {
                    a: 'za (sa)',
                    e: 'ze (se)',
                    i: null,
                    o: 'zo (so)',
                    u: null
                }
            },
            // FONEMAS UNITARIOS - DÍGRAFOS
            {
                type: 'digraph',
                pronunciation: 'kw',
                letter: 'cu',
                syllables: {
                    a: 'cua (kwa)',
                    e: 'cue (kwe)',
                    i: 'cui (kwi)',
                    o: 'cuo (kwo)',
                    u: null
                }
            },
            {
                type: 'digraph',
                pronunciation: 'ch',
                letter: 'ch',
                syllables: {
                    a: 'cha',
                    e: 'che',
                    i: 'chi',
                    o: 'cho',
                    u: 'chu'
                }
            },
            {
                type: 'digraph',
                pronunciation: 'w',
                letter: 'hu',
                syllables: {
                    a: 'hua (wa)',
                    e: 'hue (we)',
                    i: 'hui (wi)',
                    o: null,
                    u: null
                }
            },
            {
                type: 'digraph',
                pronunciation: 'k',
                letter: 'qu',
                syllables: {
                    a: null,
                    e: 'que (ke)',
                    i: 'qui (ki)',
                    o: null,
                    u: null
                }
            },
            {
                type: 'digraph',
                pronunciation: 'tl',
                letter: 'tl',
                syllables: {
                    a: 'tla',
                    e: 'tle',
                    i: 'tli',
                    o: 'tlo',
                    u: null
                }
            },
            {
                type: 'digraph',
                pronunciation: 'ts',
                letter: 'tz',
                syllables: {
                    a: 'tza (tsa)',
                    e: 'tze (tse)',
                    i: 'tzi (tsi)',
                    o: 'tzo (tso)',
                    u: 'tzu (tsu)'
                }
            },
            // VOCALES LARGAS - MACRON
            {
                type: 'longVowel',
                letter: 'ā',
                // pronunciation: 'aa (vocal larga)',
                syllables: {
                    a: 'ā (aa)'
                }
            },
            {
                type: 'longVowel',
                letter: 'ē',
                // pronunciation: 'ee (vocal larga)',
                syllables: {
                    e: 'ē (ee)'
                }
            },
            {
                type: 'longVowel',
                letter: 'ī',
                // pronunciation: 'ii (vocal larga)',
                syllables: {
                    i: 'ī (ii)'
                }
            },
            {
                type: 'longVowel',
                letter: 'ō',
                // pronunciation: 'oo (vocal larga)',
                syllables: {
                    o: 'ō (oo)'
                }
            }
        ]);

        // ALFABETO Teenek Occidental
        this.writingSystems.set('tkoc', 'alphabet');
        this.syllabaries.set('tkoc', [
            // VOCALES BÁSICAS
            {
                type: 'vowel',
                letter: 'a',
                pronunciation: 'a'
            },
            {
                type: 'vowel',
                letter: 'e',
                pronunciation: 'e'
            },
            {
                type: 'vowel',
                letter: 'i',
                pronunciation: 'i'
            },
            {
                type: 'vowel',
                letter: 'o',
                pronunciation: 'o'
            },
            {
                type: 'vowel',
                letter: 'u',
                pronunciation: 'u'
            },
            // CONSONANTES
            {
                type: 'consonant',
                letter: 'b',
                pronunciation: 'b'
            },
            {
                type: 'consonant',
                letter: 'ch',
                pronunciation: 'ch'
            },
            {
                type: 'consonant',
                letter: 'dh',
                pronunciation: 'dh'
            },
            {
                type: 'consonant',
                letter: 'j',
                pronunciation: 'j'
            },
            {
                type: 'consonant',
                letter: 'k',
                pronunciation: 'k'
            },
            {
                type: 'consonant',
                letter: 'kw',
                pronunciation: 'kw'
            },
            {
                type: 'consonant',
                letter: 'l',
                pronunciation: 'l'
            },
            {
                type: 'consonant',
                letter: 'm',
                pronunciation: 'm'
            },
            {
                type: 'consonant',
                letter: 'n',
                pronunciation: 'n'
            },
            {
                type: 'consonant',
                letter: 'p',
                pronunciation: 'p'
            },
            {
                type: 'consonant',
                letter: 't',
                pronunciation: 't'
            },
            {
                type: 'consonant',
                letter: 'ts',
                pronunciation: 'ts'
            },
            {
                type: 'consonant',
                letter: 'tx',
                pronunciation: 'tx'
            },
            {
                type: 'consonant',
                letter: 'w',
                pronunciation: 'w'
            },
            {
                type: 'consonant',
                letter: 'x',
                pronunciation: 'x'
            },
            {
                type: 'consonant',
                letter: 'y',
                pronunciation: 'y'
            },

            // GRAFEMAS COMPUESTOS - SONIDOS EYECTIVOS
            {
                type: 'ejective',
                letter: 'bʼ',
                // pronunciation: 'bʼ',
                // notes: 'b glotalizada'
            },
            {
                type: 'ejective',
                letter: 'chʼ',
                // pronunciation: 'chʼ',
                // notes: 'ch glotalizada'
            },
            {
                type: 'ejective',
                letter: 'kʼ',
                // pronunciation: 'kʼ',
                // notes: 'k glotalizada'
            },
            {
                type: 'ejective',
                letter: 'kʼw',
                // pronunciation: 'kʼw',
                // notes: 'kw glotalizada'
            },
            {
                type: 'ejective',
                letter: 'tʼ',
                // pronunciation: 'tʼ',
                // notes: 't glotalizada'
            },
            {
                type: 'ejective',
                letter: 'tsʼ',
                // pronunciation: 'tsʼ',
                // notes: 'ts glotalizada'
            },
            {
                type: 'ejective',
                letter: 'ʼ',
                pronunciation: 'Oclusión',
                // notes: 'ts glotalizada'
            },
            // VOCALES LARGAS
            {
                type: 'longVowel',
                letter: 'ā',
                pronunciation: 'aa'
            },
            {
                type: 'longVowel',
                letter: 'ē',
                pronunciation: 'ee'
            },
            {
                type: 'longVowel',
                letter: 'ī',
                pronunciation: 'ii'
            },
            {
                type: 'longVowel',
                letter: 'ō',
                pronunciation: 'oo'
            },
            {
                type: 'longVowel',
                letter: 'ū',
                pronunciation: 'uu'
            }
        ]);
    }

    // ========== MÉTODOS PARA INFORMACIÓN DEL SISTEMA ==========

    getWritingSystemInfo(systemType) {
        return this.writingSystemInfo.get(systemType) || {
            name: 'Sistema Desconocido',
            description: 'Información no disponible',
            features: [],
            notes: []
        };
    }

    getCurrentWritingSystemInfo(language) {
        const systemType = this.getWritingSystem(language);
        return this.getWritingSystemInfo(systemType);
    }

    getWritingSystem(language) {
        return this.writingSystems.get(language) || 'alphabet';
    }

    getSyllabary(language) {
        return this.syllabaries.get(language) || [];
    }

    // Métodos específicos para sistemas silabarios
    getSyllablesByLetter(language, letter) {
        if (this.getWritingSystem(language) !== 'syllabary') return null;
        const syllabary = this.getSyllabary(language);
        return syllabary.find(entry => entry.letter === letter);
    }

    getVowels(language) {
        if (this.getWritingSystem(language) === 'syllabary') {
            const syllabary = this.getSyllabary(language);
            const vowelEntry = syllabary.find(entry => entry.vowel);
            return vowelEntry ? vowelEntry.vowel : null;
        } else {
            const alphabet = this.getSyllabary(language);
            return alphabet.filter(entry => entry.type === 'vowel');
        }
    }

    getConsonants(language) {
        const data = this.getSyllabary(language);
        if (this.getWritingSystem(language) === 'syllabary') {
            // Filtrar correctamente las consonantes básicas
            return data.filter(entry => entry.type === 'consonant');
        } else {
            return data.filter(entry => entry.type === 'consonant');
        }
    }

    getSpecialCharacters(language) {
        const data = this.getSyllabary(language);
        if (this.getWritingSystem(language) === 'syllabary') {
            return data.filter(entry => entry.type === 'digraph');
        } else {
            return data.filter(entry => entry.type === 'ejective');
        }
    }

    getLongVowels(language) {
        const data = this.getSyllabary(language);
        if (this.getWritingSystem(language) === 'syllabary') {
            // Para silabarios, devolver las vocales largas como objeto
            const longVowelEntries = data.filter(entry => entry.type === 'longVowel');
            if (longVowelEntries.length > 0) {
                const longVowels = {};
                longVowelEntries.forEach(entry => {
                    const vowel = entry.letter.charAt(0).toLowerCase(); // 'ā' -> 'a'
                    longVowels[vowel] = entry.letter;
                });
                return longVowels;
            }
            return null;
        } else {
            // Para alfabetos, devolver las vocales largas como array
            return data.filter(entry => entry.type === 'longVowel');
        }
    }

    // Método para obtener todas las letras de un alfabeto
    getAlphabet(language) {
        if (this.getWritingSystem(language) !== 'alphabet') return [];
        return this.getSyllabary(language);
    }

    // Método para agrupar por tipo (útil para alfabetos)
    getAlphabetByType(language) {
        const alphabet = this.getAlphabet(language);
        return {
            vowels: alphabet.filter(entry => entry.type === 'vowel'),
            consonants: alphabet.filter(entry => entry.type === 'consonant'),
            ejectives: alphabet.filter(entry => entry.type === 'ejective'),
            longVowels: alphabet.filter(entry => entry.type === 'longVowel')
        };
    }

    // Método para obtener todas las vocales largas (común para ambos sistemas)
    getAllLongVowels(language) {
        const data = this.getSyllabary(language);
        return data.filter(entry => entry.type === 'longVowel');
    }
}