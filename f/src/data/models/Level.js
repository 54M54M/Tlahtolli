export class Level {
    constructor(data = {}) {
        this.id = data.id || 1;
        this.language = data.language || "nhce";
        this.title = data.title || "";
        this.titleSpanish = data.titleSpanish || "";
        this.titleNative = data.titleNative || "";
        this.description = data.description || "";
        this.color = data.color || "#58CC02";
        this.units = data.units || 6;
        this.completedUnits = data.completedUnits || 0;
        this.locked = data.locked !== undefined ? data.locked : true;
        this.unlockRequirement = data.unlockRequirement || "";
        this.order = data.order || 0;
        this.estimatedHours = data.estimatedHours || 10;
    }

    get progress() {
        return (this.completedUnits / this.units) * 100;
    }

    isUnlocked(completedPreviousLevel = false, unitsCompleted = 0) {
        if (this.id === 1) return true;
        return completedPreviousLevel && unitsCompleted >= this.unlockRequirement;
    }

    completeUnit() {
        if (this.completedUnits < this.units) {
            this.completedUnits++;
            return true;
        }
        return false;
    }

    isCompleted() {
        return this.completedUnits >= this.units;
    }
}