"""
    coast!(ax, dist; args...)

Add a heatmap of `dist.coast` to `ax::Makie.Axis`, where dist can be [`AFAI`](@ref) or [`SargassumDistribution`](@ref).

### Optional Arguments 

- `args...`: All keyword arguments are passed directly to `Makie.heatmap!`.
"""
function coast!(
    ax::Axis, 
    dist::Union{AFAI, SargassumDistribution}; 
    args...)

    lon = dist.lon
    lat = dist.lat
    coast = dist.coast

    defaults = (
        interpolate = false, 
        colorrange = (0.3, 0.4), 
        lowclip = RGBAf(0,0,0,0),
        highclip = colorant"red"
    )
    
   return heatmap!(ax, lon, lat, coast; merge(defaults, args)...)
end


"""
    clouds!(ax, dist, week; args...)

Add a heatmap of `dist.clouds[:, :, week]` to `ax::Makie.Axis`, where dist \
can be [`AFAI`](@ref) or [`SargassumDistribution`](@ref).

### Optional Arguments 

- `args...`: All keyword arguments are passed directly to `Makie.heatmap!`.
"""
function clouds!(
    ax::Axis, 
    dist::Union{AFAI, SargassumDistribution},
    week::Integer; 
    args...)

    @argcheck week in [1, 2, 3, 4]

    lon = dist.lon
    lat = dist.lat
    clouds = dist.clouds[:,:,week]

    defaults = (
        interpolate = false, 
        colorrange = (0.3, 0.4), 
        lowclip = RGBAf(0,0,0,0),
        highclip = colorant"black"
    )
    
   return heatmap!(ax, lon, lat, clouds; merge(defaults, args)...)
end

# plot AFAI in four-panel graph
function viz(
    afai::AFAI; 
    show_coast::Bool = false, 
    show_clouds::Bool = false,
    limits::NTuple{4, Int64} = (-100, -38, 0, 35),
    thresh::Union{Real, Nothing} = nothing)

    !isnothing(thresh) && @argcheck 0 <= thresh <= 1

    lon = afai.lon
    lat = afai.lat
    afai_data = afai.afai

    if !isnothing(thresh)
        q = quantile(filter(!isnan, vec(afai_data)), thresh)
        afai_data = afai_data .|> x -> x < q ? NaN : x
    end
    afai_limits = extrema(filter(!isnan, afai.afai))

    set_theme!(GEO_THEME())
    fig = Figure()

    # Day 7
    ax = Axis(fig[1, 1], title = "Days 1-7", limits = limits, xticks = WilkinsonTicks(3), yticks = WilkinsonTicks(3))
    # afai_limits = extrema(filter(!isnan, afai_data[:,:,1]))
    heatmap!(ax, lon, lat, afai_data[:,:,1], 
        colormap = EUREKA, colorrange = afai_limits)
    show_coast ? coast!(ax, afai) : nothing
    show_clouds ? clouds!(ax, afai, 1) : nothing
    land!(ax)
    
    # Day 14
    ax = Axis(fig[1, 2], title = "Days 8-14", limits = limits, xticks = WilkinsonTicks(3), yticks = WilkinsonTicks(3))
    # afai_limits = extrema(filter(!isnan, afai_data[:,:,2]))
    heatmap!(ax, lon, lat, afai_data[:,:,2], 
        colormap = EUREKA, colorrange = afai_limits)
    show_coast ? coast!(ax, afai) : nothing
    show_clouds ? clouds!(ax, afai, 2) : nothing
    land!(ax)
    
    # Day 21
    ax = Axis(fig[2, 1], title = "Days 15-21", limits = limits, xticks = WilkinsonTicks(3), yticks = WilkinsonTicks(3))
    # afai_limits = extrema(filter(!isnan, afai_data[:,:,3]))
    heatmap!(ax, lon, lat, afai_data[:,:,3], 
        colormap = EUREKA, colorrange = afai_limits)
    show_coast ? coast!(ax, afai) : nothing
    show_clouds ? clouds!(ax, afai, 3) : nothing
    land!(ax)
    
    # Day 28
    ax = Axis(fig[2, 2], title = "Days 22-28", limits = limits, xticks = WilkinsonTicks(3), yticks = WilkinsonTicks(3))
    # afai_limits = extrema(filter(!isnan, afai_data[:,:,4]))
    heatmap!(ax, lon, lat, afai_data[:,:,4], 
        colormap = EUREKA, colorrange = afai_limits)
    show_coast ? coast!(ax, afai) : nothing
    show_clouds ? clouds!(ax, afai, 4) : nothing
    land!(ax)
    
    year_string = Year(afai.time[1]).value
    month_string = monthname(afai.time[1])
    fig[0, :] = Label(fig, "$(month_string) $(year_string)", fontsize = 20)

    # afai_limits = extrema(filter(!isnan, afai_data))
    Colorbar(fig[3, :], vertical = false, flipaxis = false,
    colormap = EUREKA,
    limits = afai_limits,
    label = "AFAI")

    return fig
end

# plot SargassumDistribution in four-panel graph
function viz(
    sargassum_distribution::SargassumDistribution;
    show_coast::Bool = false,
    show_clouds::Bool = false,
    limits::NTuple{4, Int64} = (-90, -38, -5, 22),
    log_scale::Bool = false)

    lon = sargassum_distribution.lon
    lat = sargassum_distribution.lat
    sarg = sargassum_distribution.sargassum

    set_theme!(GEO_THEME())
    fig = Figure(
        fontsize = 16,
        figure_padding = (5, 25, 5, 5))

    # Day 7
    ax = Axis(fig[1, 1], title = "Days 1-7", limits = limits)
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg[:,:,1]))
    heatmap!(ax, lon, lat, sarg[:,:,1], 
        colormap = EUREKA,
        colorrange = sarg_limits,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white)
    show_coast ? coast!(ax, sargassum_distribution) : nothing
    show_clouds ? clouds!(ax, sargassum_distribution, 1) : nothing
    land!(ax)
    
    # Day 14
    ax = Axis(fig[1, 2], title = "Day 8-14", limits = limits)
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg[:,:,2]))
    heatmap!(ax, lon, lat, sarg[:,:,2], 
        colormap = EUREKA,
        colorrange = sarg_limits,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white)
    show_coast ? coast!(ax, sargassum_distribution) : nothing
    show_clouds ? clouds!(ax, sargassum_distribution, 2) : nothing
    land!(ax)
    
    # Day 21
    ax = Axis(fig[2, 1], title = "Day 15-21", limits = limits)
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg[:,:,3]))
    heatmap!(ax, lon, lat, sarg[:,:,3], 
        colormap = EUREKA,
        colorrange = sarg_limits,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white)
    show_coast ? coast!(ax, sargassum_distribution) : nothing
    show_clouds ? clouds!(ax, sargassum_distribution, 3) : nothing
    land!(ax)
    
    # Day 28
    ax = Axis(fig[2, 2], title = "Day 22-28", limits = limits)
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg[:,:,4]))
    heatmap!(ax, lon, lat, sarg[:,:,4], 
        colormap = EUREKA,
        colorrange = sarg_limits,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white)
    show_coast ? coast!(ax, sargassum_distribution) : nothing
    show_clouds ? clouds!(ax, sargassum_distribution, 4) : nothing
    land!(ax)

    year_string = Year(sargassum_distribution.time).value
    month_string = monthname(sargassum_distribution.time)
    fig[0, :] = Label(fig, "$(month_string) $(year_string)", fontsize = 20)

    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg))
    Colorbar(fig[3, :], colormap = EUREKA, vertical = false, flipaxis = false,
    limits = log_scale ? log10.(sarg_limits) : sarg_limits,
    label = log_scale ? L"\log_{10}(\text{sarg} \, [%])" : "sarg [%]", 
    lowclip = :white)

    return fig
end

# plot SargassumDistribution for a given week
function viz(
    sargassum_distribution::SargassumDistribution,
    week::Integer;
    show_coast::Bool = false,
    show_clouds::Bool = false,
    limits::NTuple{4, Int64} = (-90, -38, -5, 22),
    log_scale::Bool = false)

    @argcheck week ∈ [1, 2, 3, 4]

    lon = sargassum_distribution.lon
    lat = sargassum_distribution.lat
    sarg = sargassum_distribution.sargassum[:,:,week]

    year_string = Year(sargassum_distribution.time).value
    month_string = monthname(sargassum_distribution.time)

    set_theme!(GEO_THEME())
    fig = Figure(
        fontsize = 20,
        figure_padding = (5, 25, 5, 5))

    ax = Axis(fig[1, 1], title = "$(month_string) $(year_string), week $(week)", limits = limits, aspect = DataAspect())
    
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg))

    heatmap!(ax, lon, lat, sarg, 
        colormap = EUREKA,
        colorrange = sarg_limits,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white)

    show_coast ? coast!(ax, sargassum_distribution) : nothing
    show_clouds ? clouds!(ax, sargassum_distribution, week) : nothing

    land!(ax)
    
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg))
    Colorbar(fig[2, :], colormap = EUREKA, vertical = false, flipaxis = false,
    limits = log_scale ? log10.(sarg_limits) : sarg_limits,
    label = log_scale ? L"\log_{10}(\text{sarg} \, [%])" : "sarg [%]", 
    lowclip = :white)

    return fig
end

# adding SargassumDistribution plot to axis
function viz!(
    axis::Axis,
    sargassum_distribution::SargassumDistribution,
    week::Integer;
    show_coast::Bool = false,
    show_clouds::Bool = false,
    log_scale::Bool = false,
    args...)

    @argcheck week ∈ [1, 2, 3, 4]

    lon = sargassum_distribution.lon
    lat = sargassum_distribution.lat
    sarg = sargassum_distribution.sargassum[:,:,week]
    
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg))

    defaults = (
        colormap = EUREKA,
        colorrange = sarg_limits,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white
    )

    hm = heatmap!(axis, lon, lat, sarg; merge(defaults, args)...)

    show_coast ? coast!(axis, sargassum_distribution) : nothing
    show_clouds ? clouds!(axis, sargassum_distribution, week) : nothing

    return hm
end