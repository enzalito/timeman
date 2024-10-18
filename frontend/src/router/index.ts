import HomePage from "@/components/pages/HomePage.vue"
import StatsPage from "@/components/pages/StatsPage.vue"
import LoginPage from "@/components/pages/LoginPage.vue"
import ClockManager from "@/components/ClockManager.vue"
import UsersPage from "@/components/pages/UsersPage.vue"
import SignUpPage from "@/components/pages/SignUpPage.vue"
import ProfilePage from "@/components/pages/ProfilePage.vue"

import { createRouter, createWebHistory } from "vue-router"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: "/clock/:userid", component: ClockManager },
    { path: "/", component: HomePage },
    { path: "/stats", component: StatsPage },
    { path: "/users", component: UsersPage },
    { path: "/profile", component: ProfilePage },
    { path: "/auth/login", component: LoginPage },
    { path: "/auth/signup", component: SignUpPage }
  ]
})

export default router
