<script setup lang="ts">
import { useForm } from 'vee-validate';
import Card from './Card.vue';
import { Button } from './ui/button';
import { z } from 'zod';
import { passwordValidation, updatePassword, type User } from '@/api/user';
import { ref } from 'vue';
import { toTypedSchema } from '@vee-validate/zod';
import { FormControl, FormField, FormLabel, FormMessage } from './ui/form';
import FormItem from './ui/form/FormItem.vue';
import { Input } from './ui/input';
import { useToast } from './ui/toast';

const { user } = defineProps<{user: User}>()


const { handleSubmit, resetForm, isFieldDirty, setFieldError } = useForm({

  validationSchema: toTypedSchema(z.object({
    password: z.object({
      current: z.string().min(1),
      new: z.string().regex(passwordValidation, 'Password must contain at least one special character, one uppercase and one lowercase letter'),
      confirmation: z.string().min(1)
    })
  }).refine((data) => data.password.new === data.password.confirmation, {
        message: "Passwords don't match",
        path: ["password.confirmation"],
    })),
})

const updateError = ref<string | null>(null)

const {toast} = useToast()

const onSubmit = handleSubmit(async ({password: {current, new: new_password}}) => {
  try {

    const res = await updatePassword({current_password: current, new_password, username: user.username })


    if (res.status === 200) {
      toast({
        description: "Password successfully changed",
        duration: 3000
      })
      resetForm()
    } else if(res.status === 401) {
      setFieldError('password.current', "Cannot authenticate you")
    }



    updateError.value = null
  } catch (error) {
    updateError.value = "Error when updating your password"
    console.error("update password: ", error);
  }
})



</script>

<template>
  <Card title="Password" class="md:w-[460px] mx-auto md:mx-0">
    <form class="space-y-6" @submit="onSubmit">

      <FormField v-slot="{ componentField }" name="password.current">
        <FormItem class="space-y-1">
          <FormLabel>Current password</FormLabel>
          <FormControl>
            <Input type="password" placeholder="" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <FormField v-slot="{ componentField }" name="password.new">
        <FormItem class="space-y-1">
          <FormLabel>New password</FormLabel>
          <FormControl>
            <Input type="password" placeholder="" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>
      <FormField v-slot="{ componentField }" name="password.confirmation">
        <FormItem class="space-y-1">
          <FormLabel>Confirm password</FormLabel>
          <FormControl>
            <Input type="password" placeholder="" v-bind="componentField" />
          </FormControl>
          <FormMessage />
        </FormItem>
      </FormField>

      <Button type="submit" :disabled="!isFieldDirty('password')" class="w-full mt-10">
        Save
      </Button>

    </form>

  </Card>
</template>
