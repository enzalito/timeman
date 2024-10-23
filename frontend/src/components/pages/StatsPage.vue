<script setup lang="ts">
import { useUserStore } from "@/stores/user"
import WeekSummaryTeamView from "@/components/charts/WeekSummaryTeam.vue"
import WeekSummary from "@/components/charts/WeekSummary.vue"

const userStore = useUserStore()
</script>

<template>
  <WeekSummary v-if="userStore?.user?.role === 'employee'" :userId="userStore?.user?.id" />
  <!-- FIXME -->
  <WeekSummaryTeamView v-if="userStore?.user?.role === 'manager'" :team-id="1" />
</template>
