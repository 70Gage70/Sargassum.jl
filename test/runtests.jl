using Sargassum
using Test
using CairoMakie
import Random
Random.seed!(1234)

@testset "PlottingCore" begin
    set_theme!(GEO_THEME())
    fig = Figure()
    ax = Axis(fig[1, 1])
    heatmap!(ax, rand(10, 10), colormap = EUREKA)
    heatmap!(ax, rand(10, 10), colormap = SHADDEN)
    land!(ax)
    fig
end


@testset "AFAITools" begin
    if isempty(readdir(Sargassum._SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH.x))
        download_precomputed()
    end
    sd_pre = SARGASSUM_DISTRIBUTION_PRECOMPUTED[(2018, 4)]
    viz(sd_pre)
    download_raw_afai(2018, 4)
    path = AFAI_DOWNLOADED_PATHS[(2018, 4)]
    afai = AFAI(path, AFAIParameters())
    viz(afai)
    sargassum_distribution(2018, 4, "test-sd.nc")
    SargassumDistribution("test-sd.nc")[(2018, 4)]
    rm("test-sd.nc")
end

@testset "Simulation" begin
    try
        itps_load()
    catch
        try 
            itps_default_construct(verbose = false)
        catch
            nothing
        end
    end

    tspan = ((2018, 4, 1), (2018, 4, 2)) .|> ymw2time
    dist = SARGASSUM_DISTRIBUTION_PRECOMPUTED[(2018, 4)]
    weeks = 1
    levels = 1
    ics = InitialConditions(tspan, dist, [weeks], levels)
    rp = QuickRaftParameters(ics)
    rtr = simulate(rp)
    viz(rtr)
end