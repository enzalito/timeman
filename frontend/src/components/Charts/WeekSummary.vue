<script setup lang="ts">
import { DonutChart } from '@/components/ui/chart-donut'
import Card from '../Card.vue';
import { getCurrentWeekRange, getCurrentWeekText, getTodayWorkingTimesHours} from '@/lib/utils';
import { ArrowRight } from 'lucide-vue-next';
import { computed, onBeforeMount, ref } from 'vue';
import WeekSummaryTooltip from './WeekSummaryTooltip.vue';
import { getWorkingTimes } from '@/api/workingTime';


const {userId} = defineProps<{userId: number}>()





const data = ref([
  { name: 'This week', total: 0  },
  { name: 'Today', total: 0 },
  { name: 'left for the week', total: 6 }
])

onBeforeMount(async () => {
  const {start, end} = getCurrentWeekRange()
  const weekWorkingTimes = await getWorkingTimes(userId, start, end)

  const {hoursToday, hoursOtherEvents} = getTodayWorkingTimesHours(weekWorkingTimes.data)

  data.value[1].total = hoursToday
  data.value[0].total = hoursOtherEvents
})


const centerLabel = computed(() => `${Math.floor(data.value[0].total) + Math.floor(data.value[1].total)}/35hrs`)

const today = new Date().toLocaleDateString('fr')

const {startOfWeek, friday} = getCurrentWeekText()

</script>

<template>
  <Card title="Week summary" class="flex items-center justify-between w-fit gap-8">
    <div class="w-fit">
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded-sm bg-blue-500"/>
        <p class="inline-block">Today - {{ today }}</p>
      </div>
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded-sm bg-blue-900"/>
        <p class="inline-block">This week - {{ startOfWeek }} <ArrowRight class="w-4 h-4 inline mb-1"/> {{ friday }}</p>
      </div>
    </div>

    <DonutChart
      :centerLabel="centerLabel"
      index="name"
      :show-legend="true"
      :category="'total'"
      :data="data"
      :colors="['#1E3A8A', '#3B82F6', '#FBFBFB']"
      :custom-tooltip="WeekSummaryTooltip"
    >
  </DonutChart>

  </Card>
</template>
