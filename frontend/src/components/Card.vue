<script setup lang="ts">
import Card from './ui/card/Card.vue';

const {title, class: className} = defineProps<{title?: string, class?: string}>()
</script>

<template>
  <h3 v-if="title" class="text-xl mb-6 mt-8 font-medium">{{ title }}</h3>
  <Card :class="['border-0 shadow-none p-0 bg-transparent md:bg-white md:border-slate-200 md:p-4 md:drop-shadow-sm', className]">

    <slot/>
  </Card>
</template>
