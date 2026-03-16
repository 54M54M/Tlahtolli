// src/data/repositories/RepositoryFactory.js
import { LearningRepository } from './LearningRepository.js'
import { StatsRepository } from './StatsRepository.js'
import { SyllabaryRepository } from './SyllabaryRepository.js'
// DictionaryRepository y UserRepository se importan desde sus originales
// Solo se usan en GlossaryView (diccionario) y ProfileView (datos de usuario).
// Si dan error al compilar, comentar estas dos líneas y las funciones correspondientes.
import { DictionaryRepository } from './DictionaryRepository.js'
import { UserRepository } from './UserRepository.js'

class RepositoryFactory {
    constructor() { this.instances = {} }

    getUserRepository() {
        if (!this.instances.userRepo) this.instances.userRepo = new UserRepository()
        return this.instances.userRepo
    }
    getLearningRepository() {
        if (!this.instances.learningRepo) this.instances.learningRepo = new LearningRepository()
        return this.instances.learningRepo
    }
    getStatsRepository() {
        if (!this.instances.statsRepo) this.instances.statsRepo = new StatsRepository()
        return this.instances.statsRepo
    }
    getDictionaryRepository() {
        if (!this.instances.dictionaryRepo) this.instances.dictionaryRepo = new DictionaryRepository()
        return this.instances.dictionaryRepo
    }
    getSyllabaryRepository() {
        if (!this.instances.syllabaryRepo) this.instances.syllabaryRepo = new SyllabaryRepository()
        return this.instances.syllabaryRepo
    }
    reset() { this.instances = {} }
}

export const repositoryFactory = new RepositoryFactory()
export const getUserRepository = () => repositoryFactory.getUserRepository()
export const getLearningRepository = () => repositoryFactory.getLearningRepository()
export const getStatsRepository = () => repositoryFactory.getStatsRepository()
export const getDictionaryRepository = () => repositoryFactory.getDictionaryRepository()
export const getSyllabaryRepository = () => repositoryFactory.getSyllabaryRepository()