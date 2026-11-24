<template>
    <div class="flex items-center gap-4 mb-6">
        <div class="relative shrink-0">
            <UserAvatar :name="user.username" :size="80" />
            <Badge
                class="absolute -bottom-1 -right-1 bg-turquesa-deep text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center">
                {{ user.level }}
            </Badge>
        </div>
        <div class="flex-1 min-w-0">
            <h2 class="text-xl font-bold truncate">{{ user.name }}</h2>
            <p class="text-gray-400 text-sm truncate">@{{ user.username }}</p>

            <!-- Racha: días seguidos con al menos una lección (en cualquier idioma).
                 Color del fuego según los días: gris, normal, rojo (50+), morado (200+), azul (500+) -->
            <p class="mt-1 text-sm flex items-center gap-1" :class="streakTier(user.streak).text">
                <StreakFlame :days="user.streak || 0" size="1.1em" />
                <span v-if="user.streak > 0">
                    {{ user.streak }} {{ user.streak === 1 ? 'día' : 'días' }}
                </span>
                <span v-else>Haz una lección hoy para empezar tu racha</span>
            </p>

            <!-- Nivel y experiencia: los calcula el back (UserLevelService, XP por nivel tomada de los ejercicios) -->
            <div class="mt-2">
                <div class="flex justify-between text-xs text-gray-400 mb-1">
                    <span>Nivel {{ user.level }}</span>
                    <span>{{ user.xpInLevel }}/{{ user.xpToNextLevel }} XP</span>
                </div>
                <div class="h-1.5 w-full bg-gray-700 rounded-full overflow-hidden" role="progressbar"
                    :aria-valuenow="user.xpInLevel" aria-valuemin="0" :aria-valuemax="user.xpToNextLevel"
                    :aria-label="`Nivel ${user.level}: ${user.xpInLevel} de ${user.xpToNextLevel} XP`">
                    <div class="h-full rounded-full bg-turquesa transition-all duration-500"
                        :style="{ width: `${progress}%` }"></div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import Badge from './Badge.vue';
import UserAvatar from './UserAvatar.vue';
import StreakFlame from './StreakFlame.vue';
import { streakTier } from '../data/streak.js';

const props = defineProps({
    user: {
        type: Object,
        required: true
    }
});

const progress = computed(() => {
    const total = props.user.xpToNextLevel || 1;
    return Math.min(100, Math.round(((props.user.xpInLevel || 0) / total) * 100));
});
</script>
