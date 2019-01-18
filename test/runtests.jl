using DayCounts, Dates
using Test

# based on tests from OpenGamma Strata
# https://github.com/OpenGamma/Strata/blob/efaa0be0d08dc61c23692e7b86df101ea0fb7223/modules/basics/src/test/java/com/opengamma/strata/basics/date/DayCountTest.java
@test yearfraction(Date(2011,12,28), Date(2012, 2,28), Actual365Fixed()) == 62 / 365
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), Actual365Fixed()) == 63 / 365
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), Actual365Fixed()) == 64 / 365
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), Actual365Fixed()) == (62 + 366 + 365 + 365 + 365) / 365
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), Actual365Fixed()) == (63 + 366 + 365 + 365 + 365) / 365
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), Actual365Fixed()) == (64 + 366 + 365 + 365 + 365) / 365
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), Actual365Fixed()) == 29 / 365
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), Actual365Fixed()) == 28 / 365
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), Actual365Fixed()) == 27 / 365

@test yearfraction(Date(2011,12,28), Date(2012, 2,28), Actual360()) == 62 / 360
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), Actual360()) == 63 / 360
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), Actual360()) == 64 / 360
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), Actual360()) == (62 + 366 + 365 + 365 + 365) / 360
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), Actual360()) == (63 + 366 + 365 + 365 + 365) / 360
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), Actual360()) == (64 + 366 + 365 + 365 + 365) / 360
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), Actual360()) == 29 / 360
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), Actual360()) == 28 / 360
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), Actual360()) == 27 / 360

@test yearfraction(Date(2011,12,28), Date(2012, 2,28), ActualActualISDA()) == 4 / 365 + 58 / 366
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), ActualActualISDA()) == 4 / 365 + 59 / 366
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), ActualActualISDA()) == 4 / 365 + 60 / 366
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), ActualActualISDA()) == 4 / 365 + 58 / 366 + 4
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), ActualActualISDA()) == 4 / 365 + 59 / 366 + 4
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), ActualActualISDA()) == 4 / 365 + 60 / 366 + 4
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), ActualActualISDA()) == 29 / 366
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), ActualActualISDA()) == 28 / 366
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), ActualActualISDA()) == 27 / 366
