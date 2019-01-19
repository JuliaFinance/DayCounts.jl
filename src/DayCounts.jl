module DayCounts
# https://en.wikipedia.org/wiki/Day_count_convention
# https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf
# https://www.isda.org/2008/12/22/30-360-day-count-conventions/

using Dates

export yearfrac, DayCount,
    Actual365Fixed, Actual365F, Actual360, ActualActualISDA,
    ActualActualICMA, ActualActualISMA, ISMA99,
    Thirty360, BondBasis, ThirtyE360, EurobondBasis, ThirtyE360ISDA

"""
    yearfrac(startdate::Date, enddate::Date, dc::DayCount)

Compute the fractional number of years between `startdate` and `enddate`, according to the
[`DayCount` object](@ref daycount_types) `dc`.
"""
function yearfrac
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
function yearfrac(startdate::Date, enddate::Date, ::ActualActualISDA)
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
    ActualActualISMA(schedule::StepRange{Date,Month})
    ISMA99(schedule::StepRange{Date,Month})

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
struct ActualActualICMA <: DayCount
    schedule::StepRange{Date,Month}
end
const ActualActualISMA = ActualActualICMA
const ISMA99 = ActualActualICMA

function yearfrac(startdate::Date, enddate::Date, dc::ActualActualICMA)
    frequency = Month(12)/step(dc.schedule)

    r1 = searchsorted(dc.schedule, startdate)
    i1, j1 = last(r1), first(r1)
    r2 = searchsorted(dc.schedule, enddate)
    i2, j2 = last(r2), first(r2)

    if i1 == i2 || j1 == j2
        i = min(i1,i2)
        j = max(j1,j2)
        if i == j
            return 0.0
        else
            return Dates.value(enddate - startdate) / (frequency * Dates.value(dc.schedule[j] - dc.schedule[i]))
        end
    end
    
    f1 = i1 == j1 ? 0.0 : (dc.schedule[j1] - startdate) / (dc.schedule[j1] - dc.schedule[i1])
    f2 = i2 == j2 ? 0.0 : (enddate - dc.schedule[i2]) / (dc.schedule[j2] - dc.schedule[i2])

    (f1+f2+(i2-j1))/frequency
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
function yearfrac(startdate::Date, enddate::Date, ::Thirty360)
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
- ``d_1`` is the day of the month at the start date, unless it is 31st day of the month,
  in which case it is 30.
- ``d_2`` is the day of the month at the end date,  unless it is 31st day of the month,
  in which case it is 30.

# Reference
 - 2006 ISDA definitions, §4.16 (g)
"""
struct ThirtyE360 <: DayCount end
const EurobondBasis = ThirtyE360
function yearfrac(startdate::Date, enddate::Date, ::ThirtyE360)
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
    y1 = year(startdate)
    y2 = year(enddate)
    m1 = month(startdate)
    m2 = month(enddate)
    d1 = startdate == lastdayofmonth(startdate) ? 30 : day(startdate)
    d2 = enddate == lastdayofmonth(enddate) && !(m2 == 2 && enddate == dc.maturity) ? 30 : day(enddate)
    return thirty360(y2-y1,m2-m1,d2-d1)
end

end # module
