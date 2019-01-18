using DayCounts, Dates
using Test

# based on tests from OpenGamma Strata
# https://github.com/OpenGamma/Strata/blob/efaa0be0d08dc61c23692e7b86df101ea0fb7223/modules/basics/src/test/java/com/opengamma/strata/basics/date/DayCountTest.java
@testset "Actual365Fixed" begin
    dc = Actual365Fixed()
    @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == (4 + 58) / 365
    @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == (4 + 59) / 365
    @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == (4 + 60) / 365
    @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == (4 + 366 + 365 + 365 + 365 + 58) / 365
    @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == (4 + 366 + 365 + 365 + 365 + 59) / 365
    @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == (4 + 366 + 365 + 365 + 365 + 60) / 365
    @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == 29 / 365
    @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == 28 / 365
    @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == 27 / 365
end

@testset "Actual360" begin
    dc = Actual360()
    @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == (4 + 58) / 360
    @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == (4 + 59) / 360
    @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == (4 + 60) / 360
    @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == (4 + 366 + 365 + 365 + 365 + 58) / 360
    @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == (4 + 366 + 365 + 365 + 365 + 59) / 360
    @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == (4 + 366 + 365 + 365 + 365 + 60) / 360
    @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == 29 / 360
    @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == 28 / 360
    @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == 27 / 360
end

@testset "ActualActualISDA" begin
    dc = ActualActualISDA()
    @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == 4 / 365 + 58 / 366
    @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == 4 / 365 + 59 / 366
    @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == 4 / 365 + 60 / 366
    @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == 4 / 365 + 58 / 366 + 4
    @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == 4 / 365 + 59 / 366 + 4
    @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == 4 / 365 + 60 / 366 + 4
    @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == 29 / 366
    @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == 28 / 366
    @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == 27 / 366
end

@testset "Thirty360" begin
    dc = Thirty360()
    # usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
    @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-29) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

    @test yearfraction(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,29), Date(2013, 8,31), dc) == ((31-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
end

@testset "ThirtyE360" begin
    dc = ThirtyE360()
    # usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
    @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
    @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-29) + (3-2)*30 + (2012-2012)*360)/360
    @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

    @test yearfraction(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,29), Date(2013, 8,31), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
    @test yearfraction(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    @test yearfraction(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
end

@testset "ThirtyE360ISDA" begin
    @testset "maturity not end of Feb" begin
        dc = ThirtyE360ISDA(Date(2012, 8, 31))
        @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == ((30-28) + (2-12)*30 + (2012-2011)*360)/360 # exception
        @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == ((30-28) + (2-12)*30 + (2016-2011)*360)/360 # exception
        @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
        @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
        @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-30) + (3-2)*30 + (2012-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

        @test yearfraction(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,29), Date(2013, 8,31), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    end

    @testset "maturity end of Feb" begin
        dc = ThirtyE360ISDA(Date(2012, 2,29)) # leap year, end of month
        @test yearfraction(Date(2011,12,28), Date(2012, 2,28), dc) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2012, 2,29), dc) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2012, 3, 1), dc) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2016, 2,28), dc) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
        @test yearfraction(Date(2011,12,28), Date(2016, 2,29), dc) == ((30-28) + (2-12)*30 + (2016-2011)*360)/360 # exception
        @test yearfraction(Date(2011,12,28), Date(2016, 3, 1), dc) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
        @test yearfraction(Date(2012, 2,28), Date(2012, 3,28), dc) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
        @test yearfraction(Date(2012, 2,29), Date(2012, 3,28), dc) == ((28-30) + (3-2)*30 + (2012-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), dc) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

        @test yearfraction(Date(2012, 5,29), Date(2013, 8,29), dc) == ((29-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,29), Date(2013, 8,30), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,29), Date(2013, 8,31), dc) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,30), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,30), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
        @test yearfraction(Date(2012, 5,30), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,31), Date(2013, 8,29), dc) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,31), Date(2013, 8,30), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
        @test yearfraction(Date(2012, 5,31), Date(2013, 8,31), dc) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360 # exception
    end
end
