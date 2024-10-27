<script setup lang="ts">
import { type WorkingTime } from "@/api/working-time"

import { Clock, ArrowRight, SquarePen } from "lucide-vue-next"
import { Card } from "@/components/ui/card"

const { workingTime } = defineProps<{ workingTime: WorkingTime }>()
</script>

<template>
  <Card class="p-2">
    <div class="flex flex-col gap-1 text-sm">
      <div class="flex flex-row items-center font-medium">
        <Clock class="h-3 stroke-[3]" />
        {{ workingTime.start.substring(11, 16) }}
        <ArrowRight class="h-3 stroke-[3]" />
        {{ workingTime.end.substring(11, 16) }}
      </div>
      <div v-if="workingTime.description && workingTime.description !== ''" class="flex flex-row items-center">
        <SquarePen class="h-3" />
        {{ workingTime.description }}
      </div>
    </div>
  </Card>
</template>
