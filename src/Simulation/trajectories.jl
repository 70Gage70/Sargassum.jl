"""
    struct Trajectory

A container for the data of a single clump's trajectory. 

### Fields

- `xy`: A `Matrix` of size `N x 2` such that `xy[i,:]` gives the `[x, y]` or `[lon, lat]` coordinates at the clump at time `t[i]`.
- `t`: A `Vector` of length `N` giving the time values of the trajectory.

### Constructor

    Trajectory(xy, t)

Construct a Trajectory directly from `xy` and `t` as defined above.

### Plotting

This object can be [`viz`](@ref) and [`viz!`](@ref).
"""
struct Trajectory
    xy::Matrix{Float64}
    t::Vector{Float64}

    function Trajectory(xy::Matrix{<:Real}, t::Vector{<:Real})
        @argcheck length(t) == size(xy, 1) "`t` and `xy` must have the same length."
        @argcheck size(xy, 2) == 2 "`xy` must have two columns."

        new(xy, t)
    end   
end

function Base.length(tr::Trajectory)
    return length(tr.t)
end

"""
    time_slice(traj, tspan)

Return a new [`Trajectory`](@ref) consisting of points and times of `traj` that are between `first(tspan)`
and `last(tspan)`. The result `Trajectory` may be empty.

Can also be applied to a [`RaftTrajectory`](@ref) in which case `time_slice` is applied to each member `Trajectory`.
"""
function time_slice(traj::Trajectory, tspan::NTuple{2, Real})
    t = traj.t
    xy = traj.xy

    idx = findall(x -> first(tspan) <= x <= last(tspan), t)

    return Trajectory(xy[idx,:], t[idx])
end

"""
    struct RaftTrajectory

A container for the data of a every clump's trajectory in a raft, as well as its center of mass.
    
### Fields 
- `trajectories`: A `Dict` mapping clump indices to their corresponding [`Trajectory`](@ref).
- `t`: A vector of all time possible slices across the clump trajectories.
- `n_clumps`: A vector such that `n_clumps[i]` is the number of clumps that are alive at time `t[i]`.
- `com`: A [`Trajectory`](@ref) corresponding to the center of mass of the raft. 

### Constructor

    RaftTrajectory(; trajectories, n_clumps, com)
    
The field `t` is set to `com.t`.

### Plotting

This object can be [`viz`](@ref) and [`viz!`](@ref).
"""
struct RaftTrajectory
    trajectories::Dict{Int64,Trajectory}
    t::Vector{Float64}
    n_clumps::Vector{Int64}
    com::Trajectory

    function RaftTrajectory(;
        trajectories::Dict{Int64, Trajectory},
        n_clumps::Vector{Int64},
        com::Trajectory)

        @argcheck length(com) == length(n_clumps)

        return new(trajectories, com.t, n_clumps, com)
    end
end

"""
    bins(raft_trajectory, x_bins, y_bins)

Return a matrix `mat` such that `mat[i, j]` is the number of points in `raft_trajectory` that, at any time, 
were inside the rectangle `lon ∈ (x_bins[i], x_bins[i + 1])`, `lat ∈ (y_bins[i], y_bins[i + 1])`.

Both `x_bins` and `y_bins` should be `StepRangeLen`, i.e. of the form `range(start, stop, length = L)`. Then, 
`mat` has dimensions `length(x_bins) - 1 x length(y_bins) - 1`.

No coversion from or to spherical coordinates is done on `x_bins` and `y_bins`.
"""
function bins(raft_trajectory::RaftTrajectory, x_bins::StepRangeLen, y_bins::StepRangeLen)
    mat = zeros(length(x_bins) - 1, length(y_bins) - 1)

    for (_, tr) in raft_trajectory.trajectories
        for i = 1:size(tr.xy, 1)
            x_bin = ceil(Int64, (tr.xy[i, 1] - first(x_bins))/step(x_bins))
            y_bin = ceil(Int64, (tr.xy[i, 2] - first(y_bins))/step(y_bins))
    
            if (x_bin < 1) || (x_bin >= length(x_bins)) || (y_bin < 1) || (y_bin >= length(y_bins))
                continue
            else
                mat[x_bin, y_bin] = mat[x_bin, y_bin] + 1
            end
        end
    end

    return mat
end

"""
    bins(raft_trajectory, dist; return_xy_bins)

Equivalent to `bins(raft_trajectory, x_bins, y_bins` where `x_bins` and `y_bins` are computed 
automatically from the `SargassumDistribution`, `dist.lon` and `dist.lat`.

This assumes that `dist.lon` and `dist.lat` give the central locations of the `dist` bins.

### Optional Arguments

- `return_xy_bins`: A `Bool` such that, if `true`, the tuple `(x_bins, y_bins, bins)` is returned instead of just `bins`. Default `false`.
"""
function bins(raft_trajectory::RaftTrajectory, dist::SargassumDistribution; return_xy_bins::Bool = false)
    lon = vec2range(dist.lon)
    x_bins = range(lon[1] - step(lon)/2, lon[end] + step(lon)/2, length = length(lon) + 1)
    
    lat = vec2range(dist.lat)
    y_bins = range(lat[1] - step(lat)/2, lat[end] + step(lat)/2, length = length(lat) + 1)

    if return_xy_bins
        return (x_bins, y_bins, bins(raft_trajectory, x_bins, y_bins))
    else
        return bins(raft_trajectory, x_bins, y_bins)
    end
end

function time_slice(traj::RaftTrajectory, tspan::NTuple{2, Real})
    trajectories = traj.trajectories
    trajectories_new = Dict(key => time_slice(trajectories[key], tspan) for key in keys(trajectories))

    t = traj.t
    idx = findall(x -> first(tspan) <= x <= last(tspan), t)

    return RaftTrajectory(trajectories = trajectories_new, n_clumps = traj.n_clumps[idx], com = time_slice(traj.com, tspan))
end