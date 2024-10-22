"""
    Raft!(du, u, p::RaftParameters, t)

Compute the right-hand-side of the differential equation controlling the motion of a raft with parameters 
given by [`RaftParameters`](@ref).

The solution vector `u` is a `2 x N` `Matrix` of the form `[x1 x2 ... xN ; y1 y2 ... yN]` giving the coordinates of each clump.

For integrating using a leeway velocity, [`Leeway!`](@ref) should be used.
"""
function Raft!(du, u, p::RaftParameters, t)
    α, τ, R, Ω, σ = p.clumps.α, p.clumps.τ, p.clumps.R, p.clumps.Ω, p.clumps.σ
    n_clumps_max = p.n_clumps_max
    geometry = p.geometry

    du .= 0.0

    for i in (1:n_clumps_max)[p.living]
        x, y    = clump_i(u, i)
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

        du[1,i] += (1/γ_☉) * (u_x + τ * (R*Dv_xDt - R*(f + ω/3)*v_y - Du_xDt + (f + τ_☉*u_x + R*ω/3)*u_y))
        du[2,i] +=            u_y + τ * (R*Dv_yDt + R*(f + ω/3)*v_x - Du_yDt - (f + τ_☉*u_x + R*ω/3)*u_x)

        for j in filter(x -> x > i, p.connections.connections[i]) # using Newton's Law 3, avoid double-counting spring forces
            xj, yj = clump_i(u, j)
            d = sqrt(γ_☉^2 * (x - xj)^2 + (y - yj)^2)
            fac = τ*(p.springs.k(d))*(p.springs.L/d - 1)
            fx, fy = fac*(x - xj), fac*(y - yj)

            du[1,i] += fx
            du[2,i] += fy

            du[1,j] -= fx
            du[2,j] -= fy 
        end
    end

    return nothing
end

"""
    FastRaft!(du, u, p, t)

When integrated, produces a result (nearly) identical to [`Raft!`](@ref), but is generally faster at the expense of 
a more front-loaded computation due to the requirement of additional interpolants.
"""
function FastRaft!(du, u, p::RaftParameters, t)
    τ = p.clumps.τ
    n_clumps_max = p.n_clumps_max
    geometry = p.geometry

    du .= 0.0

    for i in (1:n_clumps_max)[p.living]
        x, y    = clump_i(u, i)
        γ_☉     = γ_sphere(y, geometry = geometry)  
        du[1,i] += p.dx_MR(x, y, t)
        du[2,i] += p.dy_MR(x, y, t)

        for j in filter(x -> x > i, p.connections.connections[i]) # using Newton's Law 3, avoid double-counting spring forces
            xj, yj = clump_i(u, j)
            d = sqrt(γ_☉^2 * (x - xj)^2 + (y - yj)^2)
            fac = τ*(p.springs.k(d))*(p.springs.L/d - 1)
            fx, fy = fac*(x - xj), fac*(y - yj)

            du[1,i] += fx
            du[2,i] += fy

            du[1,j] -= fx
            du[2,j] -= fy 
        end
    end

    return nothing
end

"""
    Leeway!(du, u, p::RaftParameters, t)

Compute the right-hand-side of the differential equation controlling the motion of raft particles 
whose velocities are equal to `u = v_water + α v_wind`.

The parameters `p` are given by [`RaftParameters`](@ref), but only `p.α` is used.
"""
function Leeway!(du, u, p::RaftParameters, t)
    α, n_clumps_max = p.clumps.α, p.n_clumps_max

    for i in (1:n_clumps_max)[p.living]
        x, y        = clump_i(u, i)
        du[2*i-1]   = WATER_ITP.x.fields[:u](x, y, t) + α * WIND_ITP.x.fields[:u](x, y, t)
        du[2*i]     = WATER_ITP.x.fields[:v](x, y, t) + α * WIND_ITP.x.fields[:v](x, y, t)
    end

    return nothing
end

