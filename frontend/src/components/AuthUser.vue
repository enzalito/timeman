<script setup lang="ts">
import { Trash } from "lucide-vue-next"
import { toTypedSchema } from "@vee-validate/zod"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { CollapsibleTrigger } from "@/components/ui/collapsible"
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"

import User from "@/components/User.vue"
import { updateUser, deleteUser, userRequest } from "@/api/user"
import { useUserStore } from "@/stores/user"

const userStore = useUserStore()

const greetingText = `Hello ${userStore.user!.username}`

const deleteCurrentUser = async () => {
  const userId = userStore.user!.id
  userStore.unset()
  await deleteUser(userId)
}

const formSchema = toTypedSchema(userRequest)
</script>

<template>
  <User
    :greetingText="greetingText"
    submitText="Save"
    :formSchema="formSchema"
    :onSubmit="updateUser"
  >
    <template #actions="actionsProps">
      <CollapsibleTrigger as-child>
        <Button variant="outline" size="sm" :disabled="actionsProps.isOpen"> Edit profile </Button>
      </CollapsibleTrigger>
      <Button
        variant="destructive"
        size="sm"
        :disabled="actionsProps.isOpen"
        @click="deleteCurrentUser"
      >
        <Trash class="h-4 w-4" />
        <span class="sr-only">Delete</span>
      </Button>
    </template>
    <template v-slot:form-fields>
      <FormField v-slot="{ componentField }" name="username">
        <FormItem>
          <FormLabel>Username</FormLabel>
          <FormControl>
            <Input type="text" placeholder="user" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <FormField v-slot="{ componentField }" name="email">
        <FormItem>
          <FormLabel>Email</FormLabel>
          <FormControl>
            <Input type="text" placeholder="user@mail.com" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
    </template>
  </User>
</template>
