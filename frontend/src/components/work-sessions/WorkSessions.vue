<script setup lang="ts">
import { ref, watchEffect } from "vue"
import {
  today,
  getLocalTimeZone,
  type CalendarDate,
} from "@internationalized/date"
import { getWorkingTimes, type WorkingTime } from "@/api/working-time"
import { formatDate, filterWorkingHours, type DateRange } from "@/lib/utils"

import { Moon } from "lucide-vue-next"
import { Card } from "@/components/ui/card"
import { Separator } from "@/components/ui/separator"
import ResponsiveCard from "@/components/Card.vue"
import WorkSessionCard from "@/components/work-sessions/WorkSessionCard.vue"
import DatePicker from "@/components/datepicker/DatePicker.vue"

const { userId } = defineProps<{ userId: number }>()

type WorkingTimesByPeriod = { day: WorkingTime[], night: WorkingTime[] }

const sortedWorkingTimes = ref<[WorkingTimesByPeriod, WorkingTimesByPeriod]>([
  { day: [], night: [] },
  { day: [], night: [] },
])
const date = ref(today(getLocalTimeZone()))

watchEffect(async () => {
  const start = formatDate(date.value.copy())
  const end = formatDate(date.value.add({ days: 2 }))
  const workingTimes = (await getWorkingTimes(userId, start, end)).data

  sortedWorkingTimes.value[0] = getFilteredWorkingTimes(
    workingTimes,
    { start: date.value.copy(), end: date.value.add({ days: 1 }) }
  )
  sortedWorkingTimes.value[1] = getFilteredWorkingTimes(
    workingTimes,
    { start: date.value.add({ days: 1 }), end: date.value.add({ days: 2 }) }
  )
})

const getFilteredWorkingTimes = (
  workingTimes: WorkingTime[] | undefined,
  range: DateRange
): WorkingTimesByPeriod => {
  const ret: WorkingTimesByPeriod = { day: [], night: [] }
  filterWorkingHours(workingTimes, range, (workingTime, _) => {
    switch (workingTime.period) {
      case "day":
        ret.day.push(workingTime)
        break;
      case "night":
        ret.night.push(workingTime)
        break;
    }
  })

  return ret
}</script>

<template>
  <div>
    <DatePicker v-model="date as CalendarDate" class="mb-2" />
    <ResponsiveCard class="flex flex-row gap-8 items-stretch">
      <div v-for="(workingTimes, i) in sortedWorkingTimes" :key="i" class="grow basis-0 flex flex-col gap-2">
        <h3 class="font-medium">{{ date.add({ days: i }).toDate(getLocalTimeZone()).toDateString() }}</h3>
        <p v-if="workingTimes.day.length === 0 && workingTimes.night.length === 0" class="text-sm">
          No work session this day
        </p>
        <WorkSessionCard v-for="workingTime in workingTimes.day" :key="workingTime.id" :working-time="workingTime" />
        <div v-if="workingTimes.day.length !== 0 && workingTimes.night.length !== 0" class="flex items-center">
          <Moon class="h-5 w-5 mr-2 stroke-gray-300 shrink-0" />
          <Separator class="bg-transparent border-t-2 border-dashed border-gray-300 shrink" />
        </div>
        <WorkSessionCard v-for="workingTime in workingTimes.night" :key="workingTime.id" :working-time="workingTime"
          class="bg-black text-gray-100" />
      </div>
    </ResponsiveCard>
  </div>
</template>
