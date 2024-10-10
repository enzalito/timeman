import { z } from "zod"

export const userRequest = z.object({
  username: z.string(),
  email: z.string().email()
})
export type UserRequest = z.infer<typeof userRequest>

export const userResponse = userRequest.extend({
  id: z.number().min(1)
})
export type UserResponse = z.infer<typeof userResponse>

export async function getUser(userId: number): Promise<UserResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/${userId}`, {
    method: "GET"
  })
  return await response.json()
}

export async function createUser(user: UserRequest): Promise<UserResponse> {
  const response = await fetch(import.meta.env.VITE_BACKEND_URL, {
    method: "POST",
    body: JSON.stringify(user)
  })
  return await response.json()
}

export async function updateUser(user: UserRequest): Promise<UserResponse> {
  const response = await fetch(import.meta.env.VITE_BACKEND_URL, {
    method: "PUT",
    body: JSON.stringify(user)
  })
  return await response.json()
}

export async function deleteUser(userId: number) {
  await fetch(`${import.meta.env.VITE_BACKEND_URL}/${userId}`, {
    method: "DELETE"
  })
}
