<script setup lang="ts">
import { ref, computed, watchEffect } from "vue"
import {
  today,
  startOfWeek,
  endOfWeek,
  getLocalTimeZone,
  CalendarDate
} from "@internationalized/date"
import { getWorkingTimes, type WorkingTime } from "@/api/working-time"
import { getUser, type User } from '@/api/user';
import { getTeam } from "@/api/team"
import { type DateRange } from "@/lib/utils"
import { useUserStore } from "@/stores/user"

import { BarChart } from "@/components/ui/chart-bar"
import { LineChart } from "@/components/ui/chart-line"
import { AreaChart } from "@/components/ui/chart-area"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@/components/ui/select"
import Card from "@/components/Card.vue"
import DatePicker from "@/components/datepicker/DateRangePicker.vue"
import CustomTooltip from "@/components/charts/working-time/WorkingTimeTooltip.vue"

const { userId, teamId } = defineProps<{ userId?: number, teamId?: number }>()

const userStore = useUserStore()

type DatedWorkHours = {
  dateEpochMs: number
  [hours: string]: number
}

const datedWorkHours = ref<DatedWorkHours[]>([])
const dateRange = ref<{ start: CalendarDate; end: CalendarDate }>({
  start: startOfWeek(today(getLocalTimeZone()), "fr-FR"),
  end: endOfWeek(today(getLocalTimeZone()), "fr-FR")
})

const chartCategories = ref<string[]>([])
const workingTimesByUsername = ref(new Map<string, WorkingTime[]>())

const getUserChartKey = (username: string): string => {
  return `${username} hours`
}

watchEffect(async () => {
  if (teamId) {
    const team = (await getTeam(teamId, { withUsers: true, withWorkingTimes: true })).data

    const tmpCats: string[] = []
    const tmpWork = new Map<string, WorkingTime[]>()
    for (let user of team.users) {
      tmpCats.push(getUserChartKey(user.username))
      tmpWork.set(user.username, user.workingTimes)
    }

    chartCategories.value = tmpCats
    workingTimesByUsername.value = tmpWork
  }
  else if (userId) {
    let user: User
    if (userStore.user && userId === userStore.user.id) {
      user = userStore.user
    } else {
      user = (await getUser(userId)).data
    }

    chartCategories.value = [getUserChartKey(user.username)]
    const res = await getWorkingTimes(user.id)
    workingTimesByUsername.value = new Map<string, WorkingTime[]>([[user.username, res.data]])
  }
})

watchEffect(async () => {
  const datedWorkHoursByDate = new Map<number, DatedWorkHours>()
  for (let [username, workingTimes] of workingTimesByUsername.value) {
    const userWorkHoursByDate = new Map<number, number>()
    for (let workingTime of workingTimes ?? []) {
      const start = new Date(workingTime.start)
      const end = new Date(workingTime.end)

      const dateEpochMs = new Date(start).setHours(0, 0, 0, 0)

      const workDuration = end.getTime() - start.getTime()
      const workHours = workDuration / (1000 * 60 * 60)

      if (userWorkHoursByDate.has(dateEpochMs)) {
        const existingHours = userWorkHoursByDate.get(dateEpochMs) || 0
        userWorkHoursByDate.set(dateEpochMs, existingHours + workHours)
      } else {
        userWorkHoursByDate.set(dateEpochMs, workHours)
      }
    }

    for (
      let date = dateRange.value.start;
      date.compare(dateRange.value.end) <= 0;
      date = date.add({ days: 1 })
    ) {
      const dateEpochMs = date.toDate(getLocalTimeZone()).getTime()
      const hours = userWorkHoursByDate.get(dateEpochMs) ?? 0
      const datedHours = datedWorkHoursByDate.get(dateEpochMs)
      if (datedHours) {
        datedWorkHoursByDate.set(dateEpochMs, { [getUserChartKey(username)]: hours, ...datedHours })
        continue
      }
      datedWorkHoursByDate.set(dateEpochMs, { [getUserChartKey(username)]: hours, dateEpochMs })
    }
  }

  datedWorkHours.value = Array.from(datedWorkHoursByDate, ([_, val]) => val)
})

const displayModes = ["bar", "line", "area"] as const
type DisplayModes = (typeof displayModes)[number]

const displayMode = ref<DisplayModes>("bar")
const setDisplayMode = (mode: string) => {
  displayMode.value = mode as DisplayModes
}

const chartComponent = computed(() => {
  switch (displayMode.value) {
    case "bar":
      return BarChart
    case "line":
      return LineChart
    case "area":
      return AreaChart
    default:
      return null
  }
})
</script>

<template>
  <div class="flex justify-between w-[85vw] max-w-[750px] min-w-[460px] py-2">
    <div class="text-left">
      <DatePicker v-model="dateRange as DateRange" />
    </div>
    <div>
      <Select :model-value="displayMode" @update:model-value="setDisplayMode">
        <SelectTrigger class="w-[180px]">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          <SelectGroup>
            <SelectItem value="bar">Bar</SelectItem>
            <SelectItem value="line">Line</SelectItem>
            <SelectItem value="area">Area</SelectItem>
          </SelectGroup>
        </SelectContent>
      </Select>
    </div>
  </div>

  <Card class="p-4 w-[85vw] max-w-[750px] min-w-[460px]">
    <component v-if="datedWorkHours.length !== 0" :is="chartComponent" :data="datedWorkHours" index="dateEpochMs"
      :categories="chartCategories" :colors="[0, 1, 2, 3, 4, 5].map((n) => `var(--vis-color${n})`)"
      :custom-tooltip="CustomTooltip" />
  </Card>
</template>
