<script setup lang="ts">
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle
} from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { ref, onMounted, onBeforeUnmount, computed } from "vue"

import { createClock, getClocks } from "@/api/clockManager"
import { workingTimeRequestPartial, createWorkingTime } from "@/api/workingTime"
import { z } from "zod"

// import { useUserStore } from "@/stores/user"
// const user = useUserStore()
// const id = user.$id

import { useRoute } from "vue-router"
const route = useRoute()
const userIdParam = route.params.userid
const userId = parseInt(Array.isArray(userIdParam) ? userIdParam[0] : userIdParam)

const currentTime = ref("")

let timer: ReturnType<typeof setInterval>

onMounted(() => {
  refresh()
  updateTime()
  timer = setInterval(updateTime, 1000)
})

const clockIn = ref(false)
let startDateTime = ref<string | undefined>()

const updateTime = () => {
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, "0")
  const day = String(now.getDate()).padStart(2, "0")
  const hours = String(now.getHours()).padStart(2, "0")
  const minutes = String(now.getMinutes()).padStart(2, "0")
  const seconds = String(now.getSeconds()).padStart(2, "0")

  currentTime.value = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

const refresh = async () => {
  try {
    const userClocks = await getClocks(userId)
    const clockArray = userClocks.data.map((clock: { status: any; time: any }) => ({
      status: clock.status,
      time: clock.time
    }))
    if (clockArray[clockArray.length - 1].status == true) {
      clockIn.value = true
    } else {
      clockIn.value = false
    }
  } catch (error) {
    throw new Error("Error when getting clock")
  }
}
const handleClick = () => {
  clockIn.value = !clockIn.value
  const clockData = {
    clock: {
      status: clockIn.value,
      time: currentTime.value
    }
  }
  createClock(userId, clockData)
  if (clockIn.value == true) {
    startDateTime.value = currentTime.value
  } else {
    const newWorkingTime: z.infer<typeof workingTimeRequestPartial> = {
      working_time: {
        start: startDateTime.value,
        end: currentTime.value
      }
    }
    createWorkingTime(newWorkingTime, userId)
    startDateTime.value = undefined
  }
}

const colorStyle = computed(() => {
  return {
    color: clockIn.value ? "green" : "black"
  }
})

onBeforeUnmount(() => {
  clearInterval(timer)
})
</script>

<template>
  <Card class="w-[350px]">
    <CardHeader>
      <CardTitle>Clock Manager</CardTitle>
      <CardDescription class="mt-4"
        >{{ clockIn ? "Stop" : "Start" }} your working time</CardDescription
      >
    </CardHeader>
    <CardContent>
      <p class="mb-8 mt-0 text-l font-semibold" :style="colorStyle">{{ currentTime }}</p>
      <Button @click="handleClick">{{ clockIn ? "Stop" : "Start" }}</Button>
    </CardContent>
    <CardFooter class="flex justify-between px-6 pb-6"> </CardFooter>
  </Card>
</template>
