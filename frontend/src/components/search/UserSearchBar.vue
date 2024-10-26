<script setup lang="ts">
import { ref } from "vue"
import { useDebounceFn } from "@vueuse/core"
import { getUsers, type User } from "@/api/user"
import { getTeams, type Team } from "@/api/team"

import { Users } from "lucide-vue-next"
import Avatar from "@/components/Avatar.vue"
import SearchBar from "@/components/search/SearchBar.vue"

const { searchTeams } = defineProps<{ searchTeams?: boolean }>()

const isFocused = ref(false)
const focus = () => {
  isFocused.value = true
}
const unfocus = () => {
  // let the user|teamSelected events emit
  setTimeout(() => {
    isFocused.value = false
  }, 100)
}

const suggestedUsers = ref<User[] | undefined>()
const suggestedTeams = ref<Team[] | undefined>()
const updateSearchSuggestions = useDebounceFn(async (event: Event) => {
  const { value } = event.target as HTMLInputElement
  suggestedUsers.value = (await getUsers({ user: { username: value } })).data
  if (searchTeams) {
    suggestedTeams.value = (await getTeams({ team: { name: value } })).data
  }
}, 500)
</script>

<template>
  <div class="relative w-full max-w-md">
    <SearchBar @focus="focus" @blur="unfocus" @input="updateSearchSuggestions" />
    <div v-show="isFocused"
      class="absolute z-10 w-full mt-2 overflow-auto max-h-[300px] rounded-md border border-muted bg-background shadow-lg">
      <div class="py-2">
        <div v-if="(!suggestedUsers || suggestedUsers.length === 0) && (!suggestedTeams || suggestedTeams.length === 0)"
          class="px-4 py-2 text-sm font-medium text-muted-foreground">
          No result
        </div>
        <template v-if="suggestedUsers && suggestedUsers.length !== 0">
          <div class="px-4 py-2 text-sm font-medium text-gray-400">Users</div>
          <div class="space-y-1">
            <li v-for="user in suggestedUsers" :key="user.id">
              <div class="flex flex-row items-center gap-2 px-4 py-2 text-sm hover:bg-muted"
                @click="$emit('userSelected', user)">
                <Avatar class="h-8 w-8">{{ user.username.charAt(0) }}</Avatar>
                {{ user.username }}
              </div>
            </li>
          </div>
        </template>
        <template v-if="suggestedTeams && suggestedTeams.length !== 0">
          <div class="px-4 py-2 text-sm font-medium text-gray-400">Teams</div>
          <div class="space-y-1">
            <li v-for="team in suggestedTeams" :key="team.id">
              <div class="flex flex-row items-center gap-2 px-4 py-2 text-sm hover:bg-muted"
                @click="$emit('teamSelected', team)">
                <Avatar class="h-8 w-8">
                  <Users class="h-4 w-4 stroke-current" />
                </Avatar>
                {{ team.name }}
              </div>
            </li>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>
