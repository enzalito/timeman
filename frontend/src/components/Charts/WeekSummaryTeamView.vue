<script setup lang="ts">

import Card from '../Card.vue';
import { getCurrentWeekRange } from '@/lib/utils';
import { getWorkingTimes } from '@/api/workingTime';
import { onMounted } from 'vue';
import type { UserResponse } from '@/api/user';

function calculateTotalHours<Data extends {start: string, end: string}>(data: Data[]) {
    let totalHours = 0;

    // Loop through each event and calculate the hours for each
    data.forEach(row => {
        const startDate = new Date(row.start);
        const endDate = new Date(row.end);

        // Calculate the difference in milliseconds and convert to hours
        const diffInMs = endDate.getTime() - startDate.getTime();
        const diffInHours = diffInMs / (1000 * 60 * 60); // Convert milliseconds to hours

        totalHours += diffInHours;
    });

    return totalHours;
}


const {teamUsers} = defineProps<{teamUsers: {users: UserResponse}[]}>()


const {start, end} = getCurrentWeekRange()

async function fetchHours() {
  const usersWorkingTimes = await Promise.all(teamUsers.map(async ({id: userId}) => {
      const weekWorkingTimes = await getWorkingTimes(userId, start, end)

      const totalHours = calculateTotalHours(weekWorkingTimes.data)

      return {userId, workedHours: totalHours}
  }))

  return usersWorkingTimes
}

let data;
onMounted(async () => {
  data = await fetchHours()
})

const mockData = [
  {name: 'Louis', workedHours: 28.6},
  {name: 'Fred', workedHours: 24.2},
  {name: 'Alex', workedHours: 12.690},

]

function getPercentageWorked(hours: number)  {
  const percengtage = (hours/35) * 100

  const numberValue = parseFloat(String(percengtage)).toFixed(2);

  return `width: ${numberValue}%`;
}

</script>

<template>
  <Card title="Week summary" class="gap-x-6 items-center justify-between w-full md:w-[66%] lg:w-[50%] xl:[40%] max-w-[580px]">

    <div v-for="(row, index) in mockData" :key="index" class="py-4 px-4 w-full border-b last:border-0 border-slate-200 justify-between grid grid-cols-4 gap-x-3">
      <div class="col-span-1">{{ row.name }}</div>
      <div class="flex gap-2 items-center col-span-2">
        <div class="bar h-4 rounded-full w-48 bg-blue-50 relative">
          <div :class="['progress bg-blue-900 left-0 top-0 bottom-0 absolute rounded-full']" :style="getPercentageWorked(row.workedHours)"></div>
        </div>
      </div>
      <p class="col-span-1">{{ row.workedHours }}/<span class="text-xs text-gray-500">35hrs</span></p>
    </div>

  </Card>
</template>
