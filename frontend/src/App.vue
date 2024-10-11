<script setup lang="ts">
import { RouterView } from "vue-router"
import AuthUser from "@/components/AuthUser.vue"
import UnauthUser from "@/components/UnauthUser.vue"
import ChartManager from "@/components/ChartManager.vue"
import WorkingTime from "@/components/WorkingTime/WorkingTime.vue"

import { useUserStore } from "@/stores/user"
import { Suspense, onBeforeMount } from "vue"

const userStore = useUserStore()
const isAuthenticated = () => {
  return userStore.user !== undefined
}
import WorkingTimes from "./components/workingTimes.vue"
</script>

<template>
  <AuthUser v-if="isAuthenticated()" />
  <UnauthUser v-else />
  <!-- TODO: use onBeforeMount instead of Suspense -->
  <Suspense><WorkingTime v-if="isAuthenticated()" /></Suspense>
  <WorkingTimes v-if="isAuthenticated()" />
  <ChartManager v-if="isAuthenticated()" />
  <RouterView />
</template>
