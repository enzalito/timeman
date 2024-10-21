import { z } from "zod"
import { type Clock } from "./clock"
import { type WorkingTime } from "./workingTime"

export const roles = ["employee", "manager"] as const
export const role = z.enum(roles)

export const user = z.object({
  id: z.number().min(1),
  username: z.string(),
  email: z.string().email(),
  role: role
})
export type User = z.infer<typeof user>

export type UserWithRelations = User & {
  clock: Clock
  workingTimes: WorkingTime[]
}
export type UserWithClock = Omit<UserWithRelations, "workingTimes">
export type UserWithWorkingTimes = Omit<UserWithRelations, "clock">
export type GenericUser = User | UserWithClock | UserWithWorkingTimes | UserWithRelations

export const userRequest = z.object({
  user: user.omit({ id: true, role: true })
})
export type UserRequest = z.infer<typeof userRequest>

export const userRequestPartial = z.object({
  user: user.omit({ id: true, role: true }).partial()
})
export type UserRequestPartial = z.infer<typeof userRequestPartial>

export type UserResponse = {
  data: User
}

export type UserBulkResponse = {
  data: User[]
}

export async function getUser(id: number): Promise<UserResponse | UserBulkResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/users/${id}`, {
    method: "GET"
  })
  return await response.json()
}

export async function getUsers(user: UserRequestPartial): Promise<UserBulkResponse> {
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
