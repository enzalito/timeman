<script setup lang="ts">
import { useForm } from 'vee-validate';
import AuthFormFields from './AuthFormFields.vue';
import Card from './Card.vue';
import { Button } from './ui/button';
import { z } from 'zod';
import { updateUser, type User } from '@/api/user';
import { ref } from 'vue';
import { toTypedSchema } from '@vee-validate/zod';


const { user } = defineProps<{user: User}>()

const { handleSubmit, setFieldValue, isFieldDirty } = useForm({
  initialValues: {
    user: {
      email: user?.email,
      username: user?.username
    }
  },
  validationSchema: toTypedSchema(z.object({
    user: z.object({
      email: z.string().email(),
      username: z.string().min(1)
    })
  })),
})

const updateError = ref<string | null>(null)

const onSubmit = handleSubmit(async (values) => {
  try {
    const res = await updateUser({user: {...values.user, role: user!.role}}, user.id)

    setFieldValue('user.email', res.data.email)
    setFieldValue('user.username', res.data.username)

    updateError.value = null
  } catch (error) {
    updateError.value = "Error when updating your informations"
    console.error("update account details: ", error);
  }
})


</script>

<template>
  <Card title="Account details" class="md:w-[380px] mx-auto md:mx-0">
    <form class="space-y-6" @submit="onSubmit">

      <AuthFormFields :include-fields="['username', 'email']"/>

      <Button type="submit" :disabled="!isFieldDirty('user')" class="w-full mt-10">
        Save
      </Button>

    </form>

  </Card>
</template>
