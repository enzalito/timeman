<script setup lang="ts">
import { ref, computed, onBeforeMount } from "vue"

import { Card } from "@/components/ui/card"
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

import { getWorkingTimes, type WorkingTime } from "@/api/workingTime"
import { useUserStore } from "@/stores/user"

type DatedWorkHours = {
  date: string
  hours: number
}

const userStore = useUserStore()

const datedWorkHours = ref<DatedWorkHours[]>([])
onBeforeMount(async () => {
  const { data: workingTimes }= await getWorkingTimes(userStore.user!.id)

  const workHoursByDate = new Map<number, number>()
  for (let workingTime of workingTimes) {
    const start = new Date(workingTime.start)
    const end = new Date(workingTime.end)
    const dateEpochMs = new Date(start).setHours(0, 0, 0, 0)
    const workHours = (end.getTime() - start.getTime()) / 3600000
    workHoursByDate.set(dateEpochMs, workHours)
  }

  const datedWorkHoursTmp: DatedWorkHours[] = []
  for (let [dateEpochMs, hours] of workHoursByDate) {
    datedWorkHoursTmp.push({ date: new Date(dateEpochMs).toLocaleDateString(), hours })
  }
  datedWorkHours.value = datedWorkHoursTmp
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
  }
})
</script>

<template>
  <Card class="w-[750px] p-4">
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
    <component :is="chartComponent" 
      :data="datedWorkHours"
      :colors="['MediumAquaMarine']"
      index="date"
      :categories="['hours']"
      :y-formatter="
        (tick, i) => {
          return typeof tick === 'number'
            ? `$ ${new Intl.NumberFormat('us').format(tick).toString()}`
            : ''
        }
      "
    />
  </Card>
</template>
