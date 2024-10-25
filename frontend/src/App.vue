<script setup lang="ts">
import { RouterView, useRoute } from "vue-router"

import Layout from "./components/layout/Layout.vue"

const route = useRoute();
console.log(route.path);

const authRoutes = ['/auth/login', '/auth/signup']

</script>

<template>
  <Layout v-if="!authRoutes.includes(route.path)">
    <RouterView />
  </Layout>
  <RouterView v-else/>

</template>
