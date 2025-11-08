export class Region {
    constructor(data = {}) {
        this.id = data.id || "";
        this.language = data.language || "nhce";
        this.name = data.name || "";
        this.description = data.description || "";
        this.communities = data.communities || [];
        this.position = data.position || { top: "50%", left: "50%" };
        this.color = data.color || "#58CC02";
        this.speakers = data.speakers || "0";
        this.documentation = data.documentation || "Baja";
        this.features = data.features || "";
        this.words = data.words || [];
    }

    addWord(spanish, native, example = "") {
        this.words.push({
            spanish,
            native,
            example
        });
    }

    getDialectInfo() {
        return {
            id: this.id,
            name: this.name,
            color: this.color,
            documentation: this.documentation,
            regions: this.communities.join(", "),
            speakers: this.speakers,
            features: this.features
        };
    }
}