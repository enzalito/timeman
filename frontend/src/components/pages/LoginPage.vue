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
        <AuthFormFields :includeFields="['username', 'password']"/>
        <Button type="submit" variant="secondary" class="w-full border-slate-200 border">
          Login
        </Button>

        <router-link to="/auth/signup" class="w-full relative mt-8 block text-blue-900 hover:underline" >
          No account yet ? create one
        </router-link>
      </Form>
    </div>
  </div>
</template>
