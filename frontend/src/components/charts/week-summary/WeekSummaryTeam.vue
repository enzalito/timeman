<script setup lang="ts">
import { onBeforeMount, ref } from "vue"
import { getLocalTimeZone } from "@internationalized/date"
import type { UserWithWorkingTimes } from "@/api/user"
import { getTeam } from "@/api/team"
import { type WorkingTime } from "@/api/workingTime"
import { getWeekRange, filterWorkingHours, type DateRange, type TimeRange } from "@/lib/utils"

import Card from "@/components/Card.vue"

const { teamId } = defineProps<{ teamId: number }>()

const users = ref<(UserWithWorkingTimes & { workedHours: number })[]>([])

onBeforeMount(async () => {
  const team = await getTeam(teamId, { withUsers: true, withWorkingTimes: true })
  users.value = gatherHours(team.data.users)
})

function getFilteredTotalHours(workingTimes: WorkingTime[] | undefined, range: DateRange): number {
  const getHourDuration = (timeRange: TimeRange) => {
    return (
      (timeRange.end.toDate(getLocalTimeZone()).getTime() -
        timeRange.start.toDate(getLocalTimeZone()).getTime()) /
      3600000
    )
  }

  let total = 0
  filterWorkingHours(workingTimes, range, (_, timeRange) => {
    total += getHourDuration(timeRange)
  })

  return total
}

function gatherHours(users: UserWithWorkingTimes[]) {
  const weekRange = getWeekRange()
  const usersWorkingTimes = users.map((user) => {
    const totalHours = getFilteredTotalHours(user.workingTimes, weekRange)
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
