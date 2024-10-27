<script setup lang="ts">
import PageTitle from "@/components/titles/PageTitle.vue";
import SectionTitle from "@/components/titles/SectionTitle.vue";
import TeamManager from "@/components/TeamManager.vue";
import RoleManager from "@/components//RoleManager.vue";
import { Separator } from '@/components/ui/separator';
import { useUserStore } from "@/stores/user";

const userStore = useUserStore()
</script>

<template>
  <div v-if="userStore.user && ['manager', 'administrator'].includes(userStore.user.role)"
    class="flex flex-col max-w-screen-md">
    <PageTitle>Users</PageTitle>
    <SectionTitle>Team management</SectionTitle>
    <TeamManager />
    <Separator class="md:hidden block mt-6 mb-2" />
    <SectionTitle class="md:mt-4">Role assignment</SectionTitle>
    <RoleManager />
  </div>
</template>
