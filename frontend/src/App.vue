<script setup lang="ts">
import { RouterView } from "vue-router"
import AuthUser from "@/components/AuthUser.vue"
import UnauthUser from "@/components/UnauthUser.vue"
import WorkingTime from "@/components/WorkingTime/WorkingTime.vue";

import { useUserStore } from "@/stores/user"
import { Suspense } from "vue";

const userStore = useUserStore()
const isAuthenticated = () => {
  return userStore.user !== undefined
}
import WorkingTimes from "./components/workingTimes.vue";
</script>

<template>
  <AuthUser v-if="isAuthenticated()" />
  <UnauthUser v-else />
  <Suspense v-if="isAuthenticated()">
    <WorkingTime  />
  </Suspense>
  <RouterView />
  <WorkingTimes v-if="isAuthenticated()"/>
</template>
