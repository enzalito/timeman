<script setup lang="ts">
  import { Button } from '../ui/button';
  import { PlayIcon } from 'lucide-vue-next'
</script>


<template>
  <div class="mb-40 p-3 rounded-md bg-neutral-100 flex items-center text-sm justify-between">
    Not working
    <Button class="rounded-[50px] px-2 text-xs h-fit">
      <PlayIcon class="w-3 h-3 mr-2" />
      Start
    </Button>
  </div>
</template>
