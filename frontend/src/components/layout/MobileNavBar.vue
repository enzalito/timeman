<script setup lang="ts">
import Link from './Link/Link.vue';
</script>

<template>
  <div class="p-4 h-20 w-full left-0 right-0 bottom-0 fixed border-t border-slate-200 flex justify-around items-center md:hidden">
    <Link element="Home" mode="mobile"/>
    <Link element="Stats" mode="mobile"/>
    <Link element="Settings" mode="mobile"/>
  </div>
</template>
