<script setup lang="ts">
import NavBar from './NavBar.vue';
import MobileNavBar from "./MobileNavBar.vue"

</script>

<template>
  <div class="flex flex-nowrap">
    <NavBar/>
    <MobileNavBar/>
    <main class="w-full">
      <slot/>
    </main>
  </div>
</template>
