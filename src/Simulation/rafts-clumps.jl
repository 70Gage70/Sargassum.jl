"""
    struct ClumpParameters

A container for the high-level parameters of the BOM equations.

### Fields
- `α` []: The fraction of the wind field acting on the particle.
- `τ` [d]: Measures the inertial response time of the medium to the particle
- `R` []: A geometric parameter.
- `Ω` [1/d]: The angular velocity of the Earth.
- `σ` []: The Stokes drift parameter; this applies an additional fraction of the Stokes drift to the water velocity 
    component of the particle.

## Constructing from physical constants

    ClumpParameters(; constants...)

Compute the parameters required for the eBOM equations from physical constants.

### Constants

- `δ` []: The bouyancy of the particle. Default: `1.25`.
- `a` [km]: The radius of the particle. Default: `1.0e-4`.
- `ρ` [kg/km^3]: The density of the water. Default: `1027.0e9`.
- `ρa` [kg/km^3]: The density of the air. Default: `1.2e9`.
- `ν` [km^2/d]: The viscosity of the water. Default: `8.64e-8`.
- `νa` [km^2/d]: The viscosity of the air. Default: `1.296e-6`.
- `Ω` [rad/d]: The angular velocity of the Earth. Default: `2π`.
- `σ` []: The Stokes drift parameter. Default: `0.0`.

## Constructing directly

    ClumpParameters(α, τ, R, Ω, σ)

Construct a `ClumpParameters` from the final constants directly. Use this to force specific values.
"""
struct ClumpParameters
    α::Float64
    τ::Float64
    R::Float64
    Ω::Float64
    σ::Float64
end

function ClumpParameters(;
    δ::Real = 1.25,
    a::Real = 1.0e-4,
    ρ::Real = 1027.0e9,
    ρa::Real = 1.2e9,
    ν::Real = 8.64e-8,
    νa::Real = 1.296e-6,
    Ω::Real = 2*π,
    σ::Real = 0.0)

    μ = ν * ρ
    μa = νa * ρa
    γ = μa/μ

    ψ = (im*sqrt(1 - (2/δ - 1)^2) + 2/δ - 1)^(1/3)
    Φ = real(im*sqrt(3)/2 * (1/ψ - ψ) - 1/2 * (1/ψ + ψ) + 1)
    Ψ = 1/π * acos(1 - Φ) - 1/π * (1 - Φ) * sqrt(1 - (1 - Φ)^2)

    α = γ*Ψ/(1 - (1 - γ)*Ψ)
    τ = (1 - Φ/6)/(1 - (1 - γ)*Ψ) * (a^2 * ρ / (3*μ*δ^4))
    R = (1 - Φ/2)/(1 - Φ/6)

    return ClumpParameters(α, τ, R, Ω, σ)
end

"""
    struct RaftParameters{S, C, G, L, I}

A container for the parameters defining a raft. Each clump and spring are identical.

### Structure 

`RaftParameters` acts as the parameter container for [`Raft!`](@ref). The solution vector `u` is \
a `2 x N` `Matrix` of the form `[x1 x2 ... xN ; y1 y2 ... yN]` giving the initial coordinates of each clump.

### Fields
- `ics`: An [`InitialConditions`](@ref).
- `clumps`: The [`ClumpParameters`](@ref) shared by each clump in the raft.
- `springs`: A subtype of [`AbstractSpring`](@ref).
- `connections`: A subtype of [`AbstractConnections`](@ref).
- `gd_model`: A subtype of [`AbstractGrowthDeathModel`](@ref). 
- `land`: A subtype of [`AbstractLand`](@ref).
- `n_clumps_max`: An `Integer` equal to the maximum allowed number of clumps. The number of clumps \
will not exceed this for any reason.
- `living`: A `BitVector` such that `living[i] == true` if the clump with index `i` is alive.
- `n_clumps_tot`: An `Base.RefValue{Int64}` whose reference is equal to the total number of \
clumps that have ever existed (i.e. it is at least the number of clumps that exist at any specific time.)
- `geometry`: A `Bool` that toggles whether to apply the geometric correction factors [`γ_sphere`](@ref) \
and [`τ_sphere`](@ref). Note that the simulation still uses the available interpolants, therefore if the \
interpolants have been created with geometric corrections included, but `RaftParameters` is created with \
`geometry == false`, the result will be a mixture of corrected and uncorrected terms.
- `dx_MR`: `dx` of the Maxey-Riley equation. When provided, integration is done using [`FastRaft!`](@ref).
- `dy_MR`: `dy` of the Maxey-Riley equation. When provided, integration is done using [`FastRaft!`](@ref).

### Constructor

    RaftParameters(; ics, clumps, springs, connections, gd_model, land, n_clumps_max, geometry = true, fast_raft = false)

The quantities `living` and `n_clumps_tot` are computed automatically under the assumption that \
the clumps initially provided are all alive.

### Fast Raft

If `fast_raft == true` in the above constructor, then the equations will be integrated using [`FastRaft!`](@ref).
This is faster than [`Raft!`](@ref) at the expense of a more front-loaded computation since the interpolants must
be computed. Using fast raft is advisable when the number of clumps is large. Default `false`.

One can also set `fast_raft = (dx_MR, dy_MR)` directly if the interpolants have been computed previously using [`dxdy_MR`](@ref).
"""
struct RaftParameters{
    S<:AbstractSpring, 
    C<:AbstractConnections, 
    G<:AbstractGrowthDeathModel, 
    L<:AbstractLand,
    I<:Union{Interpolations.AbstractInterpolation, Nothing}}

    ics::InitialConditions
    clumps::ClumpParameters
    springs::S
    connections::C
    gd_model::G
    land::L
    n_clumps_max::Int64
    living::BitVector
    n_clumps_tot::Base.RefValue{Int64}
    geometry::Bool
    dx_MR::I
    dy_MR::I

    function RaftParameters(;
        ics::InitialConditions,
        clumps::ClumpParameters,
        springs::S,
        connections::C,
        gd_model::G,
        land::L,
        n_clumps_max::Int64,
        geometry::Bool = true,
        fast_raft::Union{Bool, Tuple{I, I}} = false) where {S<:AbstractSpring, C<:AbstractConnections, G<:AbstractGrowthDeathModel, L<:AbstractLand, I<:Interpolations.AbstractInterpolation}

        @argcheck n_clumps_max >= size(ics.ics, 2) "Maximum number of clumps must be at least as large as number of initial clumps"

        n_clumps_tot = Ref(size(ics.ics, 2))
        living = [trues(n_clumps_tot.x) ; falses(n_clumps_max - n_clumps_tot.x)]
        ics = InitialConditions(tspan = ics.tspan, ics = [ics.ics ;; zeros(2, n_clumps_max - n_clumps_tot.x)])
        
        # connections for initial distribution of clumps
        conns = form_connections(connections, view(ics.ics, :, living))
        conns2living = (1:size(ics.ics, 2))[living]
        connections.connections[living] .= conns .|> x -> map(y -> conns2living[y], x)

        # fast_raft
        if fast_raft isa Bool
            dx_MR, dy_MR = fast_raft ? dxdy_MR(ics.tspan, clumps) : (nothing, nothing)
        else
            dx_MR, dy_MR = fast_raft
        end
  
        return new{S, C, G, L, typeof(dx_MR)}(ics, clumps, springs, connections, gd_model, land, n_clumps_max, living, n_clumps_tot, geometry, dx_MR, dy_MR)
    end
end


"""
    dxdy_MR(tspan, clumps; geometry = true)

Compute `(dx, dy)` where `dx` and `dy` are interpolants evaluable at `(x, y, t)` equal to the right-hand-side
of the Maxey-Riley equations (spring force excluded).

This is automatically applied when a fast raft is selected in [`Raft!`](@ref).

### Optional Arguments

- `geometry`: Passed directly to `γ_sphere`](@ref) and [`τ_sphere`](@ref).
"""
function dxdy_MR(tspan::Tuple{Real, Real}, clumps::ClumpParameters; geometry::Bool = true)
    α, τ, R, Ω, σ = clumps.α, clumps.τ, clumps.R, clumps.Ω, clumps.σ

    dt = step(WATER_ITP.x.dims[:t])
    xs, ys, ts = WATER_ITP.x.dims[:x], WATER_ITP.x.dims[:y], range(tspan..., step = dt)
    dx = zeros(length(xs), length(ys), length(ts))
    dy = zeros(length(xs), length(ys), length(ts))

    for i = 1:length(xs), j = 1:length(ys), k = 1:length(ts)
        x, y, t = xs[i], ys[j], ts[k]
        v_x     = WATER_ITP.x.fields[:u](x, y, t) + σ * STOKES_ITP.x.fields[:u](x, y, t)
        v_y     = WATER_ITP.x.fields[:v](x, y, t) + σ * STOKES_ITP.x.fields[:v](x, y, t)
        Dv_xDt  = WATER_ITP.x.fields[:DDt_x](x, y, t) + σ * STOKES_ITP.x.fields[:DDt_x](x, y, t)
        Dv_yDt  = WATER_ITP.x.fields[:DDt_y](x, y, t) + σ * STOKES_ITP.x.fields[:DDt_y](x, y, t)
        u_x     = (1 - α) * v_x + α * WIND_ITP.x.fields[:u](x, y, t)
        u_y     = (1 - α) * v_y + α * WIND_ITP.x.fields[:v](x, y, t)
        Du_xDt  = (1 - α) * Dv_xDt + α * WIND_ITP.x.fields[:DDt_x](x, y, t)
        Du_yDt  = (1 - α) * Dv_yDt + α * WIND_ITP.x.fields[:DDt_y](x, y, t)
        ω       = WATER_ITP.x.fields[:vorticity](x, y, t)
        f       = 2*Ω*sin(_y2lat(y))
        τ_☉     = τ_sphere(y, geometry = geometry)
        γ_☉     = γ_sphere(y, geometry = geometry)       

        dx[i, j, k] += (1/γ_☉) * (u_x + τ * (R*Dv_xDt - R*(f + ω/3)*v_y - Du_xDt + (f + τ_☉*u_x + R*ω/3)*u_y))
        dy[i, j, k] +=            u_y + τ * (R*Dv_yDt + R*(f + ω/3)*v_x - Du_yDt - (f + τ_☉*u_x + R*ω/3)*u_x)
    end

    spline = BSpline(Cubic(Interpolations.Line(OnGrid())))
    dx = extrapolate(
        Interpolations.scale(
                Interpolations.interpolate(dx, spline), 
            xs, ys, ts), 
        0.0)
    dy = extrapolate(
        Interpolations.scale(
                Interpolations.interpolate(dy, spline), 
            xs, ys, ts), 
        0.0)     

    return (dx, dy)
end