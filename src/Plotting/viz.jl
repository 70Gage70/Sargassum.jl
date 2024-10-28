"""
    viz(object, [spec]; args...)

Create a visualization of `object`. This function is defined on many objects, the complete list is as follows.

Refer to [`viz!`](@ref) for the mutating version (i.e in the case where you want to add a visualization to an existing plot).

# AFAI Objects

The following optional arguments apply to all functions unless otherwise noted.

- `show_coast`: Highlight the coastlines in each graph via [`coast!`](@ref).
- `show_clouds`: Highlight clouds/missing data in each graph via [`clouds!`](@ref).
- `limits`: A `NTuple{4, Int64}` giving the limits of the graph in the \
form `(lon_min, lon_max, lat_min, lat_max)`.
- `log_scale`: If `true`, plot on a logarithmic scale.

## AFAI

    viz(afai; show_coast, show_clouds, limits, thresh)

Plot [`AFAI`](@ref) for each of the four weeks on one graph. This function has the `thresh` argument instead of \
`log_scale`. Set `thresh` to a number between 0 and 1 to cut off all data below the `thresh` quantile. This can \
help to see the pixels with high AFAI values.

## SargassumDistribution Full

    viz(sargassum_distribution; show_coast, show_clouds, limits, log_scale)

Plot [`SargassumDistribution`](@ref) for each of the four weeks in one graph.

## SargassumDistribution Weekly

    viz(sargassum_distribution, week; show_coast, show_clouds, limits, log_scale)

Plot [`SargassumDistribution`](@ref) for the week `week`.

# Interpolant Objects

## InterpolatedField

    viz(itp, field; limits, time, show_land, n_points)

Plot a [`InterpolatedField`](@ref) or a `Ref{InterpolatedField}`. The field `field` is plotted, which should be \
a `Symbol` corresponding to the name of the field. Use `fields(itp)` to check which fields are available.

### Optional Arguments

- `limits`: If provided, the plot will be displayed in the region `lon_min, lon_max, lat_min, lat_min = limits`. Otherwise \
it is displayed according to `lon_min, lon_max, lat_min, lat_min = boundary(itp)`. Default `nothing`.
- `time`: If the interpolant is time dependent, plot it at this time. Default the first available time from `limits(itp)`.
- `show_land`: If `true`, overlay a plot of land. Default `true`.
- `n_points`: The number of points to use in each dimension of the plot, more gives higher resolution. Default `100`.

# Simulation Objects

## Trajectory and RaftTrajectory

    viz(traj; limits)

Visualize a [`Trajectory`](@ref) or [`RaftTrajectory`](@ref) on a plot with `lon_min, lon_max, lat_min, lat_min = limits`
"""
function viz end

"""
    viz!(axis, object, [spec]; args...)

Add a visualization of `object` to `axis`. This function is defined on many objects, the complete list is as follows.

Refer to [`viz`](@ref) for the non-mutating version (i.e in the case where you want an "all-in-one" solution).

# AFAI Objects

## SargassumDistribution

    viz!(axis, sargassum_distribution, week; show_coast, show_clouds, log_scale, args...)

Add a plot of [`SargassumDistribution`](@ref) for the week `week` to `Axis::Makie.Axis`. Returns a `Makie.heatmap!`.

### Optional Arguments

- `show_coast`: Highlight the coastlines in each graph via [`coast!`](@ref). Default `false`.
- `show_clouds`: Highlight clouds/missing data in each graph via [`clouds!`](@ref). Default `false`.
- `log_scale`: Plot on a `log10` scale. Default `false`.
- `args...`: All keyword arguments are passed directly to `Makie.heatmap!`.

# Interpolant Objects

## InterpolatedField

    viz!(ax, itp, field; time, n_points)

Add a plot of [`InterpolatedField`](@ref) or a `Ref{InterpolatedField}` to `Axis::Makie.Axis`. Returns a `Makie.heatmap!`.

The field `field` is plotted, which should be \
a `Symbol` corresponding to the name of the field. Use `fields(itp)` to check which fields are available.

### Optional Arguments

- `time`: If the interpolant is time dependent, plot it at this time. Default the first available time from `limits(itp)`.
- `n_points`: The number of points to use in each dimension of the plot, more gives higher resolution. Default `100`.

# Simulation Objects

## Trajectory and RaftTrajectory

    viz!(ax, traj; args...)

Add a line plot of [`Trajectory`](@ref) or [`RaftTrajectory`](@ref) to `Axis::Makie.Axis`. Returns \
a `Makie.lines!`. `args...` are passed directly to `Makie.lines!`.

    viz!(ax, rtraj, lon_bins, lat_bins; log_scale, args...)

Add a heatmap plot of [`RaftTrajectory`](@ref) to `Axis::Makie.Axis`. The heatmap is \
binned according to `lon_bins` and `lat_bins`, which should be ranges. Pass `log_scale = true` \
to plot on a log scale. `args...` are passed directly to `Makie.heatmap!`.

`rtraj` can be a single [`RaftTrajectory`](@ref) or a vector.

    viz!(ax, rtraj, dist, week; log_scale, args...)

Add a heatmap plot of [`RaftTrajectory`](@ref) to `Axis::Makie.Axis`. The heatmap is \
binned with the same bin specification as `dist`, a [`SargassumDistribution`](@ref) at \
week `week`. Pass `log_scale = true` \
to plot on a log scale. `args...` are passed directly to `Makie.heatmap!`.
"""
function viz! end