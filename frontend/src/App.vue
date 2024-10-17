<script setup lang="ts">
import { RouterView } from "vue-router"
import AuthUser from "@/components/AuthUser.vue"
import UnauthUser from "@/components/UnauthUser.vue"
import ChartManager from "@/components/ChartManager.vue"
import WorkingTime from "@/components/WorkingTime/WorkingTime.vue"
import WorkingTimes from "./components/WorkingTimes.vue";
import { useUserStore } from "@/stores/user"
import { Suspense } from "vue"
import SideBar from "./components/layout/NavBar.vue"
import MobileSidebar from "./components/layout/MobileNavBar.vue"

const userStore = useUserStore()
const isAuthenticated = () => {
  return userStore.user !== undefined
}
</script>

<template>
  <div class="flex flex-nowrap">
    <SideBar/>
    <MobileSidebar/>
    <main>
      <AuthUser v-if="isAuthenticated()" />
      <UnauthUser v-else />
      <!-- TODO: use onBeforeMount instead of Suspense -->
      <Suspense><WorkingTime v-if="isAuthenticated()" /></Suspense>
      <WorkingTimes v-if="isAuthenticated()" />
      <ChartManager v-if="isAuthenticated()" />
      <RouterView />
    </main>
  </div>
</template>
