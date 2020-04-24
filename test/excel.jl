using Test, DayCounts, Dates
using XLSX
using Tables

xf = XLSX.readxlsx("yearfrac.xlsx")

function range_to_table(rng)
    Tables.table(rng[2:end,:]; header = Symbol.(rng[1,:]))
end

@testset "Excel basis 0" begin
    table = range_to_table(xf["basis0"][:])
    dc = DayCounts.Thirty360Excel()
    for r in Tables.rows(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 1" begin
    table = range_to_table(xf["basis1"][:])
    dc = DayCounts.ActualActualExcel()
    for r in Tables.rows(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 2" begin
    table = range_to_table(xf["basis2"][:])
    dc = DayCounts.Actual360()
    for r in Tables.rows(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 3" begin
    table = range_to_table(xf["basis3"][:])
    dc = DayCounts.Actual365Fixed()
    for r in Tables.rows(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end

@testset "Excel basis 4" begin
    table = range_to_table(xf["basis4"][:])
    dc = DayCounts.ThirtyE360()
    for r in Tables.rows(table)
        @test yearfrac(Date(r.startdate), Date(r.enddate), dc) == r.yearfrac
    end
end