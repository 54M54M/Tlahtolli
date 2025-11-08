import { User } from '../models/User.js';
import { SUPPORTED_LANGUAGES } from '../config/LanguageConfig.js';
import { LocalStorageService } from '../storage/LocalStorageService.js';

export class UserRepository {
    constructor() {
        this.users = new Map();
        this.loadInitialData();
    }

    loadInitialData() {
        // Intentar cargar desde LocalStorage primero
        const savedUser = LocalStorageService.getUserData();

        if (savedUser && savedUser.id) {
            this.users.set(1, new User(savedUser));
            return;
        }

        // Si no hay datos guardados, crear usuario demo
        const demoUser = new User({
            id: 1,
            name: "UserDemo",
            username: "tetecuhtli",
            level: 1,
            xp: 0,
            xpToNextLevel: 1000,
            streak: 0,
            totalXP: 0,
            minutesStudied: 0,
            joinDate: new Date(),
            profileImage: "/placeholder.svg",
            currentLanguage: "nhce",
            learningGoals: {},
            unlockedLanguages: ["nhce", "tkoc"],
        });

        this.users.set(1, demoUser);
        LocalStorageService.saveUserData(demoUser);
    }

    getUser(userId = 1) {
        // Siempre cargar desde localStorage primero
        const savedUser = LocalStorageService.getUserData();

        if (savedUser && savedUser.id) {
            // Si hay datos guardados, actualizar la instancia en memoria
            const currentUser = this.users.get(userId);
            if (currentUser) {
                // Asegurar que joinDate esté formateado correctamente
                if (savedUser.joinDate && !savedUser.joinDate.includes('/')) {
                    // Si la fecha guardada no está en formato aaaa/mm/dd, formatearla
                    const tempUser = new User(savedUser);
                    savedUser.joinDate = tempUser.joinDate;
                }

                Object.assign(currentUser, savedUser);
            } else {
                // Crear nueva instancia si no existe
                this.users.set(userId, new User(savedUser));
            }
        }

        const user = this.users.get(userId);

        // Guardar automáticamente cuando se accede al usuario
        if (user) {
            LocalStorageService.saveUserData(user);
        }

        return user;
    }

    updateUser(userId, updates) {
        const user = this.getUser(userId);
        if (user) {
            Object.assign(user, updates);
            LocalStorageService.saveUserData(user);
            return true;
        }
        return false;
    }

    addXP(userId, amount) {
        // console.log('💰 UserRepository.addXP - INICIANDO:', { userId, amount });
        const user = this.getUser(userId);

        if (user) {
            // console.log('💰 ANTES - XP:', user.xp, 'Total XP:', user.totalXP, 'Nivel:', user.level);
            user.addXP(amount);
            // console.log('💰 DESPUÉS - XP:', user.xp, 'Total XP:', user.totalXP, 'Nivel:', user.level);

            LocalStorageService.saveUserData(user);
            // console.log('💰 DATOS GUARDADOS EN LOCALSTORAGE');

            return user.xp;
        }
        // console.log('💰 ERROR: Usuario no encontrado');
        return 0;
    }

    updateStreak(userId) {
        const user = this.getUser(userId);
        if (user) {
            user.updateStreak();
            return user.streak;
        }
        return 0;
    }

    getFreshUser(userId = 1) {
        // Limpiar cache y cargar desde localStorage
        this.users.clear();
        this.loadInitialData();
        return this.getUser(userId);
    }

    switchLanguage(userId, languageCode) {
        const user = this.getUser(userId);
        if (user && SUPPORTED_LANGUAGES[languageCode.toUpperCase()]) {
            return user.switchLanguage(languageCode);
        }
        return false;
    }

    unlockLanguage(userId, languageCode) {
        const user = this.getUser(userId);
        if (user && SUPPORTED_LANGUAGES[languageCode.toUpperCase()]) {
            return user.unlockLanguage(languageCode);
        }
        return false;
    }

    getAvailableLanguages(userId) {
        const user = this.getUser(userId);
        if (!user) return [];

        return Object.values(SUPPORTED_LANGUAGES).filter(lang =>
            user.unlockedLanguages.includes(lang.code)
        );
    }

    getLearningGoals(userId) {
        const user = this.getUser(userId);
        return user?.learningGoals || {};
    }

    setLearningGoal(userId, languageCode, goal) {
        const user = this.getUser(userId);
        if (user) {
            user.learningGoals[languageCode] = goal;
            return true;
        }
        return false;
    }

    // Método para reparar el formato de joinDate en datos existentes
    fixJoinDateFormat(userId = 1) {
        const user = this.getUser(userId);
        if (user && user.joinDate) {
            // Si joinDate no está en formato aaaa/mm/dd, formatearlo
            if (!user.joinDate.includes('/')) {
                const tempUser = new User({ joinDate: user.joinDate });
                user.joinDate = tempUser.joinDate;
                LocalStorageService.saveUserData(user);
                console.log('✅ Formato de joinDate reparado:', user.joinDate);
            }
        }
    }

    // MÉTODO TEMPORAL
    fixXP = () => {
        // console.log('🔧 Reparando XP...');

        // Obtener usuario actual
        const user = userRepo.getUser(1);
        // console.log('🔧 XP antes:', user.xp);

        // Si tiene logros desbloqueados pero XP es 0, agregar la XP manualmente
        const unlockedAchievementsCount = allAchievements.value.filter(a => a.earned).length;
        if (unlockedAchievementsCount > 0 && user.xp === 0) {
            // console.log('🔧 Agregando XP de logros desbloqueados...');

            // Calcular XP total de logros desbloqueados
            let totalXPReward = 0;
            allAchievements.value.forEach(achievement => {
                if (achievement.earned) {
                    totalXPReward += achievement.xpReward;
                    // console.log(`🔧 Logro: ${achievement.title} - ${achievement.xpReward} XP`);
                }
            });

            // console.log(`🔧 XP total a agregar: ${totalXPReward}`);
            userRepo.addXP(1, totalXPReward);

            // Recargar datos
            loadUserData();
            // console.log('🔧 XP después:', userData.value?.xp);
        } else {
            console.log('🔧 No se necesita reparación de XP');
        }
    };
}