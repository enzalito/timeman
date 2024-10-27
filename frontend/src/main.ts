import { createApp } from "vue"
import { createPinia } from "pinia"

import "@/assets/index.css"
import App from "@/App.vue"
import router from "@/router"
import { offlineQueue } from "@/lib/offline-queue"
import { useUserStore } from "@/stores/user"

// Check environment and initialize accordingly
// @ts-expect-error
if (window.cordova) {
  // Mobile - wait for deviceready
  document.addEventListener("deviceready", launch, false)
} else {
  // Desktop - launch immediately
  launch()
}

function launch() {
  const app = createApp(App)

  app.use(createPinia())
  app.use(router)

  app.mount("#app")

  const userStore = useUserStore()
  userStore.set({
    id: 1,
    username: "Dude ManDude",
    email: "dude@man.dude",
    role: "manager",
    teams: [{ id: 10, name: "Dream team" }]
  })

  document.addEventListener("online", async () => {
    await offlineQueue.processQueue()
  })

  document.addEventListener("offline", () => {})
}
