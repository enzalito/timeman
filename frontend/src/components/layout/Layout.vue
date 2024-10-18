<script setup lang="ts">
import NavBar from "@/components/layout/NavBar.vue"
import MobileNavBar from "@/components/layout/MobileNavBar.vue"
import Header from "@/components/layout/Header.vue"
</script>

<template>
  <div class="flex flex-nowrap h-full">
    <NavBar />
    <MobileNavBar />
    <main class="w-full bg-neutral-50">
      <Header />
      <div class="p-6">
        <slot />
      </div>
    </main>
  </div>
</template>
