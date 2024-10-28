"""
    struct InitialConditions

A container for the initial conditions for a raft. 

## Fields

- `tspan`: A `Tuple` such that the integration is performed for `tspan[1] ≤ t ≤ tspan[2]` where `t` is \
either two two `DateTime`s or two `Real`s measured in `UNITS["time"]` since [`T_REF`](@ref). 
- `ics`: A `2 x N` `Matrix` of the form `[x1 x2 ... xN ; y1 y2 ... yN]` giving the initial coordinates of each clump.

## Generic constructor

    InitialConditions(;tspan, ics)

## Constructing from positions

    InitialConditions(tspan, xy0; to_xy)

Construct initial conditions suitable for use in `RaftParameters.ics` from `2 x N` `Matrix`, `xy0` which should \
be equirectangular coordinates.

    InitialConditions(tspan, x_range, y_range; to_xy)

Generate clumps in a rectangular arrangement.

    InitialConditions(tspan, x0, y0; to_xy)
    
Generate a single clump with coordinates `(x0, y0)`.

### Optional Arguments 

`to_xy`: If `true`, the coordinates are converted from spherical to equirectangular coordinates. Default `false`.

## Constructing from a SargassumDistribution

    InitialConditions(tspan, dist, weeks, levels; seed)

Construct [`InitialConditions`](@ref) from a `SargassumDistribution`.

### Arguments 
- `tspan`: A 2-`Tuple` such that the integration is performed for `tspan[1] ≤ t ≤ tspan[2]` where `t` is \
either two two `DateTime`s or two `Real`s measured in `UNITS["time"]` since [`T_REF`](@ref). 
- `dist`: A `SargassumDistribution`.
- `weeks`: A `Vector{<:Integer}` giving the weeks of the month to consider. Each entry should be between 1 and 4 and appear only once.
- `levels`: The number of clump levels. Note that this is NOT equal to the number of clumps, see below.

### Levels

Boxes with nonzero Sargassum content are divided into `levels` levels of size `(maximum(D) - minimum(D))/levels` where `D = log10.(dist.sargassm[:,:,weeks])`. \
Each box gets a number of clumps equal to its level index. For example, if `levels = 2`, then the smaller half of the boxes (by Sargassum content) \
get 1 clump each and the larger half get 2 clumps each.

### Optional Arguments 

- `seed`: `Random.seed!(seed)` is called before the the initialization. Default 1234.

## Constructing from a SargassumDistribution (streamlined)

    InitialConditions(dist, week, n_weeks, levels; seed)

Construct [`InitialConditions`](@ref) from a `SargassumDistribution` using a more streamlined incantation than above.

### Arguments 
- `dist`: A `SargassumDistribution`.
- `week`: An integer between 1 and 4 giving the particular week of the month to initialize from.
- `n_weeks`: The number of weeks to integrate for.
- `levels`: As above.

### Optional Arguments 

- `seed`: `Random.seed!(seed)` is called before the the initialization. Default 1234.
"""
struct InitialConditions
    tspan::Tuple{Float64, Float64}
    ics::Matrix{Float64}

    function InitialConditions(;
        tspan::Union{Tuple{Real, Real}, Tuple{DateTime, DateTime}}, 
        ics::Matrix{<:Real})
        
        @argcheck tspan[1] < tspan[2] "initial time must be less than final time"
        @argcheck size(ics, 1) == 2 "matrix should have size 2 x N"
        @argcheck size(ics, 2) > 0 "ics can not be empty"

        _tspan = tspan isa Tuple{Real, Real} ? tspan : datetime2time.(tspan)

        return new(_tspan, ics)
    end
end

function InitialConditions(
    tspan::Union{Tuple{Real, Real}, Tuple{DateTime, DateTime}}, 
    xy0::Matrix{<:Real};
    to_xy::Bool = false)
    
    if to_xy
        ics = sph2xy(xy0)
    else
        ics = deepcopy(xy0)
    end

    return InitialConditions(tspan = tspan, ics = ics)
end

function InitialConditions(
    tspan::Union{Tuple{Real, Real}, Tuple{DateTime, DateTime}},
    x_range::AbstractRange{T}, 
    y_range::AbstractRange{T};
    to_xy::Bool = false) where {T<:Real}

    @argcheck allunique(x_range) "`x_range` can not have repeated entries"
    @argcheck allunique(y_range) "`y_range` can not have repeated entries"

    if to_xy
        ics_x, ics_y = sph2xy(x_range, y_range)
    else
        ics_x, ics_y = x_range, y_range
    end

    ics = Iterators.product(ics_x, ics_y) |> collect |> vec |> stack

    return InitialConditions(tspan = tspan, ics = ics)
end

function InitialConditions(
    tspan::Union{Tuple{Real, Real}, Tuple{DateTime, DateTime}}, 
    x0::Real, 
    y0::Real;
    to_xy::Bool = false)

    if to_xy
        ics = sph2xy(x0, y0)
    else
        ics = [x0, y0]
    end

    return InitialConditions(tspan = tspan, ics = reshape(ics, 2, 1))
end

function InitialConditions(
    tspan::Union{Tuple{Real, Real}, Tuple{DateTime, DateTime}},
    dist::SargassumDistribution, 
    weeks::Vector{<:Integer},
    levels::Integer;
    seed::Integer = 1234)

    seed!(seed)

    @argcheck levels > 0 "Must request at least one clump"
    @argcheck length(weeks) > 0 "At least one week must be selected."
    @argcheck all(map(x -> 1 <= x <= 4, weeks)) "Each entry of `weeks` must be between 1 and 4."
    @argcheck allunique(weeks) "Each week should only appear once."

    sarg = sum(dist.sargassum[:,:,week] for week in weeks)
    lons = dist.lon
    lats = dist.lat

    δ_x = abs(lons[2] - lons[1])
    δ_y = abs(lats[2] - lats[1])

    x0 = Float64[]
    y0 = Float64[]

    pts = Iterators.product(lons, lats) |> x -> reduce(vcat, collect(x)) # vector of (lon, lat)
    wts = sarg |> x -> reduce(vcat, x) # vector of sarg, matched with pts

    idx = findall(x -> x > 0, wts)
    pts = pts[idx]
    wts = log10.(wts[idx])

    wtsmin, wtsmax = extrema(wts)

    for i = 1:length(pts)
        pt = pts[i]
        n_c = levels*(wts[i] - wtsmin)/(wtsmax - wtsmin) |> x -> round(Integer, x, RoundUp)
        for _ = 1:n_c
            push!(x0, rand(Uniform(pt[1] - δ_x/2, pt[1] + δ_x/2)))
            push!(y0, rand(Uniform(pt[2] - δ_y/2, pt[2] + δ_y/2)))       
        end
    end           

    ics = [x0' ; y0']
    ics = sph2xy(ics)
    
    return InitialConditions(tspan = tspan, ics = ics)
end

function InitialConditions(
    dist::SargassumDistribution, 
    week::Integer,
    n_weeks::Integer,
    levels::Integer;
    seed::Integer = 1234)

    @argcheck week in [1, 2, 3, 4]
    @argcheck n_weeks >= 1

    ym1 = yearmonth(dist.time)
    ymw1 = (ym1[1], ym1[2], week)

    ymw2 = ymwplusweek(ymw1, n_weeks)
    tspan = (ymw1, ymw2) .|> ymw2time

    return InitialConditions(tspan, dist, [week], levels, seed = seed)
end