import { z } from "zod"
import { type Clock } from "./clock"
import { type WorkingTime } from "./workingTime"

export const roles = ["employee", "manager"] as const
export const role = z.enum(roles)
export type Role = z.infer<typeof role>

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
  user: user.omit({ id: true })
})
export type UserRequest = z.infer<typeof userRequest>

export const userSearchRequest = z.object({
  user: z.object({ username: z.string().optional() })
})
export type UserSearchRequest = z.infer<typeof userSearchRequest>

export const userRoleRequest = z.object({
  user: z.object({ role: role })
})
export type UserRoleRequest = z.infer<typeof userRoleRequest>

export type UserResponse = {
  data: User
}

export type UserBulkResponse = {
  data: User[]
}

export async function getUser(id: number): Promise<UserResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/users/${id}`, {
    method: "GET"
  })
  return await response.json()
}

export async function getUsers(user: UserSearchRequest): Promise<UserBulkResponse> {
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

export async function setRole(userId: number, role: UserRoleRequest) {
  await fetch(`${import.meta.env.VITE_BACKEND_URL}/users/set_role/${userId}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(role)
  })
}
