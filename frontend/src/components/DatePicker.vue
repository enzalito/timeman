<script setup lang="ts">
import { cn } from '@/lib/utils'
import { format } from 'date-fns'

import { Calendar as CalendarIcon } from 'lucide-vue-next'
import { Calendar } from '@/components/ui/v-calendar'
import { Button } from '@/components/ui/button'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover'

const model = defineModel<{start: Date, end: Date}>()
</script>

<template>
   <Popover>
      <PopoverTrigger as-child>
        <Button
          id="date"
          :variant="'outline'"
          :class="cn(
            'w-[280px] justify-start text-left font-normal',
            !model && 'text-muted-foreground',
          )"
        >
          <CalendarIcon class="mr-2 h-4 w-4" />

          <span>
            {{ model!.start ? (
              model!.end ? `${format(model!.start, 'LLL dd, y')} - ${format(model!.end, 'LLL dd, y')}`
              : format(model!.start, 'LLL dd, y')
            ) : 'Pick a date' }}
          </span>
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0" align="start">
        <Calendar
          v-model.range="model"
          :columns="2"
        />
      </PopoverContent>
    </Popover>
</template>