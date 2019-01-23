using Documenter
using DayCounts

makedocs(
    pages = [
        "index.md",
        "api.md",
        ],
    sitename = "DayCounts",
    format = Documenter.HTML(),
    modules = [DayCounts]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/JuliaFinance/DayCounts.jl.git"
)
