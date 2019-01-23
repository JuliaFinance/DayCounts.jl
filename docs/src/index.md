# DayCounts.jl

DayCounts.jl provides calculations of various day count conventions used in finance for
computing accrued interest and discount factors. These conventions have arisen to handle
factors such as months of different lengths and leap days.

The primary function is the [`yearfrac`](@ref), which accepts a start date, end date and a [`DayCount` object](@ref daycount_types).

# Example

```jldoctest
julia> using DayCounts, Dates

julia> d1, d2 = Date("2019-01-01"), Date("2019-04-01") # standard year
(2019-01-01, 2019-04-01)

julia> yearfrac(d1, d2, DayCounts.Thirty360())
0.25

julia> yearfrac(d1, d2, DayCounts.Actual360())
0.25

julia> yearfrac(d1, d2, DayCounts.Actual365Fixed())
0.2465753424657534

julia> yearfrac(d1, d2, DayCounts.ActualActualISDA())
0.2465753424657534

julia> d1, d2 = Date("2020-01-01"), Date("2020-04-01") # leap year
(2020-01-01, 2020-04-01)

julia> yearfrac(d1, d2, DayCounts.Thirty360())
0.25

julia> yearfrac(d1, d2, DayCounts.Actual360())
0.25277777777777777

julia> yearfrac(d1, d2, DayCounts.Actual365Fixed())
0.2493150684931507

julia> yearfrac(d1, d2, DayCounts.ActualActualISDA())
0.24863387978142076
```

# Microsoft Excel compatibility

The [`yearfrac`](@ref) function is similar to the [Microsoft Excel `YEARFRAC` function](https://support.office.com/en-us/article/yearfrac-function-3844141e-c76d-4143-82b6-208454ddc6a8), with the exception that if `startdate` is after `enddate`, the result is negative (Excel returns the absolute value).

Note that some of the Excel calculations differ slightly from the specifications, in these cases we have created additional types to reproduce the behaviour.

| Basis       | Excel Name       | Equivalent `DayCount` type            |
|-------------|------------------|---------------------------------------|
| 0 (default) | US (NASD) 30/360 | [`DayCounts.Thirty360Excel`](@ref)    |
| 1           | Actual/actual    | [`DayCounts.ActualActualExcel`](@ref) |
| 2           | Actual/360       | [`DayCounts.Actual360`](@ref)         |
| 3           | Actual/365       | [`DayCounts.Actual365Fixed`](@ref)    |
| 4           | European 30/360  | [`DayCounts.ThirtyE360`](@ref)        |

# External Links
- [_Day count convention_ on Wikipedia](https://en.wikipedia.org/wiki/Day_count_convention)
- [Nasdaq Day Count Fractions](https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf)
