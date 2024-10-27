<script setup lang="ts">
import { LogOut, User } from "lucide-vue-next"
import { useUserStore } from "@/stores/user"
import { useCurrentTime } from "@/composables/useCurrentTime"

import Popover from "@/components/ui/popover/Popover.vue"
import PopoverTrigger from "@/components/ui/popover/PopoverTrigger.vue"
import PopoverContent from "@/components/ui/popover/PopoverContent.vue"
import Button from "@/components/ui/button/Button.vue"
import Logo from "@/components/layout/Logo.vue"
import Avatar from "@/components/Avatar.vue"
import { logout } from "@/api/sessions"
import router from "@/router"

const { currentTime } = useCurrentTime()

const userStore = useUserStore()

async function logOut() {
  await logout()
  userStore.unset()
  router.push({ name: 'login' })
}
</script>

<template>
  <div
    class="bg-white w-full header flex justify-between items-center flex-row p-4 md:px-6 md:py-2 border-b border-slate-200">
    <Logo class="show md:hidden" />
    <div class="hidden md:block">
      <div class="hour text-xl font-medium">
        {{ currentTime.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) }}
      </div>
      <div class="date text-gray-400 text-md">
        {{ currentTime.toDateString() }}
      </div>
    </div>

    <Popover v-if="userStore.user?.username !== undefined">
      <PopoverTrigger>
        <Avatar>{{ userStore.user.username?.charAt(0).toUpperCase() }}</Avatar>
      </PopoverTrigger>
      <PopoverContent class="w-32 grid p-1 mr-4">
        <router-link to="/profile" class="w-full">
          <Button variant="ghost" class="w-full grid-col-3 items-center justify-start gap-2">
            <User />
            <p class="grid-span-2">Profile</p>
          </Button>
        </router-link>
        <Button @click="logOut" variant="ghost" class="grid-col-3 items-center justify-start gap-2">
          <LogOut />
          <p>Log out</p>
        </Button>
      </PopoverContent>
    </Popover>
  </div>
</template>
