<script setup lang="ts">
import Links from "@/components/layout/Links.vue"
import Logo from "@/components/layout/Logo.vue"
</script>

<template>
  <div class="p-4 h-[100vh] left-0 min-w-60 border-r border-slate-200 hidden md:block md:fixed">
    <Logo class="pl-2" />

    <div class="pt-8 flex flex-col gap-4">
      <Links />
    </div>
  </div>
</template>
