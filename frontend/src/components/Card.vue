<script setup lang="ts">
import { type HTMLAttributes } from "vue"
import { cn } from "@/lib/utils"
import Card from "@/components/ui/card/Card.vue"

const props = defineProps<{ class?: HTMLAttributes['class'] }>()
</script>

<template>
  <Card
    :class="cn('border-0 shadow-none p-0 bg-transparent md:bg-white md:border md:p-4 md:drop-shadow-sm', props.class)">
    <slot />
  </Card>
</template>
