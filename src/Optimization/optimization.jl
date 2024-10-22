"""
    struct TimeSeries

A container for comparing simulation data to target data in weekly periods.

### Fields

- `simulation`: An array with dimensions `lon x lat x t` such that `sum(:,:,t) = 1` for all `t`. This is the Sargassum \
distribution coming from simulation, i.e. a [`RaftTrajectory`](@ref).
- `target`: An array with dimensions `lon x lat x t` such that `sum(:,:,t) = 1` for all `t`. This is the Sargassum \
distribution coming from observation, i.e. a [`SargassumDistribution`](@ref).
- `lon`: A vector of latitudes.
- `lat`: A vector of longitudes.
- `t`: A vector of week spans.
- `exclude_clouded_bins`: If `true`, clouded bins have had their values set to 0 in both the simulation and the target.

### Constructor

    TimeSeries(rtr, ymw1, ymw2; corners, dists, exclude_clouded_bins)
    
where `rtr` is a [`RaftTrajectory`](@ref) and `ymw1` and `ymw2` are the `(year, month, week)` bounds of the time series.

### Optional Arguments

- `corners`: Of the form `(lon_min, lon_max, lat_min, lat_max)` where the data is restricted to bins in this area. \
Default `(-180, 180, -90, 90)`.
- `dists`: A dictionary mapping `(year, month)` to `SargassumDistribution`. Default `DIST_1718`.
- `exclude_clouded_bins`: Exclude clouded bins from the calculation, i.e. set their bin value equal to 0 in both the \
simulation and the target. Default `true`.
"""
struct TimeSeries
    simulation::Array{Float64, 3}
    target::Array{Float64, 3}
    lon::Vector{Float64}
    lat::Vector{Float64}
    t::Vector{Tuple{NTuple{3, Int64}, NTuple{3, Int64}}}
    exclude_clouded_bins::Bool

    function TimeSeries(
        rtr::RaftTrajectory,
        ymw1::NTuple{3, Int64},
        ymw2::NTuple{3, Int64};
        corners::NTuple{4, Real} = (-180, 180, -90, 90),
        dists::Dict{Tuple{Int64, Int64}, SargassumFromAFAI.SargassumDistribution} = DIST_1718,
        exclude_clouded_bins::Bool = true)
    
        ymws = ymwspan2weekspan(ymw1, ymw2)
        tspans = [(ymw2time(ymws[i]...), ymw2time(ymws[i + 1]...)) for i = 1:length(ymws) - 1]

        lons = findall(lon -> corners[1] <= lon <= corners[2], dists[ymws[1][1:2]].lon)
        lats = findall(lat -> corners[3] <= lat <= corners[4], dists[ymws[1][1:2]].lat)

        datas = []
        targets = []
    
        for i = 1:length(ymws)-1
            year, month, week = ymws[i+1]
            target = dists[(year, month)]
    
            data = bins(time_slice(rtr, tspans[i]), target)
    
            if exclude_clouded_bins
                data = data .* (target.clouds[:,:,week] .|> x -> ~x)
                target = target.sargassum[:,:,week] .* (target.clouds[:, :, week] .|> x -> ~x)
            else
                target = target.sargassum[:,:,week]
            end
    
            data = data[lons, lats]
            target = target[lons, lats]
    
            if sum(data) == 0.0
                data .= NaN
                push!(datas, data)
            else
                push!(datas, data/sum(data))
            end
    
            if sum(target) == 0.0
                target .= NaN
                push!(targets, target)
            else
                push!(targets, target/sum(target))
            end
        end
    
        lons = dists[ymws[1][1:2]].lon[lons]
        lats = dists[ymws[1][1:2]].lat[lats]
    
        return new(stack(datas), stack(targets), lons, lats, [(ymws[i], ymws[i + 1]) for i = 1:length(ymws) - 1], exclude_clouded_bins)
    end
end

"""
    vec(ts::SargassumBOMB.TimeSeries)

Return `(simulation, target)` where `simulation[i]` is a list of points `[lon_i, lat_i, ts.simulation[i]]` and \
similarly for `target`.
"""
function Base.vec(ts::SargassumBOMB.TimeSeries)
    simulation = Vector{Vector{Float64}}[]
    target = Vector{Vector{Float64}}[]

    for t = 1:length(ts.t)
        pts = Iterators.product(ts.lon, ts.lat) |> x -> reduce(vcat, collect(x)) 
        sim = ts.simulation[:,:,t] |> x -> reduce(vcat, x) 
        tar = ts.target[:,:,t] |> x -> reduce(vcat, x)
        push!(simulation, [[pts[i][1], pts[i][2], sim[i]] for i = 1:length(pts)]) 
        push!(target, [[pts[i][1], pts[i][2], tar[i]] for i = 1:length(pts)]) 
    end

    return (simulation, target)
end

"""
    struct LossFunction{F1, F2}

A container for the function used for measuring the loss of a simulation.

### Fields 

- `f`: A `Function`. This function must be callable as `f(rtr::RaftTrajectory)` and return a `Real`. This measures the 
    "score" of a `RaftTrajectory` (lower is better).
- `metric`: A `Function`. This function must be callable as `f(a::Matrix, b::Matrix)` and return a `Real`. This measures
    the "distance" between two matrices, e.g. `(a, b) -> sum(abs.(a - b))` is the `L1` norm.
- `name`: A `String` giving the name of the loss function, e.g. `"L1"`.

### Constructor

`LossFunction(ymw1, ymw2, dists; corners, metric, cumulative, name)`

### Arguments 

- `ymw1`: A `NTuple{3, Integer}` giving the initial `(year, month, week)` of the integration.
- `ymw2`: A `NTuple{3, Integer}` giving the final `(year, month, week)` of the integration.
- `dists`: A `Dict` mapping `(year, month)`s to `SargassumDistribution`s spanning the integration time period.

### Optional Arguments

- `corners`: The `(lon_min, lon_max, lat_min, lat_max)` coordinates to restrict the loss calculation to. Default `(-180, 180, -90, 90)`.
- `metric`: As defined above. Default `(a, b) -> sum(abs.(a - b))`.
- `cumulative`: If `true`, the loss is added at each intermediate week of the integration rather than just at the end. Default `false`.
- `name`: A `String` giving the name of the loss function. Default `"L1"`.
"""
struct LossFunction{F1<:Function, F2<:Function}
    f::F1
    metric::F2
    name::String

    function LossFunction(
        ymw1::NTuple{3, Integer}, 
        ymw2::NTuple{3, Integer},
        dists::Dict{Tuple{Int64, Int64}, SargassumFromAFAI.SargassumDistribution};
        corners::Tuple{Real, Real, Real, Real} = (-180, 180, -90, 90),
        metric::Function = (a, b) -> sum(abs.(a - b)), 
        cumulative::Bool = false,
        name::String = "L1")

        ymws = ymwspan2weekspan(ymw1, ymw2)
        tspans = [(ymw2time(ymws[i]...), ymw2time(ymws[i + 1]...)) for i = 1:length(ymws) - 1]
        # integrate for a week, then compare with the distribution (i.e. the next week's distribution)

        function weekly_loss(rtr::RaftTrajectory)
            loss_total = 0.0

            i1 = cumulative ? 1 : length(ymws)-1

            for i = i1:length(ymws)-1
                year, month, week = ymws[i+1]
                target = dists[(year, month)]

                lons = findall(lon -> corners[1] <= lon <= corners[2], target.lon)
                lats = findall(lat -> corners[3] <= lat <= corners[4], target.lat)

                data = bins(time_slice(rtr, tspans[i]), target) |> x -> x/sum(x)
                target = target.sargassum[:,:,week] |> x -> x/sum(x)
                loss_total = loss_total + metric(target[lons, lats], data[lons, lats])
            end

            return isnan(loss_total) ? Inf : loss_total
        end


        return new{typeof(weekly_loss), typeof(metric)}(weekly_loss, metric, name)
    end
end


"""
    optimize!(f, param_bounds, loss_func; time_limit, verbose, seed)

Find the minimum of `f(X)` where `X ∈ param_bounds`. The Evolutionary Centers Algorithm is used via `Metaheuristics.ECA`.

### Arguments 

- `f`: The function to optimize. Should be evaluable at a vector whose length is equal to `length(param_bounds)` and return a `Real`.
- `param_bounds`: A vector of tuples giving the box constraints of the optimization.

### Optional Arguments 

- `time_limit`: A `Float64` giving the upper time limit in seconds on the length of the optimization. Default `300.0`.
- `verbose`: Show simplified results each iteration of the optimization. Default `true`.
- `logger`: A function passed directly to `Metaheuristics.optimize!`, which receives a `Metaheuristics.State` at every step.
- `seed`: An integer seed for randomness. Default `1234`.
"""
function optimize!(
    f::Function,
    param_bounds::Vector{<:Tuple{Real, Real}}; 
    time_limit::Float64 = 300.0,
    verbose = true,
    logger::Function,
    seed::Integer = 1234)

    seed!(seed)

    lb = [p[1] for p in param_bounds]
    ub = [p[2] for p in param_bounds]
    bounds = Metaheuristics.boxconstraints(lb = lb, ub = ub)

    function f_parallel(X)
        fitness = zeros(size(X,1))
        Threads.@threads for i in 1:size(X,1)
            fitness[i] = f(X[i,:])
        end
        return fitness
    end

    options = Metaheuristics.Options(time_limit = time_limit, parallel_evaluation = true, verbose = verbose)
    algorithm = Metaheuristics.ECA(options = options)
    result = Metaheuristics.optimize(f_parallel, bounds, algorithm, logger = logger)

    return result
end