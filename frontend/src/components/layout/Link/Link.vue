<script setup lang="ts">
import { Button } from '../../ui/button';
import {  ChartColumn, HomeIcon, Users } from 'lucide-vue-next';

const {element, mode = "desktop"} = defineProps<{element: keyof typeof links, mode?: "desktop" | "mobile"}>()

const links = {
  "Home": {
    Icon: HomeIcon,
    text: "Home",
    link: "/"
  },
  "Stats": {
    Icon: ChartColumn,
    text: "Stats",
    link: "/stats"
  },
  "Settings": {
    Icon: Users,
    text: "Users",
    link: "/users"
  },


}
const {Icon, text, link} = links[element]

</script>

<template>
  <router-link :to="link" class="w-full relative" v-slot="{ isActive }">
    <div v-if="isActive && mode === 'desktop'" class="w-1 bg-blue-900 rounded-md absolute left-2 top-2 bottom-2"/>
    <div v-if="isActive && mode === 'mobile'" class="h-1 bg-blue-900 rounded-md absolute left-2 right-2 bottom-1"/>
    <Button variant="ghost"  :class="['w-full justify-start flex gap-4 text-lg font-normal ', mode === 'mobile' ? 'flex-col gap-2 text-sm h-full' : '']">
      <Icon class="h-5 w-5"/>
      {{ text }}
    </Button>
  </router-link>
</template>
