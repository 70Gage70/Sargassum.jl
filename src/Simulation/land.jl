"""
    abstract type AbstractLand

A supertype for all land/shore types.
"""
abstract type AbstractLand end 

"""
    struct NoLand

An [`AbstractLand`](@ref) such that the land/shore is completely ignored.
"""
struct NoLand <: AbstractLand
end

# condition 
function (land::NoLand)(u, t, integrator)
    return false
end

# affect!
function (land::NoLand)(integrator)
    return nothing
end

"""
    mutable struct Land{I}

A container for data handling death of clumps upon reaching the shore.

### Fields 

- `land_itp`: A `InterpolatedField` such that `land_itp.fields[:land](x, y)` is equal to `1.0` if `(x, y)` is on land and `0.0` otherwise.
- `deaths`: A `Vector` of indices of clumps that are to be killed.
- `verbose`: A `Bool` such that `verbose = true` will log times and labels of clumps that hit land.

### Constructors 

    Land(;land_itp::InterpolatedField = land_itp, verbose = false)
"""
mutable struct Land{I<:InterpolatedField} <: AbstractLand
    land_itp::I
    deaths::Vector{Int64}
    verbose::Bool

    function Land(;land_itp::InterpolatedField = LAND_ITP.x, verbose = false)
        return new{typeof(land_itp)}(land_itp, Int64[], verbose)
    end
end

# condition 
function (land::Land)(u, t, integrator)
    n_clumps_max = integrator.p.n_clumps_max
    idx = (1:n_clumps_max)[integrator.p.living]
    land.deaths = Int64[]
    for i in idx
        land.land_itp.fields[:land](clump_i(u, i)...) == 1.0 && push!(land.deaths, i)
    end
    return length(land.deaths) > 0
end

# affect!
function (land::Land)(integrator)
    if land.verbose
        @info "Land [t = $(integrator.t)]: $(land.deaths)"
    end
    
    kill!(integrator, land.deaths)
end