import { z } from "zod"
import { type Clock } from "@/api/clock"
import { type WorkingTime } from "@/api/working-time"
import { fetchWithOfflineSupport } from "@/lib/offlineQueue"

export const roles = ["employee", "manager"] as const
export const role = z.enum(roles)
export type Role = z.infer<typeof role>

export const user = z.object({
  id: z.number().min(1),
  username: z.string(),
  email: z.string().email(),
  role: role,
  teams: z
    .object({
      id: z.number().min(1),
      name: z.string()
    })
    .array()
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

// Minimum 8 characters, at least one uppercase letter, one lowercase letter, and one special character
const passwordValidation = new RegExp(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[#?!@$%^&*-]).{8,}$/)

const hasPassword = z.object({
  password: z.string().min(1)
})
const hasPasswordWithRegex = z.object({
  password: z
    .string()
    .min(8, "Must have at least 8 characters")
    .regex(
      passwordValidation,
      "Password must contain at least one special character, one uppercase and one lowercase letter"
    )
})

export const userLogin = z.object({
  user: user.omit({ id: true, role: true, email: true, teams: true }).merge(hasPassword)
})
export type UserLogin = z.infer<typeof userLogin>

export const userSignup = z.object({
  user: user.omit({ id: true, role: true, teams: true }).merge(hasPasswordWithRegex)
})
export type UserSignup = z.infer<typeof userSignup>

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
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/users/${id}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}

export async function getUsers(user: UserSearchRequest): Promise<UserBulkResponse> {
  const params = new URLSearchParams(user.user)
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/users?${params}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}

export async function createUser(user: UserSignup): Promise<UserResponse> {
  const response = await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/users`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(user)
  })
  return await response.json()
}

export async function updateUser(user: UserRequest): Promise<UserResponse> {
  const response = await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/users`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(user)
  })
  return await response.json()
}

export async function deleteUser(userId: number) {
  await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/users/${userId}`, {
    method: "DELETE"
  })
}

export async function setRole(userId: number, role: UserRoleRequest) {
  await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/users/set_role/${userId}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(role)
  })
}
