using Test, DayCounts, Dates, ExcelFiles

@testset "Excel basis 0" begin
    table = load("yearfrac.xlsx","basis0")
    dc = DayCounts.Excel.Thirty360()
    for r in ExcelFiles.getiterator(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 1" begin
    table = load("yearfrac.xlsx","basis1")
    dc = DayCounts.Excel.ActualActual()
    for r in ExcelFiles.getiterator(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 2" begin
    table = load("yearfrac.xlsx","basis2")
    dc = DayCounts.Excel.Actual360()
    for r in ExcelFiles.getiterator(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 3" begin
    table = load("yearfrac.xlsx","basis3")
    dc = DayCounts.Excel.Actual365()
    for r in ExcelFiles.getiterator(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 4" begin
    table = load("yearfrac.xlsx","basis4")
    dc = DayCounts.ThirtyE360()
    for r in ExcelFiles.getiterator(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end
