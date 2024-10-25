<script setup lang="ts">
import { cn } from "@/lib/utils"
import Card from "@/components/ui/card/Card.vue"

const { title, class: className } = defineProps<{ title?: string; class?: string }>()
</script>

<template>
  <h3 v-if="title" class="text-xl mb-6 mt-8 font-medium">{{ title }}</h3>
  <Card
    :class="
      cn(
        'border-0 shadow-none p-0 bg-transparent md:bg-white md:border-slate-200 md:border-[1px] md:p-4 md:drop-shadow-sm',
        className
      )
    "
  >
    <slot />
  </Card>
</template>
