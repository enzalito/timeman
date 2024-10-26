import { fetchWithOfflineSupport } from "@/lib/offline-queue"
import type { UserLogin, UserResponse } from "./user"
import Cookies from "js-cookie"

type errorLogin = { error: "Invalid credentials" }

export async function login(
  user: UserLogin
): Promise<{ data: UserResponse | errorLogin; res: Response }> {
  const response = await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(user)
  })
  const data = await response.json()

  return {
    data,
    res: response
  }
}

export async function logout(): Promise<UserResponse> {
  const response = await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/logout`, {
    method: "POST"
  })
  Cookies.remove("auth_token")

  return await response.json()
}

export async function currentUser(): Promise<UserResponse> {
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/current_user`,
    {
      method: "POST"
    }
  )

  return await response.json()
}
