<script setup lang="ts">
import type { FunctionalComponent } from "vue"
import { ChartColumn, HomeIcon, Users } from "lucide-vue-next"
import Link from "@/components/layout/Link.vue"

const { mode = "desktop" } = defineProps<{
  mode?: "desktop" | "mobile"
}>()
</script>

<template>
  <Link link="/" text="Home" :mode="mode">
    <HomeIcon />
  </Link>
  <Link link="/stats" text="Stats" :mode="mode">
    <ChartColumn />
  </Link>
  <Link link="/users" text="Users" :mode="mode">
    <Users />
  </Link>
</template>
