<script setup lang="ts">
import type { FunctionalComponent } from "vue"
import { Button } from "@/components/ui/button"

const {
  icon,
  text,
  link,
  mode = "desktop"
} = defineProps<{
  icon: FunctionalComponent
  text: string
  link: string
  mode?: "desktop" | "mobile"
}>()
</script>

<template>
  <router-link :to="link" class="w-full relative" v-slot="{ isActive }">
    <div
      v-if="isActive && mode === 'desktop'"
      class="w-1 bg-blue-900 rounded-md absolute left-2 top-2 bottom-2"
    />
    <div
      v-if="isActive && mode === 'mobile'"
      class="h-1 bg-blue-900 rounded-md absolute left-2 right-2 bottom-1"
    />
    <Button
      variant="ghost"
      :class="[
        'w-full justify-start flex gap-4 ',
        mode === 'mobile' ? 'flex-col gap-2 text-sm h-full' : ''
      ]"
    >
      <icon class="h-5 w-5" />
      <p class="text-xs font-medium">{{ text }}</p>
    </Button>
  </router-link>
</template>
