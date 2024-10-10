<script setup lang="ts">
import { computed, h, ref } from 'vue'
import { CalendarDate, DateFormatter, getLocalTimeZone, parseDate, today, type DateValue } from '@internationalized/date'
import { toDate } from 'radix-vue/date'
import { Calendar as CalendarIcon } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'
import { Calendar } from '@/components/ui/calendar'
import { Button } from '@/components/ui/button'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'

const df = new DateFormatter('en-US', {
  dateStyle: 'long',
})


const {formValue} = defineProps<{formValue?: string}>()


const emits = defineEmits(['change'])

const value = computed({
  get: () => formValue ? parseDate(formValue) : undefined,
  set: val => val,
})

const placeholder = ref()

</script>

<template>

      <FormItem class="flex flex-col">
        <Popover>
          <PopoverTrigger as-child>
            <FormControl>
              <Button
                variant="outline" :class="[
                  'ps-3 text-start font-normal',
                  !value && 'text-muted-foreground',
                ]"

              >
                <span>{{ value ? df.format(toDate(value)) : "Pick a date" }}</span>
                <CalendarIcon class="ms-auto ml-2 h-4 w-4 opacity-50" />
              </Button>
              <input hidden>
            </FormControl>
          </PopoverTrigger>
          <PopoverContent class="w-auto p-0">
            <Calendar
              v-model="value"
              calendar-label="Date of birth"
              initial-focus
              @update:model-value="(v) => {
                emits('change', v)
              }"
            />
          </PopoverContent>
        </Popover>
        <FormMessage />
      </FormItem>


</template>
