<script setup lang="ts">
import router from "@/router";
import { Form } from "vee-validate";
import { toTypedSchema } from "@vee-validate/zod";
import { createUser, userSignup, type UserSignup } from "@/api/user";

import { useToast } from "@/components/ui/toast";
import { Button } from "@/components/ui/button";
import Logo from "@/components/layout/Logo.vue"
import AuthFormFields from "@/components/AuthFormFields.vue";

const { toast } = useToast()

async function handleSubmit(data: UserSignup) {
  const res = await createUser(data)

  router.push({ name: 'login', query: { username: res.data.username } })
  toast({
    title: 'Your account has been created ! 💪',
    description: 'You can now log in to access your dashboard',
    duration: 5000
  })
}
const formSchema = toTypedSchema(userSignup)
</script>

<template>
  <div class="grid place-items-center h-full">
    <div class="w-[86%] sm:w-[66%] md:w-[30%] max-w-[460px]">
      <Logo class="mx-auto mb-16 w-[60%]" />

      <Form class="space-y-6" :validation-schema="formSchema" @submit="(data) => handleSubmit(data as UserSignup)">
        <AuthFormFields :include-fields="['email', 'password', 'username']" />
        <Button type="submit" class="w-full">
          Register
        </Button>

        <router-link to="/auth/login" class="w-full relative mt-8 block text-blue-900 hover:underline">
          Already have an account ? Log in
        </router-link>
      </Form>
    </div>
  </div>
</template>
