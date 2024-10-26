import { getLocalTimeZone } from "@internationalized/date"
import { type WorkingTime } from "@/api/working-time"
import { filterWorkingHours, type DateRange, type TimeRange } from "@/lib/utils"

export function getFilteredTotalHours(
  workingTimes: WorkingTime[] | undefined,
  range: DateRange
): number {
  const getHourDuration = (timeRange: TimeRange) => {
    return (
      (timeRange.end.toDate(getLocalTimeZone()).getTime() -
        timeRange.start.toDate(getLocalTimeZone()).getTime()) /
      3600000
    )
  }

  let total = 0
  filterWorkingHours(workingTimes, range, (_, timeRange) => {
    total += getHourDuration(timeRange)
  })

  return total
}
