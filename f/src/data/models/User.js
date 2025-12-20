export class User {
    constructor(data = {}) {
        this.id = data.id || 1;
        this.name = data.name || "";
        this.username = data.username || "";
        this.email = data.email || "";
        this.level = data.level || 1;
        this.xp = data.xp || 0;
        this.xpToNextLevel = data.xpToNextLevel || 1000;
        this.streak = data.streak || 0;
        this.totalXP = data.totalXP || 0;
        this.minutesStudied = data.minutesStudied || 0;
        
        // ✅ CORRECCIÓN: Formatear joinDate al formato aaaa/mm/dd
        this.joinDate = this.formatJoinDate(data.joinDate);
        
        this.profileImage = data.profileImage || "/placeholder.svg";
        this.currentLanguage = data.currentLanguage || "nhce";
        this.learningGoals = data.learningGoals || {};
        this.unlockedLanguages = data.unlockedLanguages || [];
    }

    // ✅ NUEVO: Método para formatear la fecha
    formatJoinDate(dateInput) {
        if (!dateInput) {
            // Si no hay fecha, usar fecha actual formateada
            return this.getCurrentFormattedDate();
        }
        
        // Si ya está en formato aaaa/mm/dd, devolver tal cual
        if (typeof dateInput === 'string' && /^\d{4}\/\d{2}\/\d{2}$/.test(dateInput)) {
            return dateInput;
        }
        
        // Convertir cualquier formato de fecha al formato deseado
        const date = new Date(dateInput);
        if (isNaN(date.getTime())) {
            // Si la fecha es inválida, usar fecha actual
            return this.getCurrentFormattedDate();
        }
        
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        
        return `${year}/${month}/${day}`;
    }

    // ✅ NUEVO: Método auxiliar para obtener fecha actual formateada
    getCurrentFormattedDate() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        return `${year}/${month}/${day}`;
    }

    // Resto de los métodos permanecen igual...
    addXP(amount) {
        // console.log('👤 User.addXP - Antes:', {
        //     xp: this.xp,
        //     xpToNextLevel: this.xpToNextLevel,
        //     level: this.level,
        //     amount
        // });

        this.xp += amount;
        this.totalXP += amount;

        while (this.xp >= this.xpToNextLevel) {
            this.xp -= this.xpToNextLevel;
            this.level++;
            this.xpToNextLevel = Math.floor(this.xpToNextLevel * 1.2);
            // console.log('👤 User.addXP - Subió de nivel:', {
            //     nuevoNivel: this.level,
            //     xpRestante: this.xp,
            //     nuevoXpToNextLevel: this.xpToNextLevel
            // });
        }

        // console.log('👤 User.addXP - Después:', {
        //     xp: this.xp,
        //     xpToNextLevel: this.xpToNextLevel,
        //     level: this.level
        // });
    }

    updateStreak() {
        this.streak++;
    }

    switchLanguage(languageCode) {
        if (this.unlockedLanguages.includes(languageCode)) {
            this.currentLanguage = languageCode;
            return true;
        }
        return false;
    }

    unlockLanguage(languageCode) {
        if (!this.unlockedLanguages.includes(languageCode)) {
            this.unlockedLanguages.push(languageCode);
            return true;
        }
        return false;
    }

    getCurrentLanguageInfo() {
        const languageMap = {
            'nhce': { name: 'Náhuatl Central', color: '#58CC02' },
            'tkoc': { name: 'Teenek Occidental', color: '#9C27B0' }
        };
        return languageMap[this.currentLanguage] || languageMap.nhce;
    }
}