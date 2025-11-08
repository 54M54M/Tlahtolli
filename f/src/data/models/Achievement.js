// En Achievement.js - Actualiza el constructor
export class Achievement {
    constructor(data = {}) {
        this.id = data.id || 1;
        this.title = data.title || "";
        this.description = data.description || "";
        this.icon = data.icon || "🏆";
        this.earned = data.earned || false;
        this.date = data.date || null;
        this.xpReward = data.xpReward || 100;
        this.requirement = data.requirement || "";
        this.category = data.category || "general";
        this.rarity = data.rarity || "common";
        this.languageSpecific = data.languageSpecific || false;
        this.language = data.language || null;
        this.progress = data.progress || { current: 0, target: 1, percentage: 0 };
    }

    earn() {
        if (!this.earned) {
            this.earned = true;
            this.date = new Date().toISOString();
            return this.xpReward;
        }
        return 0;
    }

    getRarityColor() {
        const colors = {
            "common": "#58CC02",
            "rare": "#1CB0F6",
            "epic": "#A560E8",
            "legendary": "#FF4B4B"
        };
        return colors[this.rarity] || "#58CC02";
    }
}