<script setup lang="ts">
import { useUserStore } from '@/stores/user';
import AccountDetails from '../AccountDetails.vue';

const userStore = useUserStore()

function login() {
  userStore.set({email: "louis@yak3.fr", username: "louis3", role: 'employee', id: 3})
}
</script>

<template>
  <button @click="login">login</button>
  <br/><br/>
  <AccountDetails v-if="userStore.user" :user="userStore.user"/>
</template>
