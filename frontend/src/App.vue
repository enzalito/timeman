<script setup lang="ts">
import { RouterView, useRoute } from "vue-router"

import Layout from "./components/layout/Layout.vue"
import Toaster from "./components/ui/toast/Toaster.vue";

const route = useRoute();

const authRoutes = ['/auth/login', '/auth/signup']

</script>

<template>
  <Layout v-if="!authRoutes.includes(route.path)">
    <RouterView />
  </Layout>
  <RouterView v-else/>
  <Toaster />

</template>
