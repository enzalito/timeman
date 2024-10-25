<script setup lang="ts">
import { cn } from '@/lib/utils';




  const {isOpen, classes} = defineProps<{isOpen: boolean, classes?: string}>()
</script>


<template>
  <div :class="cn(`h-full w-[100vw] bg-white p-4 absolute right-0 top-0 bottom-0 transition-all translate-x-full ${classes} `, isOpen === true && 'translate-x-0')">
    <slot/>
  </div>
</template>
