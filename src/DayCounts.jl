module DayCounts
# https://en.wikipedia.org/wiki/Day_count_convention
# https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf
# https://www.isda.org/2008/12/22/30-360-day-count-conventions/

using Dates

export yearfraction, DayCount, Thirty360, ThirtyE360, ThirtyE360ISDA, Actual360, Actual365, ActualActualISDA


"""
    yearfraction(startdate::Date, enddate::Date, dc::DayCount)

Compute the fractional number of years between `startdate` and `enddate`, according to the
day count convention `dc`.
"""
function yearfraction
end


abstract type DayCount end

"""
    Actual365Fixed()

"Actual/365 (Fixed)" day count convention.

The actual number of days divided by 365.

# Reference
 - 2006 ISDA definitions, §4.16 (d)
"""
struct Actual365Fixed <: DayCount end
function yearfraction(startdate::Date, enddate::Date, ::Actual365Fixed)
    return Dates.value(enddate-startdate)/365
end

"""
    Actual360()

"Actual/360" day count convention.

Actual number of days divided by 360.

# Reference
 - 2006 ISDA definitions, §4.16 (e)

"""
struct Actual360 <: DayCount end
function yearfraction(startdate::Date, enddate::Date, ::Actual360)
    return Dates.value(enddate-startdate)/360
end


"""
    ActualActualISDA()

"Actual/Actual (ISDA)" day count convention.

The actual number of days which fall in a standard year divided by 365 plus the actual
number of days which fall in a leap year divided by 365. The start date is included, and
the end date is excluded.

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
        n1 = (d1 - dayofyear(startdate) + 1) / d1
        d2 = daysinyear(endyear)
        n2 = (dayofyear(enddate) - 1) / d2
        return n1/d1 + n2/d2 + (endyear - startyear - 1)
    end
end

"""
    Thirty360()
    BondBasis()

"30/360" or "Bond Basis" day count convention.

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
    if d1 > 29
        d2 = min(d2,30)
    end
    d1 = min(d1,30)
    return dy+dm/12+(d2-d1)/360
end

"""
    ThirtyE360()
    EurobondBasis()
    
"30E/360" or "Eurobond Basis" day count convention.

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
    return dy+dm/12+(d2-d1)/360
end

"""
    ThirtyE360ISDA(maturity::Date)
    
"30E/360 (ISDA)" day count convention.

# Reference
 - 2006 ISDA definitions, §4.16 (h)
"""
struct ThirtyE360ISDA <: DayCount
    maturity::Date
end
function yearfrac(startdate::Date, enddate::Date, dc::ThirtyE360ISDA)
    y1 = year(startdate)
    y2 = year(enddate)
    dm = month(enddate)-month(startdate)
    d1 = day(startdate)
    d2 = day(enddate)
    d1 = d1 == lastdayofmonth(Date(y1,2)) ? 30 : min(d1,30)
    d2 = ((d2 == lastdayofmonth(Date(y1,2))) & (enddate != dc.maturity)) ? 30 : min(d1,30)
    return y2-y1+dm/12+(d2-d1)/360
end

end # module
