<script setup lang="ts">
  import type { UserSignup } from "@/api/user";
import { FormControl, FormField, FormLabel, FormMessage, FormItem } from "./ui/form";
  import { Input } from "./ui/input";


  const { includeFields } = defineProps<{includeFields: (keyof UserSignup['user'])[]}>()



</script>


<template>
  <div class="flex flex-col gap-4">
    <FormField v-if="includeFields.includes('username')" v-slot="{ componentField }" name="user.username">
      <FormItem class="space-y-1">
        <FormLabel>Username</FormLabel>
        <FormControl>
          <Input type="text" placeholder="user name" v-bind="componentField" />
        </FormControl>
        <FormMessage />
      </FormItem>
    </FormField>
    <FormField v-if="includeFields.includes('email')" v-slot="{ componentField }" name="user.email">
      <FormItem class="space-y-1">
        <FormLabel>Email</FormLabel>
        <FormControl>
          <Input type="email" placeholder="user@mail.com" v-bind="componentField" />
        </FormControl>
        <FormMessage />
      </FormItem>
    </FormField>
    <FormField v-if="includeFields.includes('password')" v-slot="{ componentField }" name="user.password">
      <FormItem class="space-y-1">
        <FormLabel>Password</FormLabel>
        <FormControl>
          <Input type="password" placeholder="password" v-bind="componentField" />
        </FormControl>
        <FormMessage />
      </FormItem>
    </FormField>
  </div>
</template>
