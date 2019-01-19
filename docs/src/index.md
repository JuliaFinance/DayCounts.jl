# DayCounts.jl

DayCounts.jl provides calculations of various day count conventions used in finance for
computing accrued interest and discount factors. These conventions have arisen to handle
factors such as months of different lengths and leap days.

# Example

```jldoctest
julia> using DayCounts, Dates

julia> d1, d2 = Date("2019-01-01"), Date("2019-04-01") # standard year
(2019-01-01, 2019-04-01)

julia> yearfrac(d1, d2, Thirty360())
0.25

julia> yearfrac(d1, d2, Actual360())
0.25

julia> yearfrac(d1, d2, Actual365Fixed())
0.2465753424657534

julia> yearfrac(d1, d2, ActualActualISDA())
0.2465753424657534

julia> d1, d2 = Date("2020-01-01"), Date("2020-04-01") # standard year
(2020-01-01, 2020-04-01)

julia> yearfrac(d1, d2, Thirty360())
0.25

julia> yearfrac(d1, d2, Actual360())
0.25277777777777777

julia> yearfrac(d1, d2, Actual365Fixed())
0.2493150684931507

julia> yearfrac(d1, d2, ActualActualISDA())
0.24863387978142076
```

# External Links
- [_Day count convention_ on Wikipedia](https://en.wikipedia.org/wiki/Day_count_convention)
- [Nasdaq Day Count Fractions](https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf)

# Interface
```@docs
yearfrac
```

# [`DayCount` types](@id daycount_types)
```@docs
Actual365Fixed
Actual360
ActualActualISDA
ActualActualICMA
Thirty360
ThirtyE360
ThirtyE360ISDA
```

