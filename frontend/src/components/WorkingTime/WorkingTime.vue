<script setup lang="ts">
import { Card } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Edit2 as Edit, Trash, ArrowRight, Check } from "lucide-vue-next"
import DatePicker from "./DatePicker.vue"
import { ref } from "vue"

import { type DateValue } from "@internationalized/date"
import { z } from "zod"
import { toTypedSchema } from "@vee-validate/zod"
import { useForm } from "vee-validate"
import { FormField } from "../ui/form"

import Input from "../ui/input/Input.vue"
import FormItem from "../ui/form/FormItem.vue"
import { useUserStore } from "@/stores/user"
import {
  createWorkingTime,
  deleteWorkingTime,
  getWorkingTime,
  updateWorkingTime
} from "@/api/workingTime"
import { useDateFormat } from "@vueuse/core"

const userStore = useUserStore()
const userId = userStore.user?.id

const routeWorkingTimeId = 7

const data = await getWorkingTime(userId!, routeWorkingTimeId)

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

const row = data.data

if (row && Object.keys(row).length > 0) {
  isCreating.value = false
}

const startDateInitial = row?.start ? new Date(row.start) : new Date()
const endDateInitial = row?.end ? new Date(row.start) : new Date()

const formSchema = toTypedSchema(
  z.object({
    start: z.date().refine((v) => v, { message: "Start date required." }),
    end: z.date().refine((v) => v, { message: "End date required" }),
    id: z.number().optional()
  })
)

const { handleSubmit, setFieldValue, values } = useForm({
  validationSchema: formSchema,
  initialValues: {
    start: startDateInitial,
    end: endDateInitial,
    id: row.id
  }
})

function handleChange(column: "start" | "end", valueParam: DateValue) {
  const newDate = new Date(valueParam.toString())

  const oldDate = values[column]

  if (!oldDate) {
    setFieldValue(column, newDate)
    return
  }

  newDate?.setHours(oldDate.getHours())
  newDate?.setMinutes(oldDate.getMinutes())
  newDate?.setSeconds(oldDate.getSeconds())

  setFieldValue(column, newDate)
}

const onSubmit = handleSubmit(async (submitValues) => {
  toggleEditMode()

  useDateFormat(values.start, "YYYY-MM-DD")

  const start = values.start?.toISOString()
  const end = values.end?.toISOString()

  let data
  if (submitValues.id) {
    const res = await updateWorkingTime({ working_time: { start, end } }, submitValues.id)
    data = res.data
  } else {
    const res = await createWorkingTime({ working_time: { start, end } }, userId!)
    data = res.data
  }

  if (!data) {
    console.error("Error: no data after updating or creating working time")
    return
  }

  const startDate = new Date(data.start)
  const endDate = new Date(data.end)

  setFieldValue("start", startDate)
  setFieldValue("end", endDate)
  setFieldValue("id", data.id)
})

async function handleDelete() {
  toggleCreateMode()

  if (!values.id) {
    console.error(
      "WorkingTime/handleDelete: Error, attempting to delete while no id present for working time"
    )
    return
  }
  await deleteWorkingTime(values.id)

  setFieldValue("start", undefined)
  setFieldValue("end", undefined)
  setFieldValue("id", undefined)
}

const startTimeString = useDateFormat(values.start, "HH:mm:ss")
const endTimeString = useDateFormat(values.end, "HH:mm:ss")

const handleTimeChange = (key: "start" | "end", v: string) => {
  const splited = v.split(":")

  if (splited.length !== 3) {
    console.error("input not in the right format: hh-mm-ss")
    return
  }

  const [hour, minutes, seconds] = splited

  values[key]?.setHours(Number(hour))
  values[key]?.setMinutes(Number(minutes))
  values[key]?.setSeconds(Number(seconds))
}
</script>

<template>
  <Card class="w-[900px] p-4 mt-2">
    <form v-if="!isCreating" class="flex flex-row justify-between items-center" @submit="onSubmit">
      <div>
        <div v-if="isEditing" class="flex flex-row items-center gap-2">
          <FormField name="start">
            <DatePicker
              :form-value="values.start?.toISOString().split('T')[0]"
              @change="(value) => handleChange('start', value)"
            />
          </FormField>
          <FormField name="startTime">
            <FormItem>
              <Input
                placeholder="hh:mm:ss"
                :defaultValue="startTimeString"
                @update:modelValue="(v) => handleTimeChange('start', String(v))"
              />
            </FormItem>
          </FormField>
        </div>
        <p v-else>{{ useDateFormat(values.start, "YYYY-MM-DD HH:mm:ss") }} UTC</p>
      </div>
      <ArrowRight />
      <div>
        <div class="flex flex-row gap-2" v-if="isEditing">
          <FormField name="end">
            <DatePicker
              :formValue="values.end?.toISOString().split('T')[0]"
              @change="(value) => handleChange('end', value)"
            />
          </FormField>
          <FormField name="endTime">
            <FormItem>
              <Input
                placeholder="hh:mm:ss"
                :defaultValue="endTimeString"
                @update:modelValue="(v) => handleTimeChange('end', String(v))"
              />
            </FormItem>
          </FormField>
        </div>
        <p v-else>{{ useDateFormat(values.end, "YYYY-MM-DD HH:mm:ss") }} UTC</p>
      </div>

      <div class="flex items-center gap-2">
        <Button v-if="isEditing" type="submit" class="background-color: bg-green-500" size="sm">
          <Check class="h-4 w-4" />
          <span class="sr-only">Validate</span>
        </Button>
        <Button v-else @click="toggleEditMode" variant="outline" size="sm">
          <Edit class="h-4 w-4" />
          <span class="sr-only">Cancel</span>
        </Button>

        <!-- <Button v-if="isEditing" @click="toggleEditMode" variant="destructive" size="sm">
          <X class="h-4 w-4" />
          <span class="sr-only">Cancel</span>
        </Button> -->
        <Button v-if="!isEditing" variant="destructive" @click="handleDelete" size="sm">
          <Trash class="h-4 w-4" />
          <span class="sr-only">delete</span>
        </Button>
      </div>
    </form>

    <div class="grid place-items-center" v-else>
      <div class="flex flex-row items-center gap-3">
        <p>No working time</p>
        <Button
          class=""
          @click="
            () => {
              toggleCreateMode()
              toggleEditMode()
            }
          "
        >
          Create one
        </Button>
      </div>
    </div>
  </Card>
</template>
