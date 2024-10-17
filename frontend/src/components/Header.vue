<script setup lang="ts">
import { useCurrentTime } from "../composables/useCurrentTime"
import { useUserStore } from "@/stores/user"

const { currentTime } = useCurrentTime()

// TODO: get username
const userStore = useUserStore()

const username = "Charles"
const initial = username.charAt(0).toUpperCase()
</script>
<template>
  <div class="header flex justify-between items-center flex-row px-8 py-4">
    <div class="clock">
      <div class="hour text-3xl font-medium">
        {{ currentTime.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) }}
      </div>
      <div class="date text-blue-600 text-xl">
        {{ currentTime.toLocaleDateString() }}
      </div>
    </div>
    <div class="rounded-full w-10 h-10 bg-slate-400 flex justify-center items-center">
      <p>{{ initial }}</p>
    </div>
  </div>
</template>
