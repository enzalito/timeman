import { createApp } from "vue"
import { createPinia } from "pinia"

import "@/assets/index.css"
import App from "./App.vue"
import router from "./router"
import { offlineQueue } from "./lib/offlineQueue"

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

  document.addEventListener("online", async () => {
    await offlineQueue.processQueue()
  })

  document.addEventListener("offline", () => {})
}
