import type { WorkingTime } from "@/api/workingTime"
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function getCurrentWeekText(todayDate?: Date) {
  // Get today's date

  let today = todayDate

  if (today === undefined) {
    today = new Date()
  }

  // Calculate the start of the week (Monday)
  const startOfWeek = new Date(today)
  startOfWeek.setDate(today.getDate() - today.getDay() + 1) // Set to Monday

  // Calculate the end of the week (Sunday)
  const endOfWeek = new Date(startOfWeek)
  endOfWeek.setDate(startOfWeek.getDate() + 6) // Add 6 days for Sunday

  const endOfWeekFriday = new Date(startOfWeek)
  endOfWeekFriday.setDate(startOfWeek.getDate() + 4) // Add 4 days for Friday

  // Format the dates as "DD.MM"
  const formatDate = (date: Date) => {
    const day = String(date.getDate()).padStart(2, "0")
    const month = String(date.getMonth() + 1).padStart(2, "0") // Months are 0-based
    return `${day}/${month}`
  }

  const formattedStart = formatDate(startOfWeek)
  const formattedEnd = formatDate(endOfWeek)
  const formattedEndFriday = formatDate(endOfWeekFriday)

  // Return the formatted week range
  return {
    startOfWeek: formattedStart,
    friday: formattedEndFriday,
    sunday: formattedEnd
  }
}

export function formatDateTime(date: Date) {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, "0") // Months are 0-based
  const day = String(date.getDate()).padStart(2, "0")
  const hours = String(date.getHours()).padStart(2, "0")
  const minutes = String(date.getMinutes()).padStart(2, "0")
  const seconds = String(date.getSeconds()).padStart(2, "0")
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

export function getCurrentWeekRange() {
  // Get today's date
  const today = new Date()

  // Calculate the start of the week (Monday at 00:00:00)
  const startOfWeek = new Date(today)
  startOfWeek.setDate(today.getDate() - today.getDay() + 1) // Set to Monday
  startOfWeek.setHours(0, 0, 0, 0) // Set time to 00:00:00

  // Calculate the end of the week (Friday at 23:59:59)
  const endOfWeek = new Date(startOfWeek)
  endOfWeek.setDate(startOfWeek.getDate() + 4) // Move to Friday
  endOfWeek.setHours(23, 59, 59, 999) // Set time to 23:59:59

  

  // Return the formatted week range
  return { start: startOfWeek, end: endOfWeek }
  
}

export function getCurrentWeekRangeStr() {
  const {start, end} = getCurrentWeekRange()
  return {start: formatDateTime(start), end: formatDateTime(end)}
}

const msToHrs = (ms: number) => ms / (1000 * 60 * 60)
const getPeriodDuration = (start: Date, end: Date) => {
  const eventDurationInMs = end.getTime() - start.getTime()
  return msToHrs(eventDurationInMs)
}

// Function to calculate hours for today's events and other events
export function getTodayWorkingTimesHours(workingTimes: WorkingTime[]): {
  hoursToday: number
  hoursOtherEvents: number
} {
  const now = new Date()
  const midnight = new Date(now)
  midnight.setHours(0, 0, 0, 0) // Set to today's midnight

  let totalHoursToday = 0
  let totalHoursOtherEvents = 0

  workingTimes.forEach((workingTime) => {
    const eventStart = new Date(workingTime.start)
    const eventEnd = new Date(workingTime.end)

    // Calculate event duration in hours
    const eventDurationInHours = getPeriodDuration(eventStart, eventEnd)

    if (eventEnd >= midnight && eventStart <= now) {
      // Event spans into today
      if (eventStart < midnight && eventEnd > midnight) {
        // Case: Event started before midnight and ends today
        // Part of the event that belongs to today
        const partTodayInHours = getPeriodDuration(midnight, eventEnd)

        // Part of the event that belongs to yesterday (or other past days)
        const partBeforeTodayInHours = getPeriodDuration(eventStart, midnight)

        totalHoursToday += partTodayInHours
        totalHoursOtherEvents += partBeforeTodayInHours
      } else {
        // Case: Event fully happens today (00:00 to now)
        const effectiveStart = eventStart < midnight ? midnight : eventStart
        const effectiveEnd = eventEnd > now ? now : eventEnd

        const diffInHours = getPeriodDuration(effectiveStart, effectiveEnd)

        totalHoursToday += diffInHours
      }
    } else {
      // Event is fully outside of today
      totalHoursOtherEvents += eventDurationInHours
    }
  })

  return {
    hoursToday: totalHoursToday,
    hoursOtherEvents: totalHoursOtherEvents
  }
}

export function convertNumberToHours(hours: number) {
  const wholeHours = Math.floor(hours) // Get the integer part (hours)
  const minutes = Math.round((hours - wholeHours) * 60) // Get the decimal part and convert to minutes

  return {
    hours: wholeHours,
    minutes
  }
}
