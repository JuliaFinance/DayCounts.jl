module DayCounts
# https://en.wikipedia.org/wiki/Day_count_convention
# https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf
# https://www.isda.org/2008/12/22/30-360-day-count-conventions/

using Dates
export yearfrac, Excel

"""
    yearfrac(startdate::Date, enddate::Date, dc::DayCount)

Compute the fractional number of years between `startdate` and `enddate`, according to the
[`DayCount` object](@ref daycount_types) `dc`.

- If `startdate == enddate`, then the result is zero.
- If `startdate > enddate`, then the result is `-yearfrac(enddate, startdate, dc)`.
"""
function yearfrac
end


abstract type DayCount end

"""
    Actual365Fixed() or Excel.Actual365

**Actual/365 (Fixed)** day count convention.

The year fraction is computed as:
```math
\\frac{\\text{# of days}}{365}
```

# Reference
 - 2006 ISDA definitions, §4.16 (d)
"""
struct Actual365Fixed <: DayCount end
const Actual365F = Actual365Fixed
function yearfrac(startdate::Date, enddate::Date, ::Actual365Fixed)
    return Dates.value(enddate-startdate)/365
end

"""
    Actual360()

**Actual/360** day count convention.

The year fraction is computed as:
```math
\\frac{\\text{# of days}}{360}
```

# Reference
 - 2006 ISDA definitions, §4.16 (e)

"""
struct Actual360 <: DayCount end
function yearfrac(startdate::Date, enddate::Date, ::Actual360)
    return Dates.value(enddate-startdate)/360
end


"""
    ActualActualISDA()

**Actual/Actual (ISDA)** day count convention.

The year fraction is computed as:
```math
\\frac{\\text{# of days in standard year}}{365} +
\\frac{\\text{# of days in leap year}}{366}
```

For the purposes of above, the start date is included and the end date is excluded.

# Reference
 - 2006 ISDA definitions, §4.16 (b)
"""
struct ActualActualISDA <: DayCount end
function yearfrac(startdate::Date, enddate::Date, dc::ActualActualISDA)
    if startdate > enddate
        return -yearfrac(enddate, startdate, dc)
    end
    startyear = year(startdate)
    endyear = year(enddate)
    if startyear == endyear
        return Dates.value(enddate - startdate) / daysinyear(startdate)
    else
        d1 = daysinyear(startyear)
        n1 = d1 - dayofyear(startdate) + 1
        d2 = daysinyear(endyear)
        n2 = dayofyear(enddate) - 1
        return n1/d1 + n2/d2 + (endyear - startyear - 1)
    end
end


"""
    ActualActualICMA(schedule::StepRange{Date,Month})

**Actual/Actual (ICMA)**, **Actual/Actual (ISMA)** or **ISMA-99** day count convention.

Note that this is dependent on the coupon or payment schedule of the underlying
security. This is provided via the `schedule` argument, currently only date ranges with
steps of months are supported.

The year fraction is computed as:
```math
\\sum_{\\text{schedule period}} \\frac{\\text{# of days in period}}{\\text{length of period} \\times \\text{periods per year}}
```

This ensures that:
* all days in a period are of equal length, and
* all periods are of equal length.

# Reference
 - 2006 ISDA definitions, §4.16 (c).
 - [ICMA Rule Book](https://www.isda.org/a/NIJEE/ICMA-Rule-Book-Rule-251-reproduced-by-permission-of-ICMA.pdf), Rule 251.1 (iii).
 - [EMU and Market Conventions: Recent Developments, ISDA - BS:9951.1](https://www.isda.org/a/AIJEE/1998-ISDA-memo-EMU-and-Market-Conventions-Recent-Developments.pdf), §4. The Actual/Actual Day Count Convention.
"""
struct ActualActualICMA{T<:AbstractVector{Date}} <: DayCount
    frequency::Int
    schedule::T
end
ActualActualICMA(schedule::StepRange{Date,Month}) = ActualActualICMA(Int(Month(12)/step(schedule)),schedule)
const ActualActualISMA = ActualActualICMA
const ISMA99 = ActualActualICMA

function yearfrac(startdate::Date, enddate::Date, dc::ActualActualICMA)
    if startdate > enddate
        return -yearfrac(enddate,startdate,dc)
    end
    startdate < first(dc.schedule) || enddate > last(dc.schedule) && error("The start and end dates must be contained within the scheduled dates.")

    schedule = dc.schedule

    periodfrac = 0.

    # Fraction of the last period
    istart = findlast(x -> x < enddate, schedule)
    periodfrac += schedule[istart+1] == enddate ? 1. : Dates.value(enddate-schedule[istart])/Dates.value(schedule[istart+1]-schedule[istart])

    # Fraction of the first period
    inext = findfirst(x -> x >= startdate, schedule)
    periodfrac += schedule[inext] == startdate ? 0. : Dates.value(schedule[inext]-startdate)/Dates.value(schedule[inext]-schedule[inext-1])

    # Number of full period between the first and last periods
    periodfrac += istart-inext

    return periodfrac/dc.frequency
end

# helper function
thirty360(dy,dm,dd) = (360*dy + 30*dm + dd)/360

"""
    Thirty360()

**30/360** or **Bond Basis** day count convention.

The year fraction is computed as:
```math
\\frac{360 \\times (y_2 - y_1) + 30 \\times (m_2 - m_1) + (d_2 - d_1)}{360}
```
where
- ``y_1`` and ``y_2`` are the years of the start and end date, respectively.
- ``m_1`` and ``m_2`` are the months of the start and end date, respectively.
- ``d_1`` is the day of the month at the start date, unless it is 31, in which case it is
  30.
- ``d_2`` is the day of the month at the end date, unless it is 31 and ``d_1 ≥ 30``, in
  which case it is 30.

# Reference
 - 2006 ISDA definitions, §4.16 (f)
"""
struct Thirty360 <: DayCount end
const BondBasis = Thirty360
function yearfrac(startdate::Date, enddate::Date, dc::Thirty360)
    if startdate > enddate
        return -yearfrac(enddate, startdate, dc)
    end

    dy = year(enddate)-year(startdate)
    dm = month(enddate)-month(startdate)

    d1 = day(startdate)
    d2 = day(enddate)
    if d1 >= 30
        d1 = 30
        if d2 >= 30
            d2 = 30
        end
    end
    return thirty360(dy,dm,d2-d1)
end

"""
    ThirtyU360() or Excel.Thirty360

**US (NASD) 30/360** day count convention, as computed via Microsoft Excel `YEARFRAC` with the basis option of `0`.

This differs from [`Thirty360`](@ref) when:
*  if the start date is the last day of February, then
  -  ``d_1`` is 30, and
  - if the end date is also the last day of February ``d_2`` is also 30.

# Reference
- [Microsoft Excel `YEARFRAC` function](https://support.office.com/en-us/article/yearfrac-function-3844141e-c76d-4143-82b6-208454ddc6a8)
- [David A. Wheeler (2008) "YEARFRAC Incompatibilities between Excel 2007 and OOXML (OXML), and the Definitions Actually Used by Excel 2007"](https://dwheeler.com/yearfrac/excel-ooxml-yearfrac.pdf)
"""
struct ThirtyU360 <: DayCount end
function yearfrac(startdate::Date, enddate::Date, dc::ThirtyU360)
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
yearfrac(startdate::Date, enddate::Date) = DayCounts.yearfrac(startdate::Date, enddate::Date, ThirtyU360()) # Defaul DayCount

"""
    ThirtyE360()

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
struct ThirtyE360 <: DayCount end
const EurobondBasis = ThirtyE360

function yearfrac(startdate::Date, enddate::Date, dc::ThirtyE360)
    if startdate > enddate
        return -yearfrac(enddate, startdate, dc)
    end
    dy = year(enddate)-year(startdate)
    dm = month(enddate)-month(startdate)
    d1 = min(day(startdate),30)
    d2 = min(day(enddate),30)
    return thirty360(dy,dm,d2-d1)
end

"""
    ThirtyE360ISDA(maturity::Date)

**30E/360 (ISDA)** day count convention. Note that this is dependant of the maturity date
of the underlying security, provided as the `maturity` argument.

The year fraction is computed as:
```math
\\frac{360 \\times (y_2 - y_1) + 30 \\times (m_2 - m_1) + (d_2 - d_1)}{360}
```
where
- ``y_1`` and ``y_2`` are the years of the start and end date, respectively.
- ``m_1`` and ``m_2`` are the months of the start and end date, respectively.
- ``d_1`` is the day of the month at the start date, unless it is:
  * the last day of February, or
  * the 31st day of the month,
  in which case it is 30.
- ``d_2`` is the day of the month at the end date, unless it is:
  * the last day of February and not the maturity date, or
  * the 31st day of the month,
  in which case it is 30.

# Reference
 - 2006 ISDA definitions, §4.16 (h)
"""
struct ThirtyE360ISDA <: DayCount
    maturity::Date
end
function yearfrac(startdate::Date, enddate::Date, dc::ThirtyE360ISDA)
    if startdate > enddate
        return -yearfrac(enddate, startdate, dc)
    elseif startdate == enddate
        # in case startdate == enddate == maturitydate == end of Feb.
        return 0.0
    end
    y1 = year(startdate)
    y2 = year(enddate)
    m1 = month(startdate)
    m2 = month(enddate)
    d1 = startdate == lastdayofmonth(startdate) ? 30 : day(startdate)
    d2 = enddate == lastdayofmonth(enddate) && !(m2 == 2 && enddate == dc.maturity) ? 30 : day(enddate)
    return thirty360(y2-y1,m2-m1,d2-d1)
end

include("excel.jl")

end # module
