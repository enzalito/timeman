<script setup lang="ts">
import { Search } from "lucide-vue-next"
import Input from "@/components/ui/input/Input.vue"
</script>

<template>
  <div class="relative">
    <Input
      type="search"
      placeholder="Search..."
      class="pr-10 pl-8 rounded-md border border-muted focus:border-primary focus:ring-primary"
      v-bind="$attrs"
    />
    <Search class="absolute left-2.5 top-2.5 h-4 w-4 opacity-50" />
  </div>
</template>
