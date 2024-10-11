import { z } from "zod"

export const workingTime = z.object({
  id: z.number().min(1),
  start: z.string().min(1, "start date shouldn't be empty"),
  end: z.string().min(1, "start date shouldn't be empty"),
  user: z.string()
})
export type WorkingTime = z.infer<typeof workingTime>

export const workingTimeRequest = z.object({
  workingTime: workingTime.omit({ id: true })
})
export type WorkingTimeRequest = z.infer<typeof workingTimeRequest>

export const workingTimeRequestPartial = z.object({
  workingTime: workingTime.omit({ id: true }).partial()
})
export type WorkingTimeRequestPartial = z.infer<typeof workingTimeRequestPartial>

export const workingTimeResponse = z.object({
  data: workingTime
})
export type WorkingTimeResponse = z.infer<typeof workingTimeResponse>

export async function getWorkingTime(userId: number, woId: number): Promise<WorkingTimeResponse>
export async function getWorkingTime(userId: number, woId: number): Promise<WorkingTimeResponse> {
  const response = await fetch(
    `${import.meta.env.VITE_BACKEND_URL}/workingtime/${userId}/${woId}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}

export async function createWorkingTime(
  workingTime: WorkingTimeRequestPartial,
  userId: number
): Promise<WorkingTimeResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingTime/${userId}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(workingTime)
  })
  return await response.json()
}

export async function updateWorkingTime(
  workingTime: WorkingTimeRequestPartial,
  id: number
): Promise<WorkingTimeResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingTime/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(workingTime)
  })
  return await response.json()
}

export async function deleteWorkingTime(id: number) {
  await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingTime/${id}`, {
    method: "DELETE"
  })
}
