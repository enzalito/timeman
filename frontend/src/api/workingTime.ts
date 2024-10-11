import { z } from "zod"

export const workingTime = z.object({
  id: z.number().min(1),
  user_id: z.string(),
  start: z.string().regex(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/),
  end: z.string().regex(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/)
})
export type WorkingTime = z.infer<typeof workingTime>

export const workingTimeRequest = z.object({
  working_time: workingTime.omit({ id: true, user_id: true })
})
export type WorkingTimeRequest = z.infer<typeof workingTimeRequest>

export const workingTimeRequestPartial = z.object({
  working_time: workingTime.omit({ id: true }).partial()
})
export type WorkingTimeRequestPartial = z.infer<typeof workingTimeRequestPartial>

export const workingTimeResponse = z.object({
  data: workingTime
})
export type WorkingTimeResponse = z.infer<typeof workingTimeResponse>

export const workingTimeBulkResponse = z.object({
  data: z.array(workingTime)
})
export type WorkingTimeBulkResponse = z.infer<typeof workingTimeBulkResponse>

export async function getWorkingTimes(userId: number): Promise<WorkingTimeBulkResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingtime/${userId}`, {
    method: "GET"
  })
  return await response.json()
}

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
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingtime/${userId}`, {
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
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingtime/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(workingTime)
  })
  return await response.json()
}

export async function deleteWorkingTime(id: number) {
  await fetch(`${import.meta.env.VITE_BACKEND_URL}/workingtime/${id}`, {
    method: "DELETE"
  })
}
