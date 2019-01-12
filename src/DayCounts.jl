module DayCounts
# https://en.wikipedia.org/wiki/Day_count_convention
# https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf
# https://www.isda.org/2008/12/22/30-360-day-count-conventions/

using Dates

export yearfrac, DayCount, Thirty360, Thirty360E, Thirty360ISDA, Actual360, Actual365, ActualActual

abstract type DayCount end

struct Thirty360 <: DayCount end
struct Thirty360E <: DayCount end
struct Thirty360ISDA <: DayCount end
struct Actual360 <: DayCount end
struct Actual365 <: DayCount end
struct ActualActual <: DayCount end

# Bond Basis
function yearfrac(startdate::Date, enddate::Date, dc::Type{Thirty360})
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

# Eurobond Basis
function yearfrac(startdate::Date, enddate::Date, dc::Type{Thirty360E})
    dy = year(enddate)-year(startdate)
    dm = month(enddate)-month(startdate)
    d1 = min(day(startdate),30)
    d2 = min(day(enddate),30)
    return dy+dm/12+(d2-d1)/360
end

# Eurobond (ISDA) Basis
function yearfrac(startdate::Date, enddate::Date, termdate::Date, dc::Type{Thirty360ISDA})
    y1 = year(startdate)
    y2 = year(enddate)
    dm = month(enddate)-month(startdate)
    d1 = day(startdate)
    d2 = day(enddate)
    d1 = d1 == lastdayofmonth(Date(y1,2)) ? 30 : min(d1,30)
    d2 = ((d2 == lastdayofmonth(Date(y1,2))) & (enddate != termdate)) ? 30 : min(d1,30)
    return y2-y1+dm/12+(d2-d1)/360
end

function yearfrac(startdate::Date, enddate::Date, dc::Type{Actual360})
    return Dates.value(enddate-startdate)/360
end

function yearfrac(startdate::Date, enddate::Date, dc::Type{Actual365})
    return Dates.value(enddate-startdate)/365
end

function yearfrac(startdate::Date, enddate::Date, dc::Type{ActualActual})
    years = year(startdate):year(enddate)
    if any(isleapyear.(years))
        if length(years) > 1
            yf = 0.
            s = startdate
            for y in years
                e = lastdayofyear(s) > enddate ? enddate : lastdayofyear(s)
                if isleapyear(y)
                    yf += Dates.value(e-s)/366
                else
                    yf += Dates.value(e-s)/365
                end
                s = e
            end
            return yf
        else
            return Dates.value(enddate-startdate)/366
        end
    else
        return Dates.value(enddate-startdate)/365
    end
end

end # module