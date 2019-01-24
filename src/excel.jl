module Excel

using ..DayCounts, ..Dates

"""
    Excel.Thirty360()

Excel Basis = 0 or omitted

**US (NASD) 30/360** day count convention, as computed via Microsoft Excel `YEARFRAC` with the basis option of `0`.

This differs from [`Thirty360`](@ref) when:
*  if the start date is the last day of February, then
  -  ``d_1`` is 30, and
  - if the end date is also the last day of February ``d_2`` is also 30.

# Reference
- [Microsoft Excel `YEARFRAC` function](https://support.office.com/en-us/article/yearfrac-function-3844141e-c76d-4143-82b6-208454ddc6a8)
- [David A. Wheeler (2008) "YEARFRAC Incompatibilities between Excel 2007 and OOXML (OXML), and the Definitions Actually Used by Excel 2007"](https://dwheeler.com/yearfrac/excel-ooxml-yearfrac.pdf)
"""
struct Thirty360 <: DayCounts.DayCount end
function DayCounts.yearfrac(startdate::Date, enddate::Date, dc::Thirty360)
    if startdate > enddate
        return -yearfrac(enddate, startdate, dc)
    end
    
    y1 = year(startdate)
    y2 = year(enddate)
    m1 = month(startdate)
    m2 = month(enddate)
    d1 = day(startdate)
    d2 = day(enddate)
    if d1 >= 30
        d1 = 30
        if d2 >= 30
            d2 = 30
        end
    elseif m1 == 2 && startdate == lastdayofmonth(startdate)
        d1 = 30
        if m2 == 2 && enddate == lastdayofmonth(enddate)
            d2 = 30
        end
    end
    return DayCounts.thirty360(y2-y1,m2-m1,d2-d1)
end
DayCounts.yearfrac(startdate::Date, enddate::Date) = DayCounts.yearfrac(startdate::Date, enddate::Date, Thirty360())

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

"""
    Excel.Actual360()

Excel Basis = 2

Same as DayCounts.Actual360.

**Actual/360** day count convention.

The year fraction is computed as:
```math
\\frac{\\text{# of days}}{360}
```

# Reference
 - 2006 ISDA definitions, §4.16 (e)

"""
const Actual360 = DayCounts.Actual360

"""
    Excel.Actual365()

Excel Basis = 3

Same as DayCounts.Actual365Fixed.

**Actual/365 (Fixed)** day count convention.

The year fraction is computed as:
```math
\\frac{\\text{# of days}}{365}
```

# Reference
 - 2006 ISDA definitions, §4.16 (d)
"""
const Actual365 = DayCounts.Actual365Fixed

"""
    Excel.ThirtyE360()

Excel Basis = 4

Same as DayCounts.ThirtyE360.

**30E/360** or **Eurobond Basis** day count convention.

The year fraction is computed as:
```math
\\frac{360 \\times (y_2 - y_1) + 30 \\times (m_2 - m_1) + (d_2 - d_1)}{360}
```
where
- ``y_1`` and ``y_2`` are the years of the start and end date, respectively.
- ``m_1`` and ``m_2`` are the months of the start and end date, respectively.
- ``d_1`` is the day of the month at the start date, unless it is 31st day of the month,
  in which case it is 30.
- ``d_2`` is the day of the month at the end date,  unless it is 31st day of the month,
  in which case it is 30.

# Reference
 - 2006 ISDA definitions, §4.16 (g)
"""
const ThirtyE360 = DayCounts.ThirtyE360

end