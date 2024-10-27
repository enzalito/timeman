import HomePage from "@/components/pages/HomePage.vue"
import StatsPage from "@/components/pages/StatsPage.vue"
import LoginPage from "@/components/pages/LoginPage.vue"
import UsersPage from "@/components/pages/UsersPage.vue"
import SignUpPage from "@/components/pages/SignUpPage.vue"
import ProfilePage from "@/components/pages/ProfilePage.vue"

import { createRouter, createWebHistory } from "vue-router"
import { useUserStore } from "@/stores/user"
import Cookies from "js-cookie"
import { jwtDecode } from "jwt-decode"
import { currentUser } from "@/api/sessions"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: "/", name: "home", component: HomePage },
    { path: "/stats", name: "stats", component: StatsPage },
    { path: "/users", name: "users", component: UsersPage },
    { path: "/profile", name: "profile", component: ProfilePage },
    { path: "/auth/login", name: "login", component: LoginPage },
    { path: "/auth/signup", name: "signup", component: SignUpPage }
  ]
})

router.beforeEach(async (to, from) => {
  const user = useUserStore()

  const authRoutes = ["/auth/login", "/auth/signup"]

  if (authRoutes.includes(to.path)) {
    return
  }

  try {
    const { data } = await currentUser()

    if (!data || Object.keys(data).length < 1) {
      throw new Error("User not found")
    }
    user.set(data)
  } catch (error) {
    return { name: "login" }
  }
})

export default router
