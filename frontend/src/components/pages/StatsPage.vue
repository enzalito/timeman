<script setup lang="ts">
import { ref } from "vue";
import { useUserStore } from "@/stores/user"
import { type User } from "@/api/user";
import { type Team } from "@/api/team";

import { Separator } from "@/components/ui/separator";
import WeekSummaryTeam from "@/components/charts/week-summary/WeekSummaryTeam.vue"
import WeekSummary from "@/components/charts/week-summary/WeekSummary.vue"
import WorkingTimeChart from "@/components/charts/working-time/WorkingTimeChart.vue";
import PageTitle from "@/components/titles/PageTitle.vue";
import SectionTitle from "@/components/titles/SectionTitle.vue";
import UserSearchBar from "@/components/search/UserSearchBar.vue";

const userStore = useUserStore()

const userId = ref<number>(userStore.user?.id ?? -1)
const teamId = ref<number | undefined>()

const setUserId = (user: User) => {
  userId.value = user.id
  teamId.value = undefined
}
const setTeamId = (team: Team) => {
  teamId.value = team.id
}

</script>
<template>
  <div v-if="userStore.user" class="flex flex-col">
    <div class="flex justify-between">
      <PageTitle>Statistics</PageTitle>
      <UserSearchBar v-if="['manager', 'administrator'].includes(userStore.user.role)" @user-selected="setUserId"
        @team-selected="setTeamId" :search-teams="true" class="pt-4" />
    </div>
    <SectionTitle>Week summary</SectionTitle>
    <WeekSummaryTeam v-if="['manager', 'administrator'].includes(userStore.user.role) && teamId" :team-id="teamId" />
    <WeekSummary v-else :user-id="userId" />
    <Separator class="md:hidden block mt-6 mb-2" />
    <SectionTitle class="md:mt-4">Working time chart</SectionTitle>
    <WorkingTimeChart :user-id="userId" :team-id="teamId" />
  </div>
</template>
