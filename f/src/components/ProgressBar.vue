<template>
    <div class="w-full">
        <div class="w-full bg-gray-300 h-2 rounded-full overflow-hidden">
            <div class="h-2 rounded-full transition-all duration-300" :style="{
                width: progressPercentage + '%',
                backgroundColor: color || '#58CC02'
            }">
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "ProgressBar",
    props: {
        current: {
            type: Number,
            required: true
        },
        total: {
            type: Number,
            required: true
        },
        color: {
            type: String,
            default: null
        }
    },
    computed: {
        progressPercentage() {
            return (this.current / this.total) * 100;
        }
    }
}
</script>

<style scoped>
/* Custom styles for ProgressBar if necessary */
</style>