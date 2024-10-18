<script setup lang="ts">
import type { FunctionalComponent } from "vue"
import { ChartColumn, HomeIcon, Users } from "lucide-vue-next"
import Link from "@/components/layout/Link.vue"

const { mode = "desktop" } = defineProps<{
  mode?: "desktop" | "mobile"
}>()
</script>

<template>
  <Link link="/" text="Home" :icon="HomeIcon" :mode="mode" />
  <Link link="/stats" text="Stats" :icon="ChartColumn" :mode="mode" />
  <Link link="/users" text="Users" :icon="Users" :mode="mode" />
</template>
