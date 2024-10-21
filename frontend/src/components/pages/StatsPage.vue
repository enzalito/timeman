<script setup lang="ts">
import { useUserStore } from '@/stores/user';
import WeekSummaryTeamView from '../Charts/WeekSummaryTeamView.vue';
import WeekSummary from '../Charts/WeekSummary.vue';


const userStore = useUserStore()

</script>

<template>
  <WeekSummary v-if="userStore?.user?.role === 'employee'" :userId="userStore?.user?.id" />
  <WeekSummaryTeamView v-if="userStore?.user?.role === 'manager'" :team-id="1"/>
</template>
