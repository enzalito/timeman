<script setup lang="ts">
import { ref, watchEffect } from "vue"
import { type User, type UserWithClock } from "@/api/user"
import { getTeam, type TeamWithUsers } from "@/api/team"

import { CircleDot } from "lucide-vue-next"
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectGroup,
  SelectItem
} from "@/components/ui/select"
import { Table, TableBody, TableCell, TableRow } from "@/components/ui/table"
import Card from "@/components/Card.vue"
import { useUserStore } from "@/stores/user"

const userStore = useUserStore()

// this component shouldn't be rendered if the current user
// doesn't belong to at least one team
const selectedTeamId = ref<string>(`${userStore.user!.teams[0].id}`)

const selectedTeam = ref<TeamWithUsers<UserWithClock> | undefined>()

watchEffect(async () => {
  selectedTeam.value = (
    await getTeam(+selectedTeamId.value, { withUsers: true, withClock: true })
  ).data
})

</script>

<template>
  <Card>
    <Select v-model="selectedTeamId">
      <SelectTrigger>
        <SelectValue placeholder="Select a team" />
      </SelectTrigger>
      <SelectContent>
        <SelectGroup>
          <SelectItem v-for="team in userStore.user!.teams" :key="team.id" :value="`${team.id}`">{{
            team.name
          }}</SelectItem>
        </SelectGroup>
      </SelectContent>
    </Select>

    <Table class="w-[100%]">
      <TableBody v-if="selectedTeam">
        <TableRow v-if="selectedTeam.users.length === 0">
          No users in the selected team
        </TableRow>
        <TableRow v-for="user in selectedTeam!.users" :key="user.id">
          <TableCell>{{ user.username }}</TableCell>
          <TableCell class="text-right">
            <div class="inline-flex flex-row items-center">
              <template v-if="user.clock.status">
                <CircleDot class="h-3 mr-2 stroke-green-500 fill-green-500" />
                <p class="w-14">working</p>
              </template>
              <template v-else>
                <div class="mr-2">
                  <CircleDot class="h-3 stroke-gray-500 fill-gray-500" />
                </div>
                <p class="w-14">offline</p>
              </template>
            </div>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </Card>
</template>
