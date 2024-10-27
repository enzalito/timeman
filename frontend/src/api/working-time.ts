import { fetchWithOfflineSupport } from "@/lib/offline-queue"
import { z } from "zod"

const dateTimeRegex = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/

export const workingTime = z.object({
  id: z.number().min(1),
  user_id: z.string(),
  start: z.string().regex(dateTimeRegex),
  end: z.string().regex(dateTimeRegex),
  description: z.string(),
  period: z.enum(["day", "night"])
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

export type WorkingTimeResponse = {
  data: WorkingTime
}

export type WorkingTimeBulkResponse = {
  data: WorkingTime[]
}

export async function getWorkingTimes(
  userId: number,
  startDate?: string,
  endDate?: string
): Promise<WorkingTimeBulkResponse> {
  const queryParams = startDate && endDate ? `?start=${startDate}&end=${endDate}` : ""

  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/workingtime/${userId}${queryParams}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}

export async function getWorkingTime(userId: number, woId: number): Promise<WorkingTimeResponse> {
  const response = await fetchWithOfflineSupport(
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
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/workingtime/${userId}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(workingTime)
    }
  )
  return await response.json()
}

export async function updateWorkingTime(
  workingTime: WorkingTimeRequestPartial,
  id: number
): Promise<WorkingTimeResponse> {
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/workingtime/${id}`,
    {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(workingTime)
    }
  )
  return await response.json()
}

export async function deleteWorkingTime(id: number) {
  await fetchWithOfflineSupport(`${import.meta.env.VITE_BACKEND_URL}/workingtime/${id}`, {
    method: "DELETE"
  })
}
