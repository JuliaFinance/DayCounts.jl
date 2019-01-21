using DayCounts, Dates
using Test

# based on tests from OpenGamma Strata
# https://github.com/OpenGamma/Strata/blob/efaa0be0d08dc61c23692e7b86df101ea0fb7223/modules/basics/src/test/java/com/opengamma/strata/basics/date/DayCountTest.java
@testset "Actual365Fixed" begin
    dc = DayCounts.Actual365Fixed()
    @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == (4 + 58) / 365
    @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == (4 + 59) / 365
    @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == (4 + 60) / 365
    @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == (4 + 366 + 365 + 365 + 365 + 58) / 365
    @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == (4 + 366 + 365 + 365 + 365 + 59) / 365
    @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == (4 + 366 + 365 + 365 + 365 + 60) / 365
    @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == 29 / 365
    @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == 28 / 365
    @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == 27 / 365

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end

@testset "Actual360" begin
    dc = DayCounts.Actual360()
    @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == (4 + 58) / 360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == (4 + 59) / 360
    @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == (4 + 60) / 360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == (4 + 366 + 365 + 365 + 365 + 58) / 360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == (4 + 366 + 365 + 365 + 365 + 59) / 360
    @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == (4 + 366 + 365 + 365 + 365 + 60) / 360
    @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == 29 / 360
    @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == 28 / 360
    @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == 27 / 360

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end

@testset "ActualActualISDA" begin
    dc = DayCounts.ActualActualISDA()
    @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == 4 / 365 + 58 / 366
    @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == 4 / 365 + 59 / 366
    @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == 4 / 365 + 60 / 366
    @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == 4 / 365 + 58 / 366 + 4
    @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == 4 / 365 + 59 / 366 + 4
    @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == 4 / 365 + 60 / 366 + 4
    @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == 29 / 366
    @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == 28 / 366
    @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == 27 / 366

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end

@testset "Thirty360" begin
    dc = DayCounts.Thirty360()
    # usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-29) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

    @test yearfrac(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,29), Date(2013, 8,31), dc) == ((31-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end

@testset "ThirtyE360" begin
    dc = DayCounts.ThirtyE360()
    # usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-29) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

    @test yearfrac(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,29), Date(2013, 8,31), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end

@testset "ThirtyE360ISDA" begin
    @testset "maturity not end of Feb" begin
        dc = DayCounts.ThirtyE360ISDA(Date(2012, 8, 31))
        @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == ((30-28) + (2-12)*30 + (2012-2011)*360)/360 # exception
        @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == ((30-28) + (2-12)*30 + (2016-2011)*360)/360 # exception
        @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
        @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
        @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-30) + (3-2)*30 + (2012-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

        @test yearfrac(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,29), Date(2013, 8,31), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception

        # zeros
        @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
        @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
        @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
        @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

        # reflection
        @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
        @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
    end

    @testset "maturity end of Feb" begin
        dc = DayCounts.ThirtyE360ISDA(Date(2012, 2,29)) # leap year, end of month
        @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
        @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == ((30-28) + (2-12)*30 + (2016-2011)*360)/360 # exception
        @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
        @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
        @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-30) + (3-2)*30 + (2012-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

        @test yearfrac(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,29), Date(2013, 8,31), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfrac(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfrac(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception

        # zeros
        @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
        @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
        @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
        @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

        # reflection
        @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
        @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
    end
end

@testset "ActualActualICMA" begin
    dc = DayCounts.ActualActualICMA(Date(2011,7,1):Month(6):Date(2012,7,1))

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end

@testset "ActuaActual ISDA Memo" begin
    # these test cases are all derived from
    # The Actual/Actual Day Count Fraction, ISDA
    # Paper for use with the ISDA Market Conventions Survey - 3rd June 1999
    # https://www.isda.org/a/pIJEE/The-Actual-Actual-Day-Count-Fraction-1999.pdf

    @testset "Semi-annual payment" begin
        dc_isda = DayCounts.ActualActualISDA()
        dc_icma = DayCounts.ActualActualICMA(Date(2003,11,1):Month(6):Date(2004,5,1))

        @test yearfrac(Date(2003,11,1), Date(2004,5,1), dc_isda) == (61/365 + 121/366)
        @test yearfrac(Date(2003,11,1), Date(2004,5,1), dc_icma) == 182/(2*182)
    end        
    
    @testset "short first" begin
        dc_isda = DayCounts.ActualActualISDA()
        dc_icma = DayCounts.ActualActualICMA(Date(1998,7,1):Month(12):Date(2000,7,1))

        @test yearfrac(Date(1999,2,1), Date(1999,7,1), dc_isda) == 150/365
        @test yearfrac(Date(1999,2,1), Date(1999,7,1), dc_icma) ≈ 150/365 atol=eps()

        @test yearfrac(Date(1999,7,1), Date(2000,7,1), dc_isda) == 184/365 + 182/366
        @test yearfrac(Date(1999,7,1), Date(2000,7,1), dc_icma) == 366/366

        @test yearfrac(Date(1999,2,1), Date(2000,7,1), dc_isda) == (150 + 184)/365 + 182/366 
        @test yearfrac(Date(1999,2,1), Date(2000,7,1), dc_icma) ≈ 150/365 + 366/366 atol=eps()
    end

    @testset "long first" begin
        dc_isda = DayCounts.ActualActualISDA()
        dc_icma = DayCounts.ActualActualICMA(Date(2002,7,15):Month(6):Date(2004,1,15))

        @test yearfrac(Date(2002,8,15), Date(2003,7,15), dc_isda) == 334/365
        @test yearfrac(Date(2002,8,15), Date(2003,7,15), dc_icma) == 181/(181*2) + 153/(184*2)

        @test yearfrac(Date(2003,7,15),Date(2004,1,15), dc_isda) == 170/365 + 14/366
        @test yearfrac(Date(2003,7,15), Date(2004,1,15), dc_icma) == 184/(184*2)

        @test yearfrac(Date(2002,8,15), Date(2004,1,15), dc_isda) ≈ (334+170)/365 + 14/366 rtol=eps()
        @test yearfrac(Date(2002,8,15), Date(2004,1,15), dc_icma) == 181/(181*2) + (153+184)/(184*2)
    end

    @testset "short final" begin
        dc_isda = DayCounts.ActualActualISDA()
        dc_icma = DayCounts.ActualActualICMA(Date(1999,7,30):Month(6):Date(2000,7,30))

        @test yearfrac(Date(1999,7,30), Date(2000,1,30), dc_isda) == 155/365 + 29/366
        @test yearfrac(Date(1999,7,30), Date(2000,1,30), dc_icma) == 184/(184*2)

        @test yearfrac(Date(2000,1,30), Date(2000,6,30), dc_isda) == 152/366
        @test yearfrac(Date(2000,1,30), Date(2000,6,30), dc_icma) == 152/(182*2)

        @test yearfrac(Date(1999,7,30), Date(2000,6,30), dc_isda) == 155/365 + (29+152)/366
        @test yearfrac(Date(1999,7,30), Date(2000,6,30), dc_icma) == 184/(184*2) + 152/(182*2)
    end

    @testset "long final" begin
        dc_isda = DayCounts.ActualActualISDA()
        # TODO: need a way to express "last day of month" schedules.
        dc_icma = DayCounts.ActualActualICMA(Date(1999,5,31):Month(3):Date(2000,5,31))

        @test yearfrac(Date(1999,11,30), Date(2000,4,30), dc_isda) == 32/365 + 120/366
        @test yearfrac(Date(1999,11,30), Date(2000,4,30), dc_icma) == 91/(91*4) + 61/(92*4)
    end
end


@testset "Thirty360Excel" begin
    dc = DayCounts.Thirty360Excel()
    # usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 2,29), dc) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
    @test yearfrac(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-30) + (3-2)*30 + (2012-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

    @test yearfrac(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,29), Date(2013, 8,31), dc) == ((31-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfrac(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfrac(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception

    # zeros
    @test yearfrac(Date(2011,12,28), Date(2011,12,28), dc) == 0
    @test yearfrac(Date(2011,12,31), Date(2011,12,31), dc) == 0
    @test yearfrac(Date(2012, 2,28), Date(2012, 2,28), dc) == 0
    @test yearfrac(Date(2012, 2,29), Date(2012, 2,29), dc) == 0

    # reflection
    @test yearfrac(Date(2012, 2,28), Date(2011,12,28), dc) == -yearfrac(Date(2011,12,28), Date(2012, 2,28), dc)
    @test yearfrac(Date(2012, 3,28), Date(2012, 2,29), dc) == -yearfrac(Date(2012, 2,29), Date(2012, 3,28), dc)
end
