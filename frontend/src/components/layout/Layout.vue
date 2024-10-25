<script setup lang="ts">
import NavBar from "@/components/layout/NavBar.vue"
import MobileNavBar from "@/components/layout/MobileNavBar.vue"
import Header from "@/components/layout/Header.vue"
</script>

<template>
  <div class="flex flex-nowrap h-full md:pl-60">
    <NavBar />
    <MobileNavBar />
    <main class="w-full">
      <Header />
      <div class="p-6 pb-24 md:pb-26 md:bg-neutral-50">
        <slot />
      </div>
    </main>
  </div>
</template>
