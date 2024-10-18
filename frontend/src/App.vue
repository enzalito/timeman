<script setup lang="ts">
import { RouterView } from "vue-router"
import AuthUser from "@/components/AuthUser.vue"
import UnauthUser from "@/components/UnauthUser.vue"
import ChartManager from "@/components/ChartManager.vue"
import WorkingTime from "@/components/WorkingTime/WorkingTime.vue"
import WorkingTimes from "@/components/WorkingTimes.vue"
import { useUserStore } from "@/stores/user"
import { Suspense } from "vue"

import Layout from "@/components/layout/Layout.vue"
import PageTitle from "@/components/titles/PageTitle.vue"
import SectionTitle from "@/components/titles/SectionTitle.vue"

const userStore = useUserStore()
const isAuthenticated = () => {
  return userStore.user !== undefined
}

document.body.style.zoom = "120%"
</script>

<template>
  <Layout>
    <PageTitle>Test page</PageTitle>
    <SectionTitle>Test section</SectionTitle>
    <AuthUser v-if="isAuthenticated()" />
    <UnauthUser v-else />
    <!-- TODO: use onBeforeMount instead of Suspense -->
    <Suspense><WorkingTime v-if="isAuthenticated()" /></Suspense>
    <WorkingTimes v-if="isAuthenticated()" />
    <ChartManager v-if="isAuthenticated()" />
    <RouterView />

    <Card title="Card title">
      card content Lorem ipsum dolor sit amet consectetur adipisicing elit. Nam at totam eveniet
      doloremque, molestiae corrupti molestias iusto officiis ipsam delectus similique porro aperiam
      harum fugit architecto quod, eaque perspiciatis modi?
    </Card>
  </Layout>
</template>
