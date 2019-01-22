"""
    Thirty360Excel()

**30/360* day count convention, as computed via Microsoft Excel `YEARFRAC` with the basis option of `0`.

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

