<script setup lang="ts">
import Link from './Link/Link.vue';
</script>

<template>
  <div class="p-4 h-[100vh] left-0 w-60 border-r border-slate-200 hidden md:block">
    <h1 class="pb-8 text-2xl">Timeman</h1>



    <Link element="Home"/>
    <Link element="Stats"/>
    <Link element="Settings"/>

  </div>
</template>
