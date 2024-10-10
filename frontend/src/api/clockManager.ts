import { z } from "zod"

export const naiveDateTimeSchema = z.string().refine(
  (val) => {
    const regex = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/
    return regex.test(val)
  },
  {
    message: "Invalid datetime format, expected 'YYYY-MM-DD HH:MM:SS'"
  }
)

export const clockRequest = z.object({
  clock: z.object({
    status: z.boolean(),
    time: naiveDateTimeSchema,
    user_id: z.number().min(1)
  })
})
export type ClockRequest = z.infer<typeof clockRequest>
export const clockResponse = clockRequest

export type ClockResponse = z.infer<typeof clockResponse>

export async function createClock(clock: ClockRequest): Promise<ClockResponse> {
  try {
    const userId = clock.clock.user_id
    console.log(JSON.stringify(clock))
    const response = await fetch(import.meta.env.VITE_BACKEND_URL + `/clocks/${userId}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(clock)
    })
    return await response.json()
  } catch (error) {
    console.log(error)
    throw new Error("Error when creating clock")
  }
}
export async function getClocks(userId: number): Promise<ClockResponse> {
  try {
    const response = await fetch(import.meta.env.VITE_BACKEND_URL + `/clocks/${userId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json"
      }
    })
    return await response.json()
  } catch (error) {
    throw new Error("Error when getting clocks from user")
  }
}
