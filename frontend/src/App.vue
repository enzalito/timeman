<script setup lang="ts">
import { RouterView } from "vue-router"
import AuthUser from "@/components/AuthUser.vue"
import UnauthUser from "@/components/UnauthUser.vue"
import WorkingTime from "@/components/WorkingTime/WorkingTime.vue";

import { useUserStore } from "@/stores/user"

const userStore = useUserStore()
const isAuthenticated = () => {
  return userStore.user !== undefined
}
import WorkingTimes from "./components/workingTimes.vue";
</script>

<template>
  <AuthUser v-if="isAuthenticated()" />
  <UnauthUser v-else />
  <WorkingTime v-if="isAuthenticated()" />
  <RouterView />
  <WorkingTimes v-if="isAuthenticated()"/>
</template>
