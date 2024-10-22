const _UNISAMP = Union{Sampleable{Univariate, Continuous}, Sampleable{Univariate, Discrete}}

"""
    abstract type AbstractGrowthDeathModel

The abstract type for growth and death models.
    
Subtypes must have a field `S`, a `Vector{Float64}` of length `n_clumps_max` representing an "amount" or "mass" for each clump.

Subtypes must have a field `S_gen`, which is a `Distributions.Sampleable{Univariate, ...}` such that `rand(S_gen)` generates a 
sample of `S`. E.g. `S_gen = Distributions.Dirac(0.0)` will always initialize clumps with `S = fill(0.0, n_clumps_max)`.
"""
abstract type AbstractGrowthDeathModel end 

"""
    struct ImmortalModel{D}

An `AbstractGrowthDeathModel` such that no growth or death occurs.

### Fields

- `S`: The amount parameter. Unused for an `ImmortalModel`.
- `S_gen`. The amount generator. Unused for an `ImmortalModel`.

### Constructors 

    ImmortalModel(n_clumps_max; S_gen = Dirac(0.0))
"""
struct ImmortalModel{D<:_UNISAMP} <: AbstractGrowthDeathModel
    S::Vector{Float64}
    S_gen::D

    function ImmortalModel(n_clumps_max::Integer; S_gen::D = Dirac(0.0)) where {D<:_UNISAMP}
        return new{D}(zeros(n_clumps_max), S_gen)
    end
end

# condition 
function (model::ImmortalModel)(u, t, integrator)
    return false
end

# affect! 
function (model::ImmortalModel)(integrator)
    return nothing
end

"""
    struct BrooksModelParameters{I, F}

A container for the parameters of the model of [Brooks et al. (2018)](https://www.int-res.com/abstracts/meps/v599/p1-18/).

### Parameters 

- `temp` [°C]: An [`InterpolatedField`](@ref) for the water temperature. Default `TEMPERATURE_ITP.x`.
- `no3` [mmol N/m^3]: An [`InterpolatedField`](@ref) for the Nitrogen content of the water. `NUTRIENTS_ITP.x`.
- `μ_max` [1/d]: Sargassum maximum growth rate. Value: `0.1`
- `m` [1/d]: Sargassum mortality rate. Value: `0.05`
- `k_N` [mmol N/m^3]: Sargassum nutrient (N) uptake half saturation. Value: `0.012`
- `T_min` [°C]: Minimum temperature for Sargassum growth. Value: `10.0`
- `T_max` [°C]: Minimum temperature for Sargassum growth. Value: `40.0`
- `clumps_limits`: A `Tuple` of the form `(n_clumps_min, n_clumps_max)`. These impose hard lower \
and upper limits on the total number of clumps that can exist at any specific time (the total number \
of clumps that can have ever existed - i.e. `n_clumps_tot` of [`RaftParameters`](@ref) - may be higher.) Default: `(0, 10000)`.
- `S_min`: A clump dies when `S < S_min`. Default `0.0`.
- `S_max`: A clump grows when `S > S_max`. Default `1.0`.
- `dSdt`: Compute the rate of change of the "amount" `S` according to the Brooks model.

### dSdt

This function is of the form `dSdt = growth_factors  - death_factors`.
- `growth_factors = μ_max * temperature_factor * nutrients_factor`
- `death_factors = m`

### Constructors 

    BrooksModelParameters(; parameters...)
    
where each parameter is a kwarg with the default values given above.
"""
struct BrooksModelParameters{I<:InterpolatedField, F<:Function} 
    temp::I
    no3::I
    μ_max::Float64
    m::Float64
    k_N::Float64
    T_min::Float64
    T_max::Float64
    clumps_limits::Tuple{Int64, Int64}
    S_min::Float64
    S_max::Float64
    dSdt::F

    function BrooksModelParameters(;
        temp::I = TEMPERATURE_ITP.x,
        no3::I = NUTRIENTS_ITP.x,
        μ_max::Real = 0.1, 
        m::Real = 0.05,
        k_N::Real = 0.012,
        T_min::Real = 10.0,
        T_max::Real = 40.0,
        clumps_limits::Tuple{Integer, Integer} = (0, 10000),
        S_min::Real = -1.0,
        S_max::Real = 1.0) where {I<:InterpolatedField}

        function brooks_dSdt_clump(x::Real, y::Real, t::Real)
            temp_factor = begin
                T = temp.fields[:temp](x, y, t)
                T_opt = (T_min + T_max)/2
                if T_min <= T <= T_opt
                    exp(-0.5*((T - T_opt)/(T - T_min))^2)
                elseif T_opt < T <= T_max
                    exp(-0.5*((T - T_opt)/(T - T_max))^2)
                else
                    0.0
                end
            end

            N_factor = 1.0/(k_N/no3.fields[:no3](x, y, t) + 1.0)
            return μ_max*temp_factor*N_factor - m
        end
    
        return new{typeof(temp), typeof(brooks_dSdt_clump)}(temp, no3, μ_max, m, k_N, T_min, T_max, clumps_limits, S_min, S_max, brooks_dSdt_clump)
    end
end


"""
    mutable struct BrooksModel{B, D}

The growth/death model of [Brooks et al. (2018)](https://www.int-res.com/abstracts/meps/v599/p1-18/). 

### Fields 

- `S`: The amount parameter.
- `S_gen`. The amount generator.
- `params`: The [`BrooksModelParameters`](@ref) parameters of the model.
- `growths`:A `Vector` of indices of clumps that are to be grown (if any).
- `deaths`: A `Vector` of indices of clumps that are to be killed (if any).
- `verbose`: A `Bool` such that `verbose = true` will log times and labels of clumps that grow and die.

### Constructors

    BrooksModel(n_clumps_max; S_gen = Dirac(0.0), params = BrooksModelParameters(), verbose = false)

### Logic

At each time step, `model.S` is modified by `model.params.dSdt * dt`. The resulting `S` values are each \
compared to `model.params.S_min` and `model.params.S_max` and the associated `i`th clump either dies or spawns 
a child according to `grow!(integrator, location = i)`.
"""
mutable struct BrooksModel{B<:BrooksModelParameters, D<:_UNISAMP} <: AbstractGrowthDeathModel
    S::Vector{Float64}
    S_gen::D
    params::B
    growths::Vector{Int64}
    deaths::Vector{Int64}
    verbose::Bool

    function BrooksModel(
        n_clumps_max::Integer;
        S_gen::D = Dirac(0.0),
        params::B = BrooksModelParameters(), 
        verbose = false) where {B<:BrooksModelParameters, D<:_UNISAMP}

        S = rand(S_gen, n_clumps_max) # the fate of each new clump is already sealed :(

        return new{B, D}(S, S_gen, params, Int64[], Int64[], verbose)
    end
end
    
# condition 
function (model::BrooksModel)(u, t, integrator)
    n_clumps_max = integrator.p.n_clumps_max
    model.growths = Int64[]
    model.deaths = Int64[]

    for i in (1:n_clumps_max)[integrator.p.living]
        model.S[i] += model.params.dSdt(clump_i(u, i)..., t)*(t - integrator.tprev)

        if model.S[i] < model.params.S_min
            push!(model.deaths, i)
        elseif model.S[i] > model.params.S_max
            push!(model.growths, i)
            model.S[i] = rand(model.S_gen) # "refresh" parent clump
        end
    end

    clumps_limits = model.params.clumps_limits
    clumps_overflow = integrator.p.n_clumps_tot.x + length(model.growths) - min(clumps_limits[2], n_clumps_max)
    if clumps_overflow > 0
        model.growths = model.growths[1:end-clumps_overflow] # hard growth cutoff
    end

    delta = length(model.growths) - length(model.deaths)
    clumps_underflow = sum(integrator.p.living) - length(model.deaths) - clumps_limits[1]
    if delta < 0 && clumps_underflow < 0
        model.deaths = model.deaths[1:end+clumps_underflow] # hard death cutoff
    end

    if length(model.growths) > 0 || length(model.deaths) > 0
        return true
    else
        return false
    end
end

# affect!
function (model::BrooksModel)(integrator)
    if model.verbose
        if length(model.growths) > 0
            @info "Bio Growth [t = $(integrator.t)]: $(model.growths)"
        end

        if length(model.deaths) > 0
            @info "Bio Death [t = $(integrator.t)]: $(model.deaths)"
        end
    end

    # do growths first, since kill! has the possibility of terminating the integration
    for i in model.growths
        grow!(integrator, location = i)
    end

    kill!(integrator, model.deaths)

    return nothing
end