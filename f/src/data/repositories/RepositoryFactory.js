import { DictionaryRepository } from './DictionaryRepository.js';
import { LearningRepository } from './LearningRepository.js';
import { StatsRepository } from './StatsRepository.js';
import { SyllabaryRepository } from './SyllabaryRepository.js';
import { UserRepository } from './UserRepository.js';

/**
 * Factory para crear singletons de repositorios
 * Esto evita crear múltiples instancias innecesarias
 */
class RepositoryFactory {
    constructor() {
        this.instances = {};
    }

    getUserRepository() {
        if (!this.instances.userRepo) {
            this.instances.userRepo = new UserRepository();
        }
        return this.instances.userRepo;
    }

    getLearningRepository() {
        if (!this.instances.learningRepo) {
            this.instances.learningRepo = new LearningRepository();
        }
        return this.instances.learningRepo;
    }

    getStatsRepository() {
        if (!this.instances.statsRepo) {
            this.instances.statsRepo = new StatsRepository();
        }
        return this.instances.statsRepo;
    }

    getDictionaryRepository() {
        if (!this.instances.dictionaryRepo) {
            this.instances.dictionaryRepo = new DictionaryRepository();
        }
        return this.instances.dictionaryRepo;
    }

    getSyllabaryRepository() {
        if (!this.instances.syllabaryRepo) {
            this.instances.syllabaryRepo = new SyllabaryRepository();
        }
        return this.instances.syllabaryRepo;
    }

    // Método para limpiar instancias (útil para testing o reset)
    reset() {
        this.instances = {};
    }
}

// Exportar una única instancia
export const repositoryFactory = new RepositoryFactory();

// Exports convenientes
export const getUserRepository = () => repositoryFactory.getUserRepository();
export const getLearningRepository = () => repositoryFactory.getLearningRepository();
export const getStatsRepository = () => repositoryFactory.getStatsRepository();
export const getDictionaryRepository = () => repositoryFactory.getDictionaryRepository();
export const getSyllabaryRepository = () => repositoryFactory.getSyllabaryRepository();