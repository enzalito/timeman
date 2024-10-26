<script setup lang="ts">
import { computed, onBeforeMount, ref } from "vue"
import { today, getLocalTimeZone } from "@internationalized/date"
import { getWorkingTimes } from "@/api/workingTime"
import { getWeekRangeStr, getWeekRange, getFilteredTotalHours } from "@/lib/utils"

import { ArrowRight } from "lucide-vue-next"
import { DonutChart } from "@/components/ui/chart-donut"
import Card from "@/components/Card.vue"
import WeekSummaryTooltip from "@/components/charts/week-summary/WeekSummaryTooltip.vue"

const { userId } = defineProps<{ userId: number }>()

const weeklyWorkingHours = 35

const data = ref([
  { name: "This week", total: 0 },
  { name: "Today", total: 0 },
  { name: "Remaining", total: 0 }
])

onBeforeMount(async () => {
  const todayDate = today(getLocalTimeZone())
  const { start, end } = getWeekRangeStr(todayDate)
  const weekWorkingTimes = await getWorkingTimes(userId, start, end)

  const hoursToday = getFilteredTotalHours(weekWorkingTimes.data, {
    start: todayDate,
    end: todayDate.add({ days: 1 })
  })
  const hoursThisWeek = getFilteredTotalHours(weekWorkingTimes.data, getWeekRange(todayDate))

  data.value[1].total = hoursToday
  data.value[0].total = hoursThisWeek - hoursToday
  data.value[2].total = weeklyWorkingHours - hoursThisWeek
})

const centerLabel = computed(
  () =>
    `${Math.round(data.value[0].total * 10) / 10 + Math.round(data.value[1].total * 10) / 10}/${weeklyWorkingHours}h`
)

const todayDate = today(getLocalTimeZone())
const { start: weekStartDate, end: weekEndDate } = getWeekRange(todayDate)
</script>

<template>
  <Card class="flex items-center justify-between w-fit gap-8">
    <div class="w-fit">
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded-sm bg-blue-500" />
        <p class="inline-block">Today - {{ todayDate }}</p>
      </div>
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded-sm bg-blue-900" />
        <p class="inline-block">
          This week - {{ weekStartDate }}
          <ArrowRight class="w-4 h-4 inline mb-1" />
          {{ weekEndDate }}
        </p>
      </div>
    </div>

    <DonutChart :centerLabel="centerLabel" index="name" :show-legend="true" :category="'total'" :data="data"
      :colors="['#1E3A8A', '#3B82F6', '#FBFBFB']" :custom-tooltip="WeekSummaryTooltip">
    </DonutChart>
  </Card>
</template>
