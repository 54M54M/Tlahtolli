<template>
    <span class="inline-flex items-center px-2 py-0.5 rounded-full text-sm font-medium text-white">
        <slot></slot> <!-- Permite pasar contenido dinámico -->
    </span>
</template>

<script>
export default {
    name: 'Badge'
}
</script>