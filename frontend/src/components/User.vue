<script setup lang="ts">
import { ref } from 'vue'
import { Trash } from 'lucide-vue-next'
import { vAutoAnimate } from '@formkit/auto-animate/vue'
import { useForm } from 'vee-validate'
import { toTypedSchema } from '@vee-validate/zod'

import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Separator } from '@/components/ui/separator'
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from '@/components/ui/collapsible'
import {
  Card,
  CardTitle,
  CardContent,
} from '@/components/ui/card'
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form'

import { createUser, userRequest, userResponse } from '@/api/user.ts'
import { useUserStore } from '@/stores/user.ts'

const userStore = useUserStore()
const isAuthenticated = () => {
  return userStore.user === null
}
// TODO: handle non auth scenario

const isOpen = ref(false)
const close = () => {
  isOpen.value = false
}

const formSchema = toTypedSchema(userRequest)
</script>

<template>
  <Card class="w-[500px]">
    <Collapsible
      v-model:open="isOpen"
      class="p-4"
    >
      <div class="flex items-center justify-between space-x-4">
        <h2 class="text-l font-semibold">
          Hello Enzal
        </h2>
        <div class="flex items-center gap-2">
          <CollapsibleTrigger as-child>
            <Button variant="outline" size="sm" :disabled="isOpen">
              Edit profile
            </Button>
          </CollapsibleTrigger>
          <Button variant="destructive" size="sm" :disabled="isOpen" @click="deleteCurrentUser">
            <Trash class="h-4 w-4" />
            <span class="sr-only">Delete</span>
          </Button>
        </div>
      </div>
      <CollapsibleContent class="pt-4 space-y-2">
        <Separator />
        <Form class="px-2 space-y-6" :validation-schema="formSchema" @submit="createUser">
          <div class="flex gap-4">
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
          </div>
          <div class="flex gap-2">
            <Button type="button" variant="outline" @click="close">
              Cancel
            </Button>
            <Button type="submit">
              Save
            </Button>
          </div>
        </Form>
      </CollapsibleContent>
    </Collapsible>
  </Card>
</template>
