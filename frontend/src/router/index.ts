import ClockManager from "@/components/ClockManager.vue"
import { createRouter, createWebHistory } from "vue-router"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [{ path: "/clock/:userid", component: ClockManager }]
})

export default router
