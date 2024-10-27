<script setup lang="ts">
import { ChartColumn, HomeIcon, Users } from "lucide-vue-next"
import Link from "@/components/layout/Link.vue"
import { useUserStore } from '../../stores/user';

const { mode = "desktop" } = defineProps<{
  mode?: "desktop" | "mobile"
}>()

const userStore = useUserStore()
</script>

<template>
  <Link link="/" text="Home" :mode="mode">
  <HomeIcon />
  </Link>
  <Link link="/stats" text="Stats" :mode="mode">
  <ChartColumn />
  </Link>
  <Link v-if="userStore.user && ['manager', 'administrator'].includes(userStore.user.role)" link="/users" text="Users"
    :mode="mode">
  <Users />
  </Link>
</template>
