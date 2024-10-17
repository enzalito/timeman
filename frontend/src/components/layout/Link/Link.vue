<script setup lang="ts">
import { Button } from '../../ui/button';
import { ChartArea, HomeIcon, Settings } from 'lucide-vue-next';

const {element, mode = "desktop"} = defineProps<{element: keyof typeof links, mode?: "desktop" | "mobile"}>()

const links = {
  "Home": {
    Icon: HomeIcon,
    text: "Home",
    link: "/"
  },
  "Stats": {
    Icon: ChartArea,
    text: "Stats",
    link: "/stats"
  },
  "Settings": {
    Icon: Settings,
    text: "Teams",
    link: "/teams"
  },


}
const {Icon, text, link} = links[element]

</script>

<template>
  <router-link :to="link" class="w-full">
    <Button variant="ghost"  :class="['w-full justify-start flex gap-4 text-lg font-normal ', mode === 'mobile' ? 'flex-col gap-2 text-sm h-full' : '']">
      <Icon class="h-5 w-5"/>
      {{ text }}
    </Button>
  </router-link>
</template>
