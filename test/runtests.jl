using DayCounts, Dates
using Test

# based on tests from OpenGamma Strata
# https://github.com/OpenGamma/Strata/blob/efaa0be0d08dc61c23692e7b86df101ea0fb7223/modules/basics/src/test/java/com/opengamma/strata/basics/date/DayCountTest.java
# Actual365Fixed
@test yearfraction(Date(2011,12,28), Date(2012, 2,28), Actual365Fixed()) == (4 + 58) / 365
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), Actual365Fixed()) == (4 + 59) / 365
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), Actual365Fixed()) == (4 + 60) / 365
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), Actual365Fixed()) == (4 + 366 + 365 + 365 + 365 + 58) / 365
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), Actual365Fixed()) == (4 + 366 + 365 + 365 + 365 + 59) / 365
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), Actual365Fixed()) == (4 + 366 + 365 + 365 + 365 + 60) / 365
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), Actual365Fixed()) == 29 / 365
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), Actual365Fixed()) == 28 / 365
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), Actual365Fixed()) == 27 / 365

# Actual360
@test yearfraction(Date(2011,12,28), Date(2012, 2,28), Actual360()) == (4 + 58) / 360
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), Actual360()) == (4 + 59) / 360
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), Actual360()) == (4 + 60) / 360
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), Actual360()) == (4 + 366 + 365 + 365 + 365 + 58) / 360
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), Actual360()) == (4 + 366 + 365 + 365 + 365 + 59) / 360
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), Actual360()) == (4 + 366 + 365 + 365 + 365 + 60) / 360
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), Actual360()) == 29 / 360
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), Actual360()) == 28 / 360
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), Actual360()) == 27 / 360

# ActualActualISDA
@test yearfraction(Date(2011,12,28), Date(2012, 2,28), ActualActualISDA()) == 4 / 365 + 58 / 366
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), ActualActualISDA()) == 4 / 365 + 59 / 366
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), ActualActualISDA()) == 4 / 365 + 60 / 366
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), ActualActualISDA()) == 4 / 365 + 58 / 366 + 4
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), ActualActualISDA()) == 4 / 365 + 59 / 366 + 4
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), ActualActualISDA()) == 4 / 365 + 60 / 366 + 4
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), ActualActualISDA()) == 29 / 366
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), ActualActualISDA()) == 28 / 366
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), ActualActualISDA()) == 27 / 366

# Thirty360
# usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
@test yearfraction(Date(2011,12,28), Date(2012, 2,28), Thirty360()) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), Thirty360()) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), Thirty360()) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), Thirty360()) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), Thirty360()) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), Thirty360()) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), Thirty360()) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), Thirty360()) == ((28-29) + (3-2)*30 + (2012-2012)*360)/360
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), Thirty360()) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

@test yearfraction(Date(2012, 5,30), Date(2013, 8,29), Thirty360()) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,29), Date(2013, 8,30), Thirty360()) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,30), Date(2013, 8,30), Thirty360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,29), Date(2013, 8,31), Thirty360()) == ((31-29) + (8-5)*30 + (2013-2012)*360)/360
# exceptions
@test yearfraction(Date(2012, 5,30), Date(2013, 8,31), Thirty360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,31), Date(2013, 8,30), Thirty360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,31), Date(2013, 8,31), Thirty360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360

# ThirtyE360
# usual rule: ((d2-d1) + (m2-m1)*30 + (y2-y1)*360)/360
@test yearfraction(Date(2011,12,28), Date(2012, 2,28), ThirtyE360()) == ((28-28) + (2-12)*30 + (2012-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2012, 2,29), ThirtyE360()) == ((29-28) + (2-12)*30 + (2012-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2012, 3, 1), ThirtyE360()) == ((1-28) + (3-12)*30 + (2012-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2016, 2,28), ThirtyE360()) == ((28-28) + (2-12)*30 + (2016-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2016, 2,29), ThirtyE360()) == ((29-28) + (2-12)*30 + (2016-2011)*360)/360
@test yearfraction(Date(2011,12,28), Date(2016, 3, 1), ThirtyE360()) == ((1-28) + (3-12)*30 + (2016-2011)*360)/360
@test yearfraction(Date(2012, 2,28), Date(2012, 3,28), ThirtyE360()) == ((28-28) + (3-2)*30 + (2012-2012)*360)/360
@test yearfraction(Date(2012, 2,29), Date(2012, 3,28), ThirtyE360()) == ((28-29) + (3-2)*30 + (2012-2012)*360)/360
@test yearfraction(Date(2012, 3, 1), Date(2012, 3,28), ThirtyE360()) == ((28-1) + (3-3)*30 + (2012-2012)*360)/360

@test yearfraction(Date(2012, 5,30), Date(2013, 8,29), ThirtyE360()) == ((29-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,29), Date(2013, 8,30), ThirtyE360()) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,30), Date(2013, 8,30), ThirtyE360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
# exceptions
@test yearfraction(Date(2012, 5,29), Date(2013, 8,31), ThirtyE360()) == ((30-29) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,30), Date(2013, 8,31), ThirtyE360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,31), Date(2013, 8,30), ThirtyE360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
@test yearfraction(Date(2012, 5,31), Date(2013, 8,31), ThirtyE360()) == ((30-30) + (8-5)*30 + (2013-2012)*360)/360
