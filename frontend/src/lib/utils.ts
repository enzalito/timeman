import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"
import {
  today,
  startOfWeek,
  endOfWeek,
  getLocalTimeZone,
  CalendarDate,
  CalendarDateTime
} from "@internationalized/date"
import { type WorkingTime } from "@/api/working-time"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export type DateRange = { start: CalendarDate; end: CalendarDate }
export type TimeRange = { start: CalendarDateTime; end: CalendarDateTime }

export function getWeekRange(date: CalendarDate = today(getLocalTimeZone())): DateRange {
  return {
    start: startOfWeek(date, "fr-FR"),
    end: endOfWeek(date, "fr-FR").add({ days: 1 })
  }
}

export function getWeekRangeStr(date: CalendarDate = today(getLocalTimeZone())): {
  start: string
  end: string
} {
  const { start, end } = getWeekRange(date)
  return {
    start: formatDate(start),
    end: formatDate(end)
  }
}

export function formatDate(date: CalendarDate): string {
  const year = String(date.year).padStart(4, "0")
  const month = String(date.month).padStart(2, "0")
  const day = String(date.day).padStart(2, "0")
  return `${year}-${month}-${day} 00:00:00`
}

export function formatDateTime(date: Date): string {
  const year = String(date.getFullYear()).padStart(4, "0")
  const month = String(date.getMonth()).padStart(2, "0")
  const day = String(date.getDay()).padStart(2, "0")
  const hour = String(date.getHours()).padStart(2, "0")
  const minute = String(date.getMinutes()).padStart(2, "0")
  const second = String(date.getSeconds()).padStart(2, "0")
  return `${year}-${month}-${day} ${hour}:${minute}:${second}`
}

export function parseDateTime(date: string): CalendarDateTime {
  const year = +date.substring(0, 4)
  const month = +date.substring(5, 7)
  const day = +date.substring(8, 10)
  const hour = +date.substring(11, 13)
  const min = +date.substring(14, 16)
  const sec = +date.substring(17, 19)
  return new CalendarDateTime(year, month, day, hour, min, sec)
}

export function formatHours(hours: number): string {
  const wholeHours = Math.floor(hours) // Get the integer part (hours)
  const minutes = Math.round((hours - wholeHours) * 60) // Get the decimal part and convert to minutes

  return `${wholeHours}h${minutes}m`
}

export function filterWorkingHours(
  workingTimes: WorkingTime[] | undefined,
  range: DateRange,
  callback: (wt: WorkingTime, tr: TimeRange) => void
) {
  if (!workingTimes) {
    return 0
  }

  for (let workingTime of workingTimes) {
    const timeRange = {
      start: parseDateTime(workingTime.start),
      end: parseDateTime(workingTime.end)
    }
    // working times spanning over multiple days aren't possible (backend garantee)
    // so handling this case only should be enought
    if (
      timeRange.start.compare(range.start) >= 0 &&
      timeRange.start.compare(range.end) <= 0 &&
      timeRange.end.compare(range.start) >= 0 &&
      timeRange.end.compare(range.end) <= 0
    ) {
      callback(workingTime, timeRange)
    }
  }
}
