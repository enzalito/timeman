<script setup lang="ts">
import { onBeforeMount, ref } from "vue"
import { type WorkingTime } from "@/api/workingTime"
import type { UserWithWorkingTimes } from "@/api/user"
import { getTeam } from "@/api/team"
import { getCurrentWeekRangeStr } from "@/lib/utils"

import Card from "@/components/Card.vue"

const { teamId } = defineProps<{ teamId: number }>()

const users = ref<(UserWithWorkingTimes & { workedHours: number })[]>([])

onBeforeMount(async () => {
  const team = await getTeam(teamId, { withUsers: true, withWorkingTimes: true })
  users.value = gatherHours(team.data.users)
  console.log(users.value)
})

function calculateTotalHours<Data extends { start: string; end: string }>(data: Data[]) {
  let totalHours = 0

  // Loop through each event and calculate the hours for each
  data.forEach((row) => {
    const startDate = new Date(row.start)
    const endDate = new Date(row.end)

    // Calculate the difference in milliseconds and convert to hours
    const diffInMs = endDate.getTime() - startDate.getTime()
    const diffInHours = diffInMs / (1000 * 60 * 60) // Convert milliseconds to hours

    totalHours += diffInHours
  })

  return totalHours
}

function filterWorkingTimes(workingTimes: WorkingTime[] | undefined, start: string, end: string) {
  if (!workingTimes) {
    return []
  }

  const rangeStartDate = new Date(start)
  const rangeEndDate = new Date(end)

  // Filter the events array
  return workingTimes.filter((wt) => {
    const workingTimeStartDate = new Date(wt.start)
    const workingTimeEndDate = new Date(wt.end)

    // Check if the workingTime overlaps with the range
    if (workingTimeStartDate < rangeStartDate && workingTimeStartDate > rangeStartDate) {
      wt.start = rangeStartDate.toDateString()
      return true
    }

    return workingTimeEndDate >= rangeStartDate && workingTimeStartDate <= rangeEndDate
  })
}

function gatherHours(users: UserWithWorkingTimes[]) {
  const { start, end } = getCurrentWeekRangeStr()
  const usersWorkingTimes = users.map((user) => {
    const weekWorkingTimes = filterWorkingTimes(user.workingTimes, start, end)
    const totalHours = calculateTotalHours(weekWorkingTimes)
    return { workedHours: totalHours, ...user }
  })

  return usersWorkingTimes
}

function getPercentageWorked(hours: number) {
  const percengtage = (hours / 35) * 100
  const numberValue = parseFloat(String(percengtage)).toFixed(2)
  return `width: ${numberValue}%`
}
</script>

<template>
  <Card
    title="Week summary"
    class="gap-x-6 items-center justify-between w-full md:w-[66%] lg:w-[50%] xl:[40%] max-w-[580px]"
  >
    <div
      v-for="user in users"
      :key="user.id"
      class="py-4 px-4 w-full border-b last:border-0 border-slate-200 justify-between grid grid-cols-4 gap-x-3"
    >
      <div class="col-span-1">{{ user.username }}</div>
      <div class="flex gap-2 items-center col-span-2">
        <div class="bar h-4 rounded-full w-48 bg-blue-50 relative">
          <div
            :class="['progress bg-blue-900 left-0 top-0 bottom-0 absolute rounded-full']"
            :style="getPercentageWorked(user.workedHours)"
          ></div>
        </div>
      </div>
      <p class="col-span-1">
        {{ user.workedHours }}/<span class="text-xs text-gray-500">35hrs</span>
      </p>
    </div>
  </Card>
</template>
