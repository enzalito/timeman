<script setup lang="ts">
  import Logo from "@/components/layout/Logo.vue"
  import { Form } from "vee-validate";
  import { Button } from "../ui/button";

  import { toTypedSchema } from "@vee-validate/zod";
  import { userLogin, type UserLogin } from "@/api/user";
  import { useUserStore } from "@/stores/user";
  import AuthFormFields from "../AuthFormFields.vue";
  import { login } from "@/api/sessions";
  import router from "@/router";
  import { useRoute } from "vue-router";
  import { ref } from "vue";

  const userStore = useUserStore()


  const error = ref<string | null>("")

  async function handleSubmit(user: UserLogin) {
    try {
      const {data, res} = await login(user)

      if (res.status === 401 && "error" in data && data.error === "Invalid credentials") {
        error.value = "Invalid username or password"
        return
      }
      if (!("data" in data)) {
        return
      }
      userStore.set(data.data)

      router.push({name: 'home'})

    } catch (error) {
      console.error('Error when logging in');
    }

  }

  const route = useRoute()

  const initialUsername = route.query.username ?? null


  const formSchema = toTypedSchema(userLogin)
</script>

<template>
  <div class="grid place-items-center h-full">
    <div class="w-[86%] sm:w-[66%] md:w-[30%] max-w-[460px]">
      <Logo class="mx-auto mb-16 w-[60%]"/>

      <Form class="space-y-6" :initial-values="{user: {username: initialUsername}}" :validation-schema="formSchema" @submit="(data) => handleSubmit(data as UserLogin)">
        <AuthFormFields :includeFields="['username', 'password']"/>

        <div>
          <Button type="submit" variant="secondary" class="w-full border-slate-200 border">
            Login
          </Button>
          <p v-if="error" class="text-red-600">{{ error }}</p>
        </div>


        <router-link to="/auth/signup" class="w-full relative mt-8 block text-blue-900 hover:underline" >
          No account yet ? create one
        </router-link>
      </Form>
    </div>
  </div>
</template>
