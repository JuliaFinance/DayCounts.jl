var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "DayCounts.jl",
    "title": "DayCounts.jl",
    "category": "page",
    "text": ""
},

{
    "location": "#DayCounts.jl-1",
    "page": "DayCounts.jl",
    "title": "DayCounts.jl",
    "category": "section",
    "text": "DayCounts.jl provides calculations of various day count conventions used in finance for computing accrued interest and discount factors. These conventions have arisen to handle factors such as months of different lengths and leap days.The primary function is the yearfrac, which accepts a start date, end date and a DayCount object."
},

{
    "location": "#Example-1",
    "page": "DayCounts.jl",
    "title": "Example",
    "category": "section",
    "text": "julia> using DayCounts, Dates\n\njulia> d1, d2 = Date(\"2019-01-01\"), Date(\"2019-04-01\") # standard year\n(2019-01-01, 2019-04-01)\n\njulia> yearfrac(d1, d2, DayCounts.Thirty360())\n0.25\n\njulia> yearfrac(d1, d2, DayCounts.Actual360())\n0.25\n\njulia> yearfrac(d1, d2, DayCounts.Actual365Fixed())\n0.2465753424657534\n\njulia> yearfrac(d1, d2, DayCounts.ActualActualISDA())\n0.2465753424657534\n\njulia> d1, d2 = Date(\"2020-01-01\"), Date(\"2020-04-01\") # leap year\n(2020-01-01, 2020-04-01)\n\njulia> yearfrac(d1, d2, DayCounts.Thirty360())\n0.25\n\njulia> yearfrac(d1, d2, DayCounts.Actual360())\n0.25277777777777777\n\njulia> yearfrac(d1, d2, DayCounts.Actual365Fixed())\n0.2493150684931507\n\njulia> yearfrac(d1, d2, DayCounts.ActualActualISDA())\n0.24863387978142076"
},

{
    "location": "#Microsoft-Excel-compatibility-1",
    "page": "DayCounts.jl",
    "title": "Microsoft Excel compatibility",
    "category": "section",
    "text": "The yearfrac function is similar to the Microsoft Excel YEARFRAC function, with the exception that if startdate is after enddate, the result is negative (Excel returns the absolute value).Note that some of the Excel calculations differ slightly from the specifications, in these cases we have created additional types to reproduce the behaviour.Basis Excel Name Equivalent DayCount type\n0 (default) US (NASD) 30/360 DayCounts.Thirty360Excel\n1 Actual/actual DayCounts.ActualActualExcel\n2 Actual/360 DayCounts.Actual360\n3 Actual/365 DayCounts.Actual365Fixed\n4 European 30/360 DayCounts.ThirtyE360"
},

{
    "location": "#External-Links-1",
    "page": "DayCounts.jl",
    "title": "External Links",
    "category": "section",
    "text": "Day count convention on Wikipedia\nNasdaq Day Count Fractions"
},

{
    "location": "api/#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": ""
},

{
    "location": "api/#API-1",
    "page": "API",
    "title": "API",
    "category": "section",
    "text": ""
},

{
    "location": "api/#DayCounts.yearfrac",
    "page": "API",
    "title": "DayCounts.yearfrac",
    "category": "function",
    "text": "yearfrac(startdate::Date, enddate::Date, dc::DayCount)\n\nCompute the fractional number of years between startdate and enddate, according to the DayCount object dc.\n\nIf startdate == enddate, then the result is zero.\nIf startdate > enddate, then the result is -yearfrac(enddate, startdate, dc).\n\n\n\n\n\n"
},

{
    "location": "api/#Functions-1",
    "page": "API",
    "title": "Functions",
    "category": "section",
    "text": "yearfrac"
},

{
    "location": "api/#daycount_types-1",
    "page": "API",
    "title": "DayCount types",
    "category": "section",
    "text": ""
},

{
    "location": "api/#DayCounts.Actual365Fixed",
    "page": "API",
    "title": "DayCounts.Actual365Fixed",
    "category": "type",
    "text": "Actual365Fixed()\n\nActual/365 (Fixed) day count convention.\n\nThe year fraction is computed as:\n\nfractext of days365\n\nReference\n\n2006 ISDA definitions, §4.16 (d)\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.Actual360",
    "page": "API",
    "title": "DayCounts.Actual360",
    "category": "type",
    "text": "Actual360()\n\nActual/360 day count convention.\n\nThe year fraction is computed as:\n\nfractext of days360\n\nReference\n\n2006 ISDA definitions, §4.16 (e)\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.ActualActualISDA",
    "page": "API",
    "title": "DayCounts.ActualActualISDA",
    "category": "type",
    "text": "ActualActualISDA()\n\nActual/Actual (ISDA) day count convention.\n\nThe year fraction is computed as:\n\nfractext of days in standard year365 +\nfractext of days in leap year366\n\nFor the purposes of above, the start date is included and the end date is excluded.\n\nReference\n\n2006 ISDA definitions, §4.16 (b)\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.ActualActualICMA",
    "page": "API",
    "title": "DayCounts.ActualActualICMA",
    "category": "type",
    "text": "ActualActualICMA(schedule::StepRange{Date,Month})\n\nActual/Actual (ICMA), Actual/Actual (ISMA) or ISMA-99 day count convention.\n\nNote that this is dependent on the coupon or payment schedule of the underlying security. This is provided via the schedule argument, currently only date ranges with steps of months are supported.\n\nThe year fraction is computed as:\n\nsum_textschedule period fractext of days in periodtextlength of period times textperiods per year\n\nThis ensures that:\n\nall days in a period are of equal length, and\nall periods are of equal length.\n\nReference\n\n2006 ISDA definitions, §4.16 (c).\nICMA Rule Book, Rule 251.1 (iii).\nEMU and Market Conventions: Recent Developments, ISDA - BS:9951.1, §4. The Actual/Actual Day Count Convention.\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.ActualActualExcel",
    "page": "API",
    "title": "DayCounts.ActualActualExcel",
    "category": "type",
    "text": "ActualActualExcel()\n\nActual/Actual day count convention, as computed via Microsoft Excel YEARFRAC with the basis option of 1.\n\nThe year fraction is\n\nfractext of daysD\n\nwhere:\n\nif start date and end date are in the same calendar year, then D is the number of days in that calendar year,\notherwise if the end date is less than or equal to one year after the start date, then\nD = 366 if the interval includes February 29 (including both the start and end dates), or\nD = 365 otherwise.\notherwise it is the average length of the years included in the interval (this does not depend on where the start or end dates fall within those years).\n\nReference\n\nMicrosoft Excel YEARFRAC function\nDavid A. Wheeler (2008) \"YEARFRAC Incompatibilities between Excel 2007 and OOXML (OXML), and the Definitions Actually Used by Excel 2007\"\n\n\n\n\n\n"
},

{
    "location": "api/#Actual-conventions-1",
    "page": "API",
    "title": "Actual conventions",
    "category": "section",
    "text": "DayCounts.Actual365Fixed\nDayCounts.Actual360\nDayCounts.ActualActualISDA\nDayCounts.ActualActualICMA\nDayCounts.ActualActualExcel"
},

{
    "location": "api/#DayCounts.Thirty360",
    "page": "API",
    "title": "DayCounts.Thirty360",
    "category": "type",
    "text": "Thirty360()\n\n30/360 or Bond Basis day count convention.\n\nThe year fraction is computed as:\n\nfrac360 times (y_2 - y_1) + 30 times (m_2 - m_1) + (d_2 - d_1)360\n\nwhere\n\ny_1 and y_2 are the years of the start and end date, respectively.\nm_1 and m_2 are the months of the start and end date, respectively.\nd_1 is the day of the month at the start date, unless it is 31, in which case it is\n\nd_2 is the day of the month at the end date, unless it is 31 and d_1  30, in which case it is 30.\n\nReference\n\n2006 ISDA definitions, §4.16 (f)\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.ThirtyE360",
    "page": "API",
    "title": "DayCounts.ThirtyE360",
    "category": "type",
    "text": "ThirtyE360()\n\n30E/360 or Eurobond Basis day count convention.\n\nThe year fraction is computed as:\n\nfrac360 times (y_2 - y_1) + 30 times (m_2 - m_1) + (d_2 - d_1)360\n\nwhere\n\ny_1 and y_2 are the years of the start and end date, respectively.\nm_1 and m_2 are the months of the start and end date, respectively.\nd_1 is the day of the month at the start date, unless it is 31st day of the month, in which case it is 30.\nd_2 is the day of the month at the end date,  unless it is 31st day of the month, in which case it is 30.\n\nReference\n\n2006 ISDA definitions, §4.16 (g)\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.ThirtyE360ISDA",
    "page": "API",
    "title": "DayCounts.ThirtyE360ISDA",
    "category": "type",
    "text": "ThirtyE360ISDA(maturity::Date)\n\n30E/360 (ISDA) day count convention. Note that this is dependant of the maturity date of the underlying security, provided as the maturity argument.\n\nThe year fraction is computed as:\n\nfrac360 times (y_2 - y_1) + 30 times (m_2 - m_1) + (d_2 - d_1)360\n\nwhere\n\ny_1 and y_2 are the years of the start and end date, respectively.\nm_1 and m_2 are the months of the start and end date, respectively.\nd_1 is the day of the month at the start date, unless it is:\nthe last day of February, or\nthe 31st day of the month,\nin which case it is 30.\nd_2 is the day of the month at the end date, unless it is:\nthe last day of February and not the maturity date, or\nthe 31st day of the month,\nin which case it is 30.\n\nReference\n\n2006 ISDA definitions, §4.16 (h)\n\n\n\n\n\n"
},

{
    "location": "api/#DayCounts.Thirty360Excel",
    "page": "API",
    "title": "DayCounts.Thirty360Excel",
    "category": "type",
    "text": "Thirty360Excel()\n\nUS (NASD) 30/360 day count convention, as computed via Microsoft Excel YEARFRAC with the basis option of 0.\n\nThis differs from Thirty360 when:\n\nif the start date is the last day of February, then\nd_1 is 30, and\nif the end date is also the last day of February d_2 is also 30.\n\nReference\n\nMicrosoft Excel YEARFRAC function\nDavid A. Wheeler (2008) \"YEARFRAC Incompatibilities between Excel 2007 and OOXML (OXML), and the Definitions Actually Used by Excel 2007\"\n\n\n\n\n\n"
},

{
    "location": "api/#/360-conventions-1",
    "page": "API",
    "title": "30/360 conventions",
    "category": "section",
    "text": "DayCounts.Thirty360\nDayCounts.ThirtyE360\nDayCounts.ThirtyE360ISDA\nDayCounts.Thirty360Excel"
},

]}
