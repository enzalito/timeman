<script setup lang="ts">
import { useUserStore } from '@/stores/user';
import WeekSummaryTeamView from '../Charts/WeekSummaryTeamView.vue';
import WeekSummary from '../Charts/WeekSummary.vue';
import { ref } from 'vue';


const userStore = useUserStore()

const type = ref(userStore.user?.type)
const userId = ref(userStore.user?.id)



console.log({type: type.value, userId: userId.value, userStore});


</script>

<template>
  <WeekSummary v-if="userStore?.user?.type === 'employee'" :userId="userStore?.user?.id" />
  <WeekSummaryTeamView v-if="type === 'manager'" :teamUsers="[{id: 1}]"/>
</template>
