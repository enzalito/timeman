<script setup lang="ts">
import Card from './ui/card/Card.vue';

const {title, class: className} = defineProps<{title?: string, class?: string}>()
</script>

<template>
  <h3 v-if="title" :class="['text-xl mb-6 mt-8 font-medium', className]">{{ title }}</h3>
  <Card class="border-slate-200 p-4 drop-shadow-sm">
    <slot/>
  </Card>
</template>
