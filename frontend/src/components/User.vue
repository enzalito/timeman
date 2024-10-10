<script setup lang="ts">
import { ref } from "vue"
import { type TypedSchema } from "vee-validate"
import { vAutoAnimate } from "@formkit/auto-animate/vue"

import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { Collapsible, CollapsibleContent } from "@/components/ui/collapsible"
import { Card } from "@/components/ui/card"
import { Form } from "@/components/ui/form"
import type { SubmissionHandler } from "vee-validate"

defineProps<{
  greetingText: String
  formSchema: TypedSchema
  onSubmit: SubmissionHandler<any>
  submitText: String
}>()

const isOpen = ref(false)
const close = () => {
  isOpen.value = false
}
</script>

<template>
  <Card class="w-[500px]">
    <Collapsible v-model:open="isOpen" class="p-4">
      <div class="flex items-center justify-between space-x-4">
        <h2 class="text-l font-semibold">
          {{ greetingText }}
        </h2>
        <div class="flex items-center gap-2">
          <slot name="actions" :isOpen="isOpen"></slot>
        </div>
      </div>
      <CollapsibleContent class="pt-4 space-y-2">
        <Separator />
        <Form class="px-2 space-y-6" :validation-schema="formSchema" @submit="onSubmit">
          <div class="flex gap-4">
            <slot name="form-fields"></slot>
          </div>
          <div class="flex gap-2">
            <Button type="button" variant="outline" @click="close"> Cancel </Button>
            <Button type="submit">
              {{ submitText }}
            </Button>
          </div>
        </Form>
      </CollapsibleContent>
    </Collapsible>
  </Card>
</template>
