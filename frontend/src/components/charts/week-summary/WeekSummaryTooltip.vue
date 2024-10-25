<script setup lang="ts">
import { formatHours } from "@/lib/utils"

const { data } = defineProps<{
  title?: string
  data: {
    name: string
    color: string
    value: any
  }[]
}>()
</script>

<template>
  <div class="p-1">
    <div v-for="row in data" :key="row.name" class="flex items-center gap-4">
      <div
        :class="['trait w-1 h-6 rounded-sm', `bg-[${row.color}]`]"
        :style="{ backgroundColor: row.color }"
      />
      {{ row.name }}
      <div class="">{{ formatHours(row.value) }}m</div>
    </div>
  </div>
</template>
