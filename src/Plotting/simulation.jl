# add single trajectory lines
function viz!(ax::Axis, traj::Trajectory; args...)
    x, y = traj.xy[:,1], traj.xy[:,2]
    defaults = (color = traj.t, linewidth = 2)

    return lines!(axis, x, y; merge(defaults, args)...)
end


# add raft trajectory lines
function viz!(axis::Axis, rtraj::RaftTrajectory; args...)
    for i in keys(rtraj.trajectories)
        x, y = rtraj.trajectories[i].xy[:,1], rtraj.trajectories[i].xy[:,2]

        defaults = (color = rtraj.trajectories[i].t, linewidth = 2)
        lines!(axis, x, y; merge(defaults, args)...)
    end
    
    return nothing
end


# add raft trajectory histogram (cumulative if multiple provided)
function viz!(
    axis::Axis, 
    traj::Vector{<:RaftTrajectory},
    lon_bins::StepRangeLen,
    lat_bins::StepRangeLen;
    log_scale::Bool = false,
    args...
    )

    δ_lon = step(lon_bins)
    δ_lat = step(lat_bins)

    lon_centers = [lon + δ_lon/2 for lon in collect(lon_bins)[1:end-1]]
    lat_centers = [lat + δ_lat/2 for lat in collect(lat_bins)[1:end-1]]

    binned = zeros(typeof(traj[1]).parameters[2], length(lon_bins) - 1, length(lat_bins) - 1)
    for tr in traj
        binned = binned + bins(tr, lon_bins, lat_bins)
    end

    defaults = (
        colormap = EUREKA,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white,
        colorrange = (1.0, maximum(binned))
    )

    return heatmap!(axis, 
        lon_centers, 
        lat_centers, 
        binned; merge(defaults, args)...)
end

function viz!(
    axis::Axis, 
    traj::RaftTrajectory,
    lon_bins::StepRangeLen,
    lat_bins::StepRangeLen;
    log_scale::Bool = false,
    args...
    )

    viz!(axis, [traj], lon_bins, lat_bins; log_scale = log_scale, args...)
end


# add raft trajectory histogram, adjusted to SargassumDistribution
function viz!(
    axis::Axis, 
    traj::RaftTrajectory,
    dist::SargassumDistribution,
    week::Integer;
    log_scale::Bool = false,
    args...
    )

    @argcheck week in [1, 2, 3, 4]

    lon_centers = dist.lon
    lat_centers = dist.lat
    binned = bins(traj, dist)

    # rescale the trajectory data to be on the same scale as the distribution
    sarg = dist.sargassum[:,:,week]
    binned = binned*sum(sarg)/sum(binned)
    sarg_limits = (minimum(filter(x -> x > 0, sarg)), maximum(sarg))

    defaults = (
        colormap = EUREKA,
        colorscale = log_scale ? log10 : x -> x,
        lowclip = :white,
        colorrange = sarg_limits
    )

    return heatmap!(axis, 
        lon_centers, 
        lat_centers, 
        binned; merge(defaults, args)...)
end

# plot single trajectory
function viz(traj::Trajectory; limits::NTuple{4, Real} = (-100, -40, 5, 35))
    set_theme!(GEO_THEME())
    fig = Figure()
    ax = Axis(fig[1, 1], limits = limits)

    x, y = traj.xy[:,1], traj.xy[:,2]
    lines!(ax, x, y, color = traj.t, linewidth = 2)

    limits = traj.t |> x -> x .- first(x) |> extrema
    t0 = time2datetime(traj.t[1])
    Colorbar(fig[1, 2], limits = limits, label = "Days since $(t0)")

    land!(ax)

    return fig
end

# plot raft trajectory
function viz(rtraj::RaftTrajectory; limits::NTuple{4, Real} = (-100, -40, 5, 35))
    set_theme!(GEO_THEME())
    fig = Figure()
    ax = Axis(fig[1, 1], limits = limits)

    for i in keys(rtraj.trajectories)
        x, y = rtraj.trajectories[i].xy[:,1], rtraj.trajectories[i].xy[:,2]

        lines!(ax, x, y, color = rtraj.trajectories[i].t, linewidth = 2)
    end

    limits = rtraj.com.t |> x -> x .- first(x) |> extrema
    t0 = time2datetime(rtraj.com.t[1])
    Colorbar(fig[1, 2], limits = limits, label = "Days since $(t0)")

    land!(ax)

    return fig
end