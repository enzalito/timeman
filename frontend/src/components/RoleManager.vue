<script setup lang="ts">
import { ref, watch, onBeforeMount, type Ref, computed } from "vue"
import { getUsers, setRole, roles, type User, type Role } from "@/api/user"

import { Table, TableBody, TableRow, TableCell } from "@/components/ui/table"
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectGroup,
  SelectItem
} from "@/components/ui/select"
import Avatar from "@/components/Avatar.vue"
import Card from "@/components/Card.vue"
import SearchBar from "@/components/search/SearchBar.vue"

const roleNames = new Map<Role, string>([
  ["employee", "Employee"],
  ["manager", "Manager"]
])

const usernameFilter = ref("")

const users = ref<User[]>([])
const filteredUsers = computed(() => {
  const re = new RegExp(`${usernameFilter.value}`, "i")
  return users.value.filter((user) => {
    return re.test(user.username)
  })
})
const userRoles: Ref<string>[] = []

onBeforeMount(async () => {
  users.value = (await getUsers({ user: {} })).data

  for (let user of users.value) {
    const role = ref(user.role)
    userRoles.push(role)

    watch(role, async (role) => {
      await setRole(user.id, { user: { role: role } })
    })
  }
})
</script>

<template>
  <Card>
    <SearchBar class="mb-4" v-model="usernameFilter" />
    <Table>
      <TableBody>
        <TableRow v-if="filteredUsers.length === 0">
          <TableCell>There are no users</TableCell>
        </TableRow>
        <TableRow v-for="(user, i) in filteredUsers" :key="user.id">
          <TableCell class="w-0">
            <Avatar class="h-8 w-8">{{ user.username.charAt(0) }}</Avatar>
          </TableCell>
          <TableCell>{{ user.username }}</TableCell>
          <TableCell class="text-right">
            <Select v-model="userRoles[i].value">
              <SelectTrigger>
                <SelectValue placeholder="Select a role" />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectItem v-for="role in roles" :key="role" :value="role">{{
                    roleNames.get(role)
                  }}</SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </Card>
</template>
