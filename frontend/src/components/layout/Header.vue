<script setup lang="ts">
import { useCurrentTime } from "../../composables/useCurrentTime"
import { useUserStore } from "@/stores/user"
import Popover from "../ui/popover/Popover.vue";
import PopoverTrigger from "../ui/popover/PopoverTrigger.vue";
import PopoverContent from "../ui/popover/PopoverContent.vue";
import { LogOut, User } from "lucide-vue-next";
import Button from "../ui/button/Button.vue";

const { currentTime } = useCurrentTime()

// TODO: get username
const userStore = useUserStore()

const username = userStore.user?.username
const initial = username?.charAt(0).toUpperCase()
</script>
<template>
  <div class="w-full header flex justify-between items-center flex-row px-8 py-2 border-b border-slate-200">
    <div class="clock">
      <div class="hour text-xl font-medium">
        {{ currentTime.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) }}
      </div>
      <div class="date text-gray-400 text-md">
        {{ currentTime.toDateString() }}
      </div>
    </div>
    <Popover v-if="username !== undefined">
      <PopoverTrigger>
        <div class="rounded-full w-10 h-10 bg-blue-100 flex justify-center items-center">
          <p>{{ initial }}</p>
        </div>
      </PopoverTrigger>
      <PopoverContent class="w-32 grid p-1 mr-4">
        <router-link to='/profile' class="w-full">
        <Button variant="ghost" class="w-full grid-col-3 items-center justify-start gap-2">
          <User/>
          <p class="grid-span-2">Profile</p>
        </Button>
      </router-link>
          <Button variant="ghost" class="grid-col-3 items-center justify-start gap-2">
            <LogOut/>
            <p>Log out</p>
          </Button>
      </PopoverContent>


    </Popover>

  </div>
</template>
