module Excel

using ..DayCounts, ..Dates

@doc (@doc DayCounts.ThirtyU360)
const Thirty360 = DayCounts.ThirtyU360

"""
    Excel.ActualActual()

Excel Basis = 1

**Actual/Actual** day count convention, as computed via Microsoft Excel `YEARFRAC` with the basis option of `1`.

The year fraction is
```math
\\frac{\\text{# of days}}{D}
```
where:
* if start date and end date are in the same calendar year, then ``D`` is the number of days in that calendar year,
* otherwise if the end date is less than or equal to one year after the start date, then
  - ``D = 366`` if the interval includes February 29 (including both the start and end dates), or
  - ``D = 365`` otherwise.
* otherwise it is the average length of the years included in the interval (this does not depend on where the start or end dates fall within those years).

# Reference
- [Microsoft Excel `YEARFRAC` function](https://support.office.com/en-us/article/yearfrac-function-3844141e-c76d-4143-82b6-208454ddc6a8)
- [David A. Wheeler (2008) "YEARFRAC Incompatibilities between Excel 2007 and OOXML (OXML), and the Definitions Actually Used by Excel 2007"](https://dwheeler.com/yearfrac/excel-ooxml-yearfrac.pdf)
"""
struct ActualActual <: DayCounts.DayCount end
function DayCounts.yearfrac(startdate::Date, enddate::Date, dc::ActualActual)
    if startdate > enddate
        return -yearfrac(enddate, startdate, dc)
    end
    y1 = year(startdate)
    y2 = year(enddate)
    if y1 == y2
        return Dates.value(enddate-startdate) / daysinyear(y1)
    elseif startdate + Year(1) >= enddate
        if (isleapyear(y1) && startdate <= Date(y1,2,29)) ||
            (isleapyear(y2) && Date(y2,2,29) <= enddate)
            return Dates.value(enddate-startdate) / 366
        else
            return Dates.value(enddate-startdate) / 365
        end
    else
        yrange = y1:y2
        return Dates.value(enddate-startdate) / (sum(daysinyear, yrange) / length(yrange))
    end
end

@doc (@doc DayCounts.Actual360)
const Actual360 = DayCounts.Actual360

@doc (@doc DayCounts.Actual365Fixed)
const Actual365 = DayCounts.Actual365Fixed

@doc (@doc DayCounts.ThirtyE360)
const ThirtyE360 = DayCounts.ThirtyE360

end