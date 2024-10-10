import { ref } from "vue"
import { defineStore } from "pinia"

import type { UserResponse } from "@/api/user"

export const useUserStore = defineStore("user", () => {
  const user = ref<UserResponse | null>()

  function set(newUser: UserResponse) {
    user.value = newUser
  }

  function unset() {
    user.value = null
  }

  return { user, set, unset }
})
