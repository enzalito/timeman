import { ref } from "vue"
import { defineStore } from "pinia"

import type { User } from "@/api/user"

export const useUserStore = defineStore("user", () => {
  const user = ref<User | null>()

  function set(newUser: User) {
    user.value = newUser
  }

  function unset() {
    user.value = undefined
  }

  return { user, set, unset }
})
