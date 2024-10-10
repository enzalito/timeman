<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router"
import User from "@/components/User.vue"
</script>

<template>
  <header>
    <p>Hi there</p>
  </header>

  <User />
  <RouterView />
</template>
