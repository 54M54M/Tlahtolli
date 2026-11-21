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

defineProps({
    user: {
        type: Object,
        required: true
    }
});
</script>