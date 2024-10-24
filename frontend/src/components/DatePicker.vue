<script setup lang="ts">
import { computed } from "vue"
import { DateFormatter, parseDate } from "@internationalized/date"
import { toDate } from "radix-vue/date"
import { Calendar as CalendarIcon } from "lucide-vue-next"
import { Calendar } from "@/components/ui/calendar"
import { Button } from "@/components/ui/button"
import { FormItem, FormMessage, FormControl } from "@/components/ui/form"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"

const dateFormatter = new DateFormatter("en-US", {
  dateStyle: "long"
})

const { value } = defineProps<{ value?: string }>()

const parsedValue = computed({
  get: () => (value ? parseDate(value) : undefined),
  set: (val) => val
})
</script>

<template>
  <FormItem class="flex flex-col">
    <Popover>
      <PopoverTrigger as-child>
        <FormControl>
          <Button
            variant="outline"
            :class="['ps-3 text-start font-normal', !parsedValue && 'text-muted-foreground']"
          >
            <span>{{
              parsedValue ? dateFormatter.format(toDate(parsedValue)) : "Pick a date"
            }}</span>
            <CalendarIcon class="ms-auto ml-2 h-4 w-4 opacity-50" />
          </Button>
          <input hidden />
        </FormControl>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0">
        <Calendar
          v-model="parsedValue"
          calendar-label="Date of birth"
          initial-focus
          @update:model-value="
            (v) => {
              $emit('change', v)
            }
          "
        />
      </PopoverContent>
    </Popover>
    <FormMessage />
  </FormItem>
</template>
