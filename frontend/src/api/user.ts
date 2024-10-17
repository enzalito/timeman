import { z } from "zod"

export const roles = ["employee", "manager"] as const
export const role = z.enum(roles)

export const user = z.object({
  id: z.number().min(1),
  username: z.string(),
  email: z.string().email(),
  type: role
})
export type User = z.infer<typeof user>

export const userRequest = z.object({
  user: user.omit({ id: true })
})
export type UserRequest = z.infer<typeof userRequest>

export const userRequestPartial = z.object({
  user: user.omit({ id: true }).partial()
})
export type UserRequestPartial = z.infer<typeof userRequestPartial>

export const userResponse = z.object({
  data: user
})
export type UserResponse = z.infer<typeof userResponse>

export async function getUser(user: UserRequestPartial): Promise<UserResponse>
export async function getUser(userId: number): Promise<UserResponse>
export async function getUser(user: number | UserRequestPartial): Promise<UserResponse> {
  if (typeof user === "number") {
    const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/users/${user}`, {
      method: "GET"
    })
    return await response.json()
  }

  for (let param in user.user) {
    let key = param as keyof typeof user.user
    if (user.user[key] === undefined) {
      delete user.user[key]
    }
  }
  const params = new URLSearchParams(user.user)
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/users?${params}`, {
    method: "GET"
  })
  return await response.json()
}

export async function createUser(user: UserRequest): Promise<UserResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/users`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(user)
  })
  return await response.json()
}

export async function updateUser(user: UserRequest): Promise<UserResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/users`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(user)
  })
  return await response.json()
}

export async function deleteUser(userId: number) {
  await fetch(`${import.meta.env.VITE_BACKEND_URL}/users/${userId}`, {
    method: "DELETE"
  })
}
