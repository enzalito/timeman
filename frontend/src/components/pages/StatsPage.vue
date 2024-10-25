<script setup lang="ts">
import { useUserStore } from "@/stores/user"
import WeekSummaryTeamView from "@/components/charts/week-summary/WeekSummaryTeam.vue"
import WeekSummary from "@/components/charts/week-summary/WeekSummary.vue"

const userStore = useUserStore()
</script>

<template>
  <WeekSummary v-if="userStore?.user?.role === 'employee'" :userId="userStore?.user?.id" />
  <!-- FIXME -->
  <WeekSummaryTeamView v-if="userStore?.user?.role === 'manager'" :team-id="1" />
</template>
