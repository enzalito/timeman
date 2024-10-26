import { fetchWithOfflineSupport } from "@/lib/offline-queue"
import { z } from "zod"

export const clock = z.object({
  status: z.boolean(),
  time: z.string().regex(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/),
  user_id: z.number().min(1)
})
export type Clock = z.infer<typeof clock>

export const clockRequest = z.object({
  clock: clock.omit({ user_id: true }).extend({ description: z.string().optional() })
})
export type ClockRequest = z.infer<typeof clockRequest>

export type ClockResponse = {
  data: Clock
}

export async function createClock(userId: number, clock: ClockRequest): Promise<ClockResponse> {
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/clocks/${userId}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(clock)
    }
  )
  return await response.json()
}

export async function getClock(userId: number): Promise<ClockResponse> {
  const response = await fetchWithOfflineSupport(
    `${import.meta.env.VITE_BACKEND_URL}/clocks/${userId}`,
    {
      method: "GET"
    }
  )
  return await response.json()
}
