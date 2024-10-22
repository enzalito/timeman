<script setup lang="ts">
import { ref, computed, watch } from "vue"
import { useUserStore } from "@/stores/user"
import { getWorkingTimes } from "@/api/workingTime"
import { getCurrentWeekRange, formatDateTime } from "@/lib/utils"
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
import DatePicker from "@/components/DatePicker.vue";

const userStore = useUserStore()

const dateRange = ref(getCurrentWeekRange())

type DatedWorkHours = {
  date: string
  hours: number
}
// TODO: pass props (resourceType : user|team, id: number)
// en fonction du type récupérer et aggréger les working time correctement
// => faire deux fonctions, getChartDataUser et getChartDataTeam,
// qui seront appélées dans watch

const datedWorkHours = ref<DatedWorkHours[]>([])

watch(dateRange, async (newRange) => {  

  // FIXME: use real user id
  const { data: workingTimes } = await getWorkingTimes(1, formatDateTime(newRange.start), formatDateTime(newRange.end),
  );

  const workHoursByDate = new Map<number, number>()
 
  for (let workingTime of workingTimes) {
    const start = new Date(workingTime.start);
    const end = new Date(workingTime.end);

    const dateEpochMs = new Date(start).setHours(0, 0, 0, 0);

    const workDuration = end.getTime() - start.getTime(); 
    const workHours = workDuration / (1000 * 60 * 60);

    if (workHoursByDate.has(dateEpochMs)) {
      const existingHours = workHoursByDate.get(dateEpochMs) || 0;
      workHoursByDate.set(dateEpochMs, existingHours + workHours);
    } else {
      workHoursByDate.set(dateEpochMs, workHours);
    }
  }

  const datedWorkHoursTmp: DatedWorkHours[] = []

  for (let [dateEpochMs, hours] of workHoursByDate) {
    datedWorkHoursTmp.push({ date: new Date(dateEpochMs).toLocaleDateString(), hours })
  }

  datedWorkHours.value = datedWorkHoursTmp  
},
{ immediate: true })

const displayModes = ["bar", "line", "area"] as const
type DisplayModes = (typeof displayModes)[number]

const displayMode = ref<DisplayModes>("bar")
const setDisplayMode = (mode: string) => {
  displayMode.value = mode as DisplayModes
}

const chartComponent = computed(() => {
  switch (displayMode.value) {
    case "bar":
      return BarChart;
    case "line":
      return LineChart;
    case "area":
      return AreaChart;
    default:
      return null;
  }
});


</script>

<template>

  <div class="flex justify-between w-[85vw] max-w-[750px] min-w-[460px] py-2">
    <div class="text-left ">
      <DatePicker v-model="dateRange"/>
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
    <component :is="chartComponent" 
      :data="datedWorkHours"
      :colors="['hsl(var(--primary))']"
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
