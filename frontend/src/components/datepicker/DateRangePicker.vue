<script setup lang="ts">
import { type HTMLAttributes } from "vue"
import { DateFormatter, getLocalTimeZone } from "@internationalized/date"
import { cn, type DateRange } from "@/lib/utils"

import { Calendar as CalendarIcon } from "lucide-vue-next"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import { RangeCalendar } from "@/components/ui/range-calendar"
import { Button } from "@/components/ui/button"

const props = defineProps<{ class?: HTMLAttributes['class'] }>()

const dateFormatter = new DateFormatter("en-US", {
  dateStyle: "medium"
})

const model = defineModel<DateRange>({ required: true })
</script>

<template>
  <Popover>
    <PopoverTrigger as-child>
      <Button variant="outline"
        :class="cn('w-[280px] justify-start text-left font-normal', !model && 'text-muted-foreground', props.class)">
        <CalendarIcon class="mr-2 h-4 w-4" />
        <template v-if="model.start">
          <template v-if="model.end">
            {{ dateFormatter.format(model.start.toDate(getLocalTimeZone())) }}
            - {{ dateFormatter.format(model.end.toDate(getLocalTimeZone())) }}
          </template>

          <template v-else>
            {{ dateFormatter.format(model.start.toDate(getLocalTimeZone())) }}
          </template>
        </template>
        <template v-else> Pick a date range </template>
      </Button>
    </PopoverTrigger>
    <PopoverContent class="w-auto p-0">
      <RangeCalendar v-model="model" initial-focus />
    </PopoverContent>
  </Popover>
</template>
