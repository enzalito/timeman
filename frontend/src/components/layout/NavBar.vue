<script setup lang="ts">
import Link from './Link/Link.vue';
</script>

<template>
  <div class="p-4 h-[100vh] left-0 w-60 border-r border-slate-200 hidden md:block">
    <img class="pb-8 w-[90%]" src="../../assets/Logo.png" alt="timeman logo">



    <Link element="Home"/>
    <Link element="Stats"/>
    <Link element="Settings"/>

  </div>
</template>
