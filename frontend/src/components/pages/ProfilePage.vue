<script setup lang="ts">
import { useUserStore } from '@/stores/user';

import { Separator } from "@/components/ui/separator";
import AccountDetails from '@/components/AccountDetails.vue';
import Password from "@/components/Password.vue";
import PageTitle from "@/components/titles/PageTitle.vue";
import SectionTitle from "@/components/titles/SectionTitle.vue"

const userStore = useUserStore()

</script>

<template>
  <PageTitle>Profile</PageTitle>
  <SectionTitle>Edit profile</SectionTitle>
  <AccountDetails v-if="userStore.user" :user="userStore.user" />
  <Separator class="md:hidden block mt-6 mb-2" />
  <SectionTitle class="md:mt-4">Edit profile</SectionTitle>
  <Password v-if="userStore.user" :user="userStore.user" />
</template>
