<template>
    <div class="shadow-md rounded-lg p-4">
        <slot></slot> <!-- Permite pasar contenido dinámico, como título y texto -->
    </div>
</template>

<script>
export default {
    name: 'Card'
}
</script>

<style scoped>
/* Puedes agregar estilos adicionales aquí si es necesario */
</style>