<template>
    <div class="flex items-center gap-4 mb-6">
        <div class="relative">
            <UserAvatar :name="user.username" :size="80" />
            <Badge
                class="absolute -bottom-1 -right-1 bg-turquesa-deep text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center">
                {{ user.level }}
            </Badge>
        </div>
        <div class="flex-1">
            <h2 class="text-xl font-bold">{{ user.name }}</h2>
            <p class="text-gray-400 text-sm">@{{ user.username }}</p>
            <!-- Racha: días seguidos con al menos una lección (en cualquier idioma) -->
            <p class="mt-1 text-sm flex items-center gap-1" :class="streakTier(user.streak).text">
                <!-- Color del fuego según los días: gris, normal, rojo (50+), morado (200+), azul (500+) -->
                <StreakFlame :days="user.streak || 0" size="1.1em" />
                <span v-if="user.streak > 0">
                    {{ user.streak }} {{ user.streak === 1 ? 'día' : 'días' }}
                </span>
                <span v-else>Haz una lección hoy para empezar tu racha</span>
            </p>
            <div class="mt-1">
                <div class="flex justify-between text-xs text-gray-400 mb-1">
                    <span>Nivel {{ user.level }}</span>
                    <!-- <span>
                        {{ user.xp }}/{{ user.xpToNextLevel }} XP
                    </span> -->
                </div>
                <!--
                <ProgressBar :current="user.xp" :total="user.xpToNextLevel" class="h-1.5 bg-gray-700" /> -->

                <!--
                        
                xpToNextLevel = puntos undividuales de Exercise({ points:... }) * numero de  Exercise({..}) de una unidad

                15 puntos * 36 ejercicios = 540 xpToNextLevel
                
                -->

            </div>
        </div>
    </div>
</template>

<script setup>
import Badge from './Badge.vue';
import ProgressBar from './ProgressBar.vue';
import UserAvatar from './UserAvatar.vue';
import StreakFlame from './StreakFlame.vue';
import { streakTier } from '../data/streak.js';

defineProps({
    user: {
        type: Object,
        required: true
    }
});
</script>