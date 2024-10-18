import { z } from "zod"

export const clock = z.object({
  status: z.boolean(),
  time: z.string().regex(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/),
  user_id: z.number().min(1)
})
export type Clock = z.infer<typeof clock>

export const clockRequest = z.object({
  clock: clock.omit({ user_id: true })
})
export type ClockRequest = z.infer<typeof clockRequest>

export type ClockResponse = {
  data: Clock
}

export type ClockBulkResponse = {
  data: Clock[]
}

export async function createClock(userId: number, clock: ClockRequest): Promise<ClockResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/clocks/${userId}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(clock)
  })
  return await response.json()
}

export async function getClocks(userId: number): Promise<ClockBulkResponse> {
  const response = await fetch(`${import.meta.env.VITE_BACKEND_URL}/clocks/${userId}`, {
    method: "GET"
  })
  return await response.json()
}
