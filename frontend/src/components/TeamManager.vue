<script setup lang="ts">
import { ref, watch, onBeforeMount } from "vue"
import { type User } from "@/api/user"
import {
  createTeam,
  getTeam,
  getTeams,
  updateTeam,
  deleteTeam,
  addUser,
  removeUser,
  teamRequest,
  type Team,
  type TeamWithUsers
} from "@/api/team"
import { toTypedSchema } from "@vee-validate/zod"
import { useForm } from "vee-validate"
import { useDebounceFn } from "@vueuse/core"

import { vAutoAnimate } from "@formkit/auto-animate/vue"
import { FormControl, FormField, FormItem } from "@/components/ui/form"
import { ChevronRight, Users, Trash2 } from "lucide-vue-next"
import { Table, TableBody, TableRow, TableCell } from "@/components/ui/table"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import Avatar from "@/components/Avatar.vue"
import Card from "@/components/Card.vue"
import SearchBar from "@/components/SearchBar.vue"

const teams = ref<Team[]>([])

onBeforeMount(async () => {
  teams.value = (await getTeams({ team: {} })).data
})

const selectedTeamName = ref<string | undefined>()

const selectedTeam = ref<TeamWithUsers<User> | undefined>()
const setTeam = async (id: number) => {
  selectedTeam.value = (await getTeam(id, { withUsers: true })).data
  selectedTeamName.value = selectedTeam.value.name
}

watch(
  selectedTeamName,
  useDebounceFn(async (name) => {
    if (!selectedTeam.value || !name) {
      return
    }

    const { users, id, ...newTeam } = selectedTeam.value
    newTeam.name = name
    await updateTeam(id, { team: newTeam })
    for (let i = 0; i < teams.value.length; i++) {
      if (teams.value[i].id === selectedTeam.value.id) {
        teams.value[i].name = name
        break
      }
    }
  }, 500)
)

const { handleSubmit: handleNewTeam } = useForm({
  validationSchema: toTypedSchema(teamRequest)
})
const submitNewTeam = handleNewTeam(async (team) => {
  const newTeam = await createTeam(team)
  teams.value.push(newTeam.data)
})

const handleDelete = async () => {
  if (!selectedTeam.value) {
    return
  }

  await deleteTeam(selectedTeam.value.id)
  for (let i = 0; i < teams.value.length; i++) {
    if (teams.value[i].id === selectedTeam.value.id) {
      teams.value.splice(i, 1)
      selectedTeam.value = undefined
      break
    }
  }
}

const handleAddUser = async (user: User) => {
  if (!selectedTeam.value) {
    return
  }

  await addUser(selectedTeam.value.id, user.id)
  if (!selectedTeam.value.users) {
    selectedTeam.value.users = []
  }
  selectedTeam.value.users.push(user)
}

const handleRemoveUser = async (user: User) => {
  if (!selectedTeam.value) {
    return
  }

  await removeUser(selectedTeam.value.id, user.id)
  const userIdx = selectedTeam.value.users.indexOf(user)
  if (!userIdx) {
    return
  }
  selectedTeam.value?.users.splice(userIdx, 1)
}
</script>

<template>
  <div class="flex flex-row gap-2">
    <Card class="w-1/2 self-start">
      <Table>
        <TableBody>
          <TableRow v-if="!teams || teams.length === 0">
            <TableCell>There are no teams</TableCell>
          </TableRow>
          <TableRow v-for="team in teams" :key="team.id" @click="setTeam(team.id)">
            <TableCell class="w-0">
              <Avatar class="h-8 w-8"><Users class="h-4 w-4 stroke-current" /></Avatar>
            </TableCell>
            <TableCell>{{ team.name }}</TableCell>
            <TableCell class="text-right">
              <ChevronRight stroke-width="1" class="inline" />
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
      <form class="flex flex-row gap-2 mt-4" @submit="submitNewTeam">
        <FormField v-slot="{ componentField }" name="team.name">
          <FormItem v-auto-animate>
            <FormControl>
              <Input type="text" placeholder="Team name" v-bind="componentField" />
            </FormControl>
          </FormItem>
        </FormField>
        <Button type="submit" variant="secondary">Add team</Button>
      </form>
    </Card>
    <Card v-if="selectedTeam" class="w-1/2 self-start">
      <div class="flex flex-row gap-2 mt-4">
        <Input type="text" placeholder="Team name" v-model="selectedTeamName" />
        <Button variant="destructive">
          <Trash2 class="h-5 w-5 stroke-current" @click="handleDelete"
        /></Button>
      </div>
      <Table class="mt-4">
        <TableBody>
          <TableRow v-if="!selectedTeam.users || selectedTeam.users.length === 0">
            <TableCell>There are no users in this team</TableCell>
          </TableRow>
          <TableRow v-for="user in selectedTeam.users" :key="user.id">
            <TableCell class="w-0">
              <Avatar class="h-8 w-8">{{ user.username.charAt(0) }}</Avatar>
            </TableCell>
            <TableCell>{{ user.username }}</TableCell>
            <TableCell class="text-right">
              <Button variant="outline" size="icon" @click="handleRemoveUser(user)">
                <Trash2 stroke-width="1" class="h-5 w-5" />
              </Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
      <SearchBar class="mt-4" @user-selected="handleAddUser" />
    </Card>
  </div>
</template>
