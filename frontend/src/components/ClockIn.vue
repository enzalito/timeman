<script setup lang="ts">
import { ref, onMounted } from "vue"
import { createClock, getClock, type Clock, type ClockRequest } from "@/api/clock"
import { formatDateTime } from "@/lib/utils"

import { CircleDot } from "lucide-vue-next"
import { Textarea } from "@/components/ui/textarea"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import Card from "@/components/Card.vue"

const { userId } = defineProps<{ userId: number }>()

const clock = ref<Clock | undefined>()

onMounted(async () => {
  clock.value = (await getClock(userId)).data ?? { status: false, time: "", userId }
})

const description = ref("")

const toggleClock = async () => {
  const newClock: ClockRequest = {
    clock: {
      status: !clock.value!.status,
      time: formatDateTime(new Date()),
      description: description.value
    }
  }
  clock.value = (await createClock(userId, newClock)).data
}
</script>

<template>
  <Card class="flex flex-col justify-between gap-3">
    <template v-if="clock">
      <template v-if="!clock.status">
        <div class="flex flex-row items-center font-medium">
          <CircleDot class="h-3 stroke-stone-500 fill-stone-500" />
          <p>Not started yet</p>
        </div>
        <Button @click="toggleClock"> Clock in </Button>
      </template>
      <template v-else>
        <div class="flex flex-row items-center font-medium">
          <CircleDot class="h-3 stroke-green-500 fill-green-500" />
          <p>Started at {{ clock.time.substring(12) }}</p>
        </div>
        <div>
          <Label for="message">Comment - optionnal</Label>
          <Textarea v-model="description" placeholder="Type your message here" />
        </div>
        <Button @click="toggleClock"> Clock out </Button>
      </template>
    </template>
  </Card>
</template>
