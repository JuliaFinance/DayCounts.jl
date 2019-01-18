module DayCounts
# https://en.wikipedia.org/wiki/Day_count_convention
# https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf
# https://www.isda.org/2008/12/22/30-360-day-count-conventions/

using Dates

export yearfraction, DayCount,
    Actual365Fixed, Actual365F, Actual360, ActualActualISDA,
    Thirty360, BondBasis, ThirtyE360, EurobondBasis, ThirtyE360ISDA

"""
    yearfraction(startdate::Date, enddate::Date, dc::DayCount)

Compute the fractional number of years between `startdate` and `enddate`, according to the
[`DayCount` object](@ref daycount_types) `dc`.
"""
function yearfraction
end


abstract type DayCount end

"""
    Actual365Fixed()
    Actual365F()

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
function yearfraction(startdate::Date, enddate::Date, ::Actual365Fixed)
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
function yearfraction(startdate::Date, enddate::Date, ::Actual360)
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
function yearfraction(startdate::Date, enddate::Date, ::ActualActualISDA)
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

# helper function
thirty360(dy,dm,dd) = (360*dy + 30*dm + dd)/360

"""
    Thirty360()
    BondBasis()

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
- ``d_2`` is the day of the month at the end date, unless it is 31 and ``d_1 > 29``, in
  which case it is 30.

# Reference
 - 2006 ISDA definitions, §4.16 (f)
"""
struct Thirty360 <: DayCount end
const BondBasis = Thirty360
function yearfraction(startdate::Date, enddate::Date, ::Thirty360)
    dy = year(enddate)-year(startdate)
    dm = month(enddate)-month(startdate)

    d1 = day(startdate)
    d2 = day(enddate)
    if d1 >= 30
        d1 = 30
        d2 = min(d2,30)
    end
    return thirty360(dy,dm,d2-d1)
end

"""
    ThirtyE360()
    EurobondBasis()

**30E/360** or **Eurobond Basis** day count convention.

The year fraction is computed as:
```math
\\frac{360 \\times (y_2 - y_1) + 30 \\times (m_2 - m_1) + (d_2 - d_1)}{360}
```
where
- ``y_1`` and ``y_2`` are the years of the start and end date, respectively.
- ``m_1`` and ``m_2`` are the months of the start and end date, respectively.
- ``d_1`` is the day of the month at the start date, unless it is 31, in which case it is
  30.
- ``d_2`` is the day of the month at the end date, unless it is 31, in which case it is
  30.

# Reference
 - 2006 ISDA definitions, §4.16 (g)
"""
struct ThirtyE360 <: DayCount end
const EurobondBasis = ThirtyE360
function yearfraction(startdate::Date, enddate::Date, ::ThirtyE360)
    dy = year(enddate)-year(startdate)
    dm = month(enddate)-month(startdate)
    d1 = min(day(startdate),30)
    d2 = min(day(enddate),30)
    return thirty360(dy,dm,d2-d1)
end

"""
    ThirtyE360ISDA(maturity::Date)

**30E/360 (ISDA)** day count convention.

The year fraction is computed as:
```math
\\frac{360 \\times (y_2 - y_1) + 30 \\times (m_2 - m_1) + (d_2 - d_1)}{360}
```
where
- ``y_1`` and ``y_2`` are the years of the start and end date, respectively.
- ``m_1`` and ``m_2`` are the months of the start and end date, respectively.
- ``d_1`` is the day of the month at the start date, unless it is the last day of
  February, or 31, in which case it is 30.
- ``d_2`` is the day of the month at the end date, unless it is the last day of February
  and not the maturity date, or 31, in which case it is 30.

# Reference
 - 2006 ISDA definitions, §4.16 (h)
"""
struct ThirtyE360ISDA <: DayCount
    maturity::Date
end
function yearfraction(startdate::Date, enddate::Date, dc::ThirtyE360ISDA)
    y1 = year(startdate)
    y2 = year(enddate)
    m1 = month(startdate)
    m2 = month(enddate)
    d1 = startdate == lastdayofmonth(startdate) ? 30 : day(startdate)
    d2 = enddate == lastdayofmonth(enddate) && !(m2 == 2 && enddate == dc.maturity) ? 30 : day(enddate)
    return thirty360(y2-y1,m2-m1,d2-d1)
end

end # module
