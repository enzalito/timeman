<script setup lang="ts">
  import Logo from "@/components/layout/Logo.vue"
  import { Form } from "vee-validate";
  import { Button } from "../ui/button";
  import { toTypedSchema } from "@vee-validate/zod";
  import { getUsers, userLogin, type UserLogin } from "@/api/user";
  import { useUserStore } from "@/stores/user";
  import AuthFormFields from "../AuthFormFields.vue";

  const userStore = useUserStore()

  async function handleSubmit(data: UserLogin) {
    userStore.set((await getUsers(data)).data[0])
  }
  const formSchema = toTypedSchema(userLogin)
</script>

<template>
  <div class="grid place-items-center h-full">
    <div class="w-[86%] sm:w-[66%] md:w-[30%] max-w-[460px]">
      <Logo class="mx-auto mb-16 w-[60%]"/>

      <Form class="space-y-6" :validation-schema="formSchema" @submit="(data) => handleSubmit(data as UserLogin)">
        <AuthFormFields :include-fields="['email', 'password', 'username']"/>
          <Button type="submit" class="w-full">
            Register
          </Button>

          <router-link to="/auth/login" class="w-full relative mt-8 block text-blue-900 hover:underline" >
            Already have an account ? Log in
          </router-link>
      </Form>
    </div>
  </div>
</template>
