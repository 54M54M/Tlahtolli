<template>
    <div class="flex w-full bg-gray-800 rounded p-1 gap-1">
        <button v-for="tab in tabs" :key="tab.value"
            class="text-xs py-1.5 px-2 rounded transition-colors flex-1 text-center truncate min-w-0" :class="{
                'bg-gray-700 text-white': modelValue === tab.value,
                'text-gray-400 hover:text-gray-300': modelValue !== tab.value
            }" @click="$emit('update:modelValue', tab.value)">
            {{ tab.label }}
        </button>
    </div>
</template>

<script setup>
defineProps({
    tabs: {
        type: Array,
        required: true,
        validator: (value) => {
            return value.every(tab => tab.value && tab.label)
        }
    },
    modelValue: {
        type: String,
        required: true
    }
})

defineEmits(['update:modelValue'])
</script>