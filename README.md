# DayCounts.jl

[![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][documenter-dev-img]][documenter-dev-url]

## Summary

Pricing fixed-income securities involves estimating year fractions between dates. However, the fraction of a year between two dates depends on factors such as leap years and there are various conventions for dealing with this.

In this package, we collect various day count conventions and provide a method `yearfrac` for computing the year fraction between dates.

## Example

```julia
julia> using DayCounts, Dates

julia> basis = [Thirty360, Actual360, Actual365, ActualActual];

julia> println("\nYear fraction between Jan 1 and April 1:\n")
       for y in 2019:2020
       println(y,isleapyear(y) ? " (Leap Year)" : " (No Leap Year)")
       for b in basis
       yf = yearfrac(Date(y,1,1),Date(y,4,1),b)
       println(b,": ",yf)
       end
       println("")
       end

Year fraction between Jan 1 and April 1:

2019 (No Leap Year)
Thirty360: 0.25
Actual360: 0.25
Actual365: 0.2465753424657534
ActualActual: 0.2465753424657534

2020 (Leap Year)
Thirty360: 0.25
Actual360: 0.25277777777777777
Actual365: 0.2493150684931507
ActualActual: 0.24863387978142076
```

## References

We used the following sources:

* <https://en.wikipedia.org/wiki/Day_count_convention>
* <https://business.nasdaq.com/media/day-count-fractions_tcm5044-53854.pdf>
* <https://www.isda.org/2008/12/22/30-360-day-count-conventions>

[travis-img]: https://travis-ci.org/JuliaFinance/DayCounts.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaFinance/DayCounts.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/2rlf3g68ocvmc71q/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/EricForgy/daycounts-jl

[documenter-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[documenter-dev-url]: https://juliafinance.github.io/DayCounts.jl/dev/