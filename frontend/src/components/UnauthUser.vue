<script setup lang="ts">
import { ref, computed } from "vue"
import { toTypedSchema } from "@vee-validate/zod"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { CollapsibleTrigger } from "@/components/ui/collapsible"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@/components/ui/select"
import User from "@/components/User.vue"
import { useUserStore } from "@/stores/user"
import {
  createUser,
  userRequest,
  userRequestPartial,
  type UserRequest,
  type UserRequestPartial,
  getUsers
} from "@/api/user"

const userStore = useUserStore()

const collapsibleState = ref<"login" | "register">("login")
const enableLogin = () => {
  collapsibleState.value = "login"
}
const enableRegister = () => {
  collapsibleState.value = "register"
}

const collapsibleText = computed(() => {
  return collapsibleState.value.charAt(0).toUpperCase() + collapsibleState.value.slice(1)
})

const onSubmit = computed(() => {
  switch (collapsibleState.value) {
    case "login": {
      return async (data: UserRequestPartial) => {
        userStore.set((await getUsers(data)).data)
      }
    }
    case "register": {
      return async (data: UserRequest) => {
        userStore.set((await createUser(data)).data)
      }
    }
  }
})

const formSchema = computed(() => {
  switch (collapsibleState.value) {
    case "login": {
      return toTypedSchema(userRequestPartial)
    }
    case "register": {
      return toTypedSchema(userRequest)
    }
  }
})
</script>

<template>
  <User
    greetingText="Hi there"
    :submitText="collapsibleText"
    :formSchema="formSchema"
    :onSubmit="onSubmit"
  >
    <template #actions="actionsProps">
      <CollapsibleTrigger as-child>
        <Button variant="outline" size="sm" :disabled="actionsProps.isOpen" @click="enableLogin">
          Login
        </Button>
      </CollapsibleTrigger>
      <CollapsibleTrigger as-child>
        <Button size="sm" :disabled="actionsProps.isOpen" @click="enableRegister">
          Register
        </Button>
      </CollapsibleTrigger>
    </template>
    <template v-slot:form-fields>
      <FormField v-slot="{ componentField }" name="user.username">
        <FormItem>
          <FormLabel>Username</FormLabel>
          <FormControl>
            <Input type="text" placeholder="user" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <FormField v-slot="{ componentField }" name="user.email">
        <FormItem>
          <FormLabel>Email</FormLabel>
          <FormControl>
            <Input type="text" placeholder="user@mail.com" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <FormField
        v-if="collapsibleState === 'register'"
        v-slot="{ componentField }"
        name="user.role"
      >
        <FormItem>
          <FormLabel>company role</FormLabel>
          <Select v-bind="componentField">
            <FormControl>
              <SelectTrigger>
                <SelectValue placeholder="Select your company role" />
              </SelectTrigger>
            </FormControl>
            <SelectContent>
              <SelectGroup>
                <SelectItem value="employee"> Employee </SelectItem>
                <SelectItem value="manager"> Manager </SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
          <FormMessage />
        </FormItem>
      </FormField>
    </template>
  </User>
</template>
