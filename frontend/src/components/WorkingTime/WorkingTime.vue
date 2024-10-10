<script setup lang="ts">
import {
  Card
} from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Edit2 as Edit, Trash, ArrowRight, Check, X } from 'lucide-vue-next'
import DatePicker from './DatePicker.vue'
import { ref } from 'vue';

import {
  parseDate,
  type DateValue,
} from '@internationalized/date'
import { toDate } from 'radix-vue/date';
import { z } from 'zod';
import { toTypedSchema } from '@vee-validate/zod';
import { useForm } from 'vee-validate';
import { FormField } from '../ui/form';

import Input from '../ui/input/Input.vue';
import FormItem from '../ui/form/FormItem.vue';




  const {id} = defineProps({id: Number})


  const data = [{id: 1, start: "2024-07-29T12:28:29", end: "2024-08-30T12:28:29", user: 1}]


  const isEditing = ref<boolean>(false)
  const isCreating = ref<boolean>(true)


  function toggleEditMode() {
    isCreating.value = false
    isEditing.value = !isEditing.value
  }
  function toggleCreateMode() {
    isEditing.value = false
    isCreating.value = !isCreating.value
  }





  const row = data.find((obj) => obj.id === Number(id))

  if (row) {
    isCreating.value = false
  }

  const [startDateInitial, startTimeInitial] = row?.start.split("T") ?? []
  const [endDateInitial, endTimeInitial] = row?.end.split("T") ?? []

  const formSchema = toTypedSchema(z.object({
    start: z
    .string()
    .refine(v => v, { message: 'Start date required.' }),
    end: z
    .string()
    .refine(v => v, { message: 'End date required' }),
    endTime: z
    .string()
    .refine(v => v, { message: 'time required' }),
    startTime: z
    .string()
    .refine(v => v, { message: 'time required' }),
  }))

  const { handleSubmit, setFieldValue, values } = useForm({
    validationSchema: formSchema,
    initialValues: {
      start: startDateInitial,
      end: endDateInitial,
      endTime: endTimeInitial,
      startTime: startTimeInitial
    },
  })

  function handleChange(column: 'start' | 'end', valueParam: DateValue) {
    setFieldValue(column, valueParam.toString())
  }

  const onSubmit = handleSubmit((values) => {
    toggleEditMode()
  })




</script>



<template>
  <Card class="w-[900px] p-4 mt-2">

    <form v-if="!isCreating" class="flex flex-row justify-between items-center" @submit="onSubmit">

      <div>
        <div v-if="isEditing" class="flex flex-row items-center gap-2">
          <FormField name="start" >
              <DatePicker  :formValue="values.start" @change="(value) => handleChange('start', value)"/>
          </FormField>
          <FormField name="startTime">
            <FormItem>
              <Input placeholder="hh:mm:ss" :defaultValue="values.startTime" @update:modelValue="(v) => setFieldValue('startTime', String(v))" />
            </FormItem>
          </FormField>


        </div>
            <p v-else>{{ startDateInitial }} {{ startTimeInitial}}</p>
      </div>
      <ArrowRight/>
      <div>

        <div class="flex flex-row gap-2" v-if="isEditing">
          <FormField name="end">
            <DatePicker  :formValue="values.end"  @change="(value) => handleChange('end', value)"/>
          </FormField>
          <FormField name="endTime">
            <FormItem>
              <Input placeholder="hh:mm:ss" :defaultValue="values.endTime" @update:modelValue="(v) => setFieldValue('endTime', String(v))" />
            </FormItem>
          </FormField>
        </div>
          <p v-else>{{ endDateInitial }} {{ endTimeInitial }}</p>
      </div>


      <div class="flex items-center gap-2">


        <Button v-if="isEditing" type="submit" class="background-color: bg-green-500" size="sm">
          <Check class="h-4 w-4" />
          <span class="sr-only">Validate</span>
        </Button>
        <Button v-else @click="toggleEditMode" variant="outline" size="sm">
          <Edit class="h-4 w-4"/>
          <span class="sr-only">Cancel</span>
        </Button>


        <Button v-if="isEditing" @click="toggleEditMode" variant="destructive" size="sm">
          <X class="h-4 w-4" />
          <span class="sr-only">Cancel</span>
        </Button>
        <Button v-else variant="destructive" @click="toggleCreateMode" size="sm">
          <Trash class="h-4 w-4" />
          <span class="sr-only">delete</span>
        </Button>
      </div>

    </form>

    <div class="grid place-items-center" v-else>
      <div class="flex flex-row items-center gap-3">
        <p>No working time</p>
        <Button class="" @click="() => {toggleCreateMode(); toggleEditMode()}">
            Create one
        </Button>
      </div>
    </div>
  </Card>
</template>
