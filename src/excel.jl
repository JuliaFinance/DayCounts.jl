"""
    Thirty360Excel()

**US (NASD) 30/360** day count convention, as computed via Microsoft Excel `YEARFRAC` with the basis option of `0`.

This differs from [`Thirty360`](@ref) when:
*  if the start date is the last day of February, then
  -  ``d_1`` is 30, and
  - if the end date is also the last day of February ``d_2`` is also 30.

# Reference
- [Microsoft Excel `YEARFRAC` function](https://support.office.com/en-us/article/yearfrac-function-3844141e-c76d-4143-82b6-208454ddc6a8)
- [David A. Wheeler (2008) "YEARFRAC Incompatibilities between Excel 2007 and OOXML (OXML), and the Definitions Actually Used by Excel 2007"](https://dwheeler.com/yearfrac/excel-ooxml-yearfrac.pdf)
"""
struct Thirty360Excel <: DayCount
end
function yearfrac(startdate::Date, enddate::Date, dc::Thirty360Excel)
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
    return thirty360(y2-y1,m2-m1,d2-d1)
end

"""
    ActualActualExcel()

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
struct ActualActualExcel <: DayCount
end
function yearfrac(startdate::Date, enddate::Date, dc::ActualActualExcel)
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
        return Dates.value(enddate-startdate) / mean(daysinyear, y1:y2)
    end
end
