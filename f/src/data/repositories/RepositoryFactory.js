import { LearningRepository } from './LearningRepository.js'
import { StatsRepository } from './StatsRepository.js'
import { SyllabaryRepository } from './SyllabaryRepository.js'

class RepositoryFactory {
    constructor() { this.instances = {} }

    getLearningRepository() {
        if (!this.instances.learningRepo) this.instances.learningRepo = new LearningRepository()
        return this.instances.learningRepo
    }
    getStatsRepository() {
        if (!this.instances.statsRepo) this.instances.statsRepo = new StatsRepository()
        return this.instances.statsRepo
    }
    getSyllabaryRepository() {
        if (!this.instances.syllabaryRepo) this.instances.syllabaryRepo = new SyllabaryRepository()
        return this.instances.syllabaryRepo
    }
    reset() { this.instances = {} }
}

export const repositoryFactory = new RepositoryFactory()
export const getLearningRepository = () => repositoryFactory.getLearningRepository()
export const getStatsRepository = () => repositoryFactory.getStatsRepository()
export const getSyllabaryRepository = () => repositoryFactory.getSyllabaryRepository()
