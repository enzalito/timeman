<script setup lang="ts">
import PageTitle from "@/components/titles/PageTitle.vue"
import SectionTitle from "@/components/titles/SectionTitle.vue"
import { useUserStore } from "@/stores/user";
import ClockIn from "@/components/ClockIn.vue";
import TeamOverview from "@/components/TeamOverview.vue";
import WorkSessions from "@/components/work-sessions/WorkSessions.vue";
import { Separator } from "@/components/ui/separator";

const userStore = useUserStore()
</script>

<template>
  <div v-if="userStore.user" class="flex flex-col max-w-screen-md">
    <PageTitle>Hi, {{ userStore.user.username }}</PageTitle>
    <div class="flex flex-col md:flex-row md:items-stretch justify-between w-full">
      <div class="md:w-6/12 flex flex-col">
        <SectionTitle>Work session</SectionTitle>
        <ClockIn :user-id="userStore.user.id" class="grow" />
      </div>
      <Separator class="md:hidden block mt-6 mb-2" />
      <div v-if="userStore.user.teams.length > 0" class="md:w-5/12 flex flex-col">
        <SectionTitle>Team</SectionTitle>
        <TeamOverview class="grow" />
      </div>
    </div>
    <Separator class="md:hidden block mt-6 mb-2" />
    <SectionTitle class="md:mt-4">Session history</SectionTitle>
    <WorkSessions :user-id="userStore.user.id" />
  </div>
</template>
