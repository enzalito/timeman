<script setup lang="ts">
import { useUserStore } from '@/stores/user';
import AccountDetails from '../AccountDetails.vue';
import Password from '../Password.vue';
import PageTitle from '../titles/PageTitle.vue';

const userStore = useUserStore()

</script>

<template>
  <PageTitle>Profile</PageTitle>

  <AccountDetails v-if="userStore.user" :user="userStore.user"/>
  <div class="block opacity-100 md:opacity-0 h-[1px] w-full bg-slate-200 my-12 "/>

  <Password v-if="userStore.user" :user="userStore.user"/>
</template>
