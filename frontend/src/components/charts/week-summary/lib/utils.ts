import { CalendarDateTime, getLocalTimeZone, toCalendarDateTime } from "@internationalized/date"
import { type WorkingTime } from "@/api/workingTime"
import { parseDateTime as parseDateTimeStr, type DateRange } from "@/lib/utils"

export function getFilteredTotalHours(
  workingTimes: WorkingTime[] | undefined,
  range: DateRange
): number {
  if (!workingTimes) {
    return 0
  }

  const getHourDuration = (start: CalendarDateTime, end: CalendarDateTime) => {
    return (
      (end.toDate(getLocalTimeZone()).getTime() - start.toDate(getLocalTimeZone()).getTime()) /
      3600000
    )
  }

  let total = 0
  for (let workingTime of workingTimes) {
    const workingTimeStart = parseDateTimeStr(workingTime.start)
    const workingTimeEnd = parseDateTimeStr(workingTime.end)
    if (workingTimeStart.compare(range.start) >= 0 && workingTimeStart.compare(range.end) <= 0) {
      if (workingTimeEnd.compare(range.start) >= 0 && workingTimeEnd.compare(range.end) <= 0) {
        total += getHourDuration(workingTimeStart, workingTimeEnd)
        continue
      }
      total += getHourDuration(workingTimeStart, toCalendarDateTime(range.end))
      continue
    }
    if (workingTimeEnd.compare(range.start) >= 0 && workingTimeEnd.compare(range.end) <= 0) {
      total += getHourDuration(toCalendarDateTime(range.start), workingTimeEnd)
    }
    if (workingTimeStart.compare(range.start) <= 0 && workingTimeEnd.compare(range.end) >= 0) {
      total += getHourDuration(toCalendarDateTime(range.start), toCalendarDateTime(range.end))
    }
  }

  return total
}
