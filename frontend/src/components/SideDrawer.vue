<script setup lang="ts">
import { type HTMLAttributes } from "vue";
import { cn } from "@/lib/utils"

const { isOpen, ...props } = defineProps<{ isOpen: boolean; class?: HTMLAttributes['class'] }>()
</script>

<template>
  <div :class="cn(
    'h-full w-[100vw] bg-white p-4 absolute right-0 top-0 bottom-0 transition-all translate-x-full z-50',
    isOpen === true && 'translate-x-0',
    props.class,
  )
    ">
    <slot />
  </div>
</template>
