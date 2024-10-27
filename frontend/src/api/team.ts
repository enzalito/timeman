import { z } from "zod"
import {
  type GenericUser,
  type User,
  type UserWithClock,
  type UserWithWorkingTimes,
  type UserWithRelations
} from "@/api/user"
import { toQueryParams } from "@/api/lib/utils"
import { fetchWithOfflineSupport } from "@/lib/offline-queue"

export const team = z.object({
  id: z.number().min(1),
  name: z.string()
})
export type Team = z.infer<typeof team>

export type TeamWithUsers<T = GenericUser> = Team & {
  users: T[]
}

export const teamRequest = z.object({
  team: team.omit({ id: true })
})
export type TeamRequest = z.infer<typeof teamRequest>

export const teamRequestPartial = z.object({
  team: team.omit({ id: true }).partial()
})
export type TeamRequestPartial = z.infer<typeof teamRequestPartial>

export const teamRequestOptions = z.object({
  withUsers: z.optional(z.literal(true)),
  withWorkingTimes: z.optional(z.literal(true)),
  withClocks: z.optional(z.literal(true))
})
export type TeamRequestOptions = z.infer<typeof teamRequestOptions>

export type TeamResponse = {
  data: Team
}

export type TeamBulkResponse = {
  data: Team[]
}

export type TeamWithUsersResponse<T = GenericUser> = {
  data: TeamWithUsers<T>
}

export async function getTeam(id: number): Promise<TeamResponse>
export async function getTeam(
  id: number,
  options: { withUsers: true }
): Promise<TeamWithUsersResponse<User>>
export async function getTeam(
  id: number,
  options: { withUsers: true; withClock: true }
): Promise<TeamWithUsersResponse<UserWithClock>>
export async function getTeam(
  id: number,
  options: { withUsers: true; withWorkingTimes: true }
): Promise<TeamWithUsersResponse<UserWithWorkingTimes>>
export async function getTeam(
  id: number,
  options: { withUsers: true; withClock: true; withWorkingTimes: true }
): Promise<TeamWithUsersResponse<UserWithRelations>>
export async function getTeam(
  id: number,
  options?: TeamRequestOptions
): Promise<TeamResponse | TeamWithUsersResponse> {
  const params = toQueryParams(options)
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/teams/${id}?${params}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}

export async function getTeams(team: TeamRequestPartial): Promise<TeamBulkResponse> {
  const params = toQueryParams(team.team)
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/teams?${params}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}

export async function createTeam(team: TeamRequest): Promise<TeamResponse> {
  const response = await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/teams`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(team)
  })
  return await response.json()
}

export async function updateTeam(id: number, team: TeamRequest): Promise<TeamResponse> {
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/teams/${id}`,
    {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(team)
    }
  )
  return await response.json()
}

export async function deleteTeam(id: number) {
  await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/teams/${id}`, {
    method: "DELETE"
  })
}

export async function addUser(id: number, userId: number) {
  await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/teams/${id}/user/${userId}`, {
    method: "POST"
  })
}

export async function removeUser(id: number, userId: number) {
  await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/teams/${id}/user/${userId}`, {
    method: "DELETE"
  })
}
