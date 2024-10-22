"""
    simulate(rp; leeway, alg, abstol, reltol, showprogress, dt, return_raw)

Simulate a Sargassum raft with [`RaftParameters`](@ref) `rp` and return a [`RaftTrajectory`](@ref).

This function modifies the fields of `rp` significantly.

### Arguments 

- `rp`: A [`RaftParameters`](@ref) defining the raft.

### Optional Arguments

- `leeway`: Use [`Leeway!`](@ref) to integrate particles with no springs or inertia. Default `false`.
- `alg`: The integration algorithm to use, default [`Tsit5()`](https://docs.sciml.ai/DiffEqDocs/stable/solvers/ode_solve/).
- `abstol`: The absolute tolerance of integration; default `nothing`.
- `reltol`: The relative tolerance of integration; default `nothing`.
- `showprogress`: If `true`, print a status indicator of the progress of the integration. Default `false`.
- `dt`: The solution trajectories are uniformized to be spaced in time by increments of `dt`. Note that the units of \
this quantity are implicity `UNITS["time"]`. Default `0.1`.
- `return_raw`: If true, return the result of `OrdinaryDiffEq.solve`, rather than a [`RaftTrajectory`](@ref). \
Use this if you would like to manipulate the solution directly. Default `false`.
"""
function simulate(
    rp::RaftParameters; 
    leeway::Bool = false,
    alg = Tsit5(),
    abstol::Union{Real, Nothing} = nothing,
    reltol::Union{Real, Nothing} = nothing,
    showprogress::Bool = false,
    dt::Real = 0.1,
    return_raw::Bool = false)

    tspan = rp.ics.tspan

    if leeway
        prob_raft = ODEProblem(Leeway!, rp.ics.ics, tspan, rp)
    elseif rp.dx_MR !== nothing && rp.dx_MR !== nothing
        prob_raft = ODEProblem(FastRaft!, rp.ics.ics, tspan, rp)
    else
        prob_raft = ODEProblem(Raft!, rp.ics.ics, tspan, rp)
    end

    prog = ProgressBar(total = round(Int64, (tspan[2] - tspan[1])/dt), unit = "steps", unit_scale = true)
    set_description(prog, "Integrating:")

    callback = CallbackSet(
                DiscreteCallback(rp.land, rp.land),                             # LAND
                DiscreteCallback(rp.gd_model, rp.gd_model),                     # BIOLOGY 
                DiscreteCallback((u, t, integrator) -> true, rp.connections),   # CONNECTIONS
                DiscreteCallback(                                               # PROGRESS
                    (u, t, integrator) -> showprogress, 
                    integrator -> update(prog, max(0, round(Int64, (integrator.t - tspan[1])/dt) - prog.current) )))
                    
    sol = solve(prob_raft, alg, abstol = abstol, reltol = reltol, callback = callback)

    return_raw && return sol

    ts = range(extrema(sol.t)..., step = dt) |> collect     # "binned" times with width dt
    n_clumps = zeros(Int64, length(ts))                     # the number of clumps that are alice at each time
    raft_com = zeros(length(ts), 2)                         # the center-of-mass coordinates at each time
    trajs_t = [Float64[] for _ = 1:rp.n_clumps_max]         # trajs_t[i] is [t1, t2, ...] for clump i such that it is alive at each time
    trajs = [Float64[] for _ = 1:rp.n_clumps_max]           # trajs[i] is [x1, y1, x2, y2, ...] for clump i such that (x_j, y_j) = (x(trajs_t[j]), y(trajs_t[j]))
    u_prev = sol(ts[1])
    u_curr = sol(ts[1])

    for t_i = 1:length(ts)
        u_prev .= u_curr
        u_curr .= sol(ts[t_i])
        n_alive = 0
        com_t = [0.0, 0.0]

        for c_i = 1:rp.n_clumps_max
            if u_curr[:, c_i] != [0, 0] # clump has been alive at some point
                if t_i == 1 || (t_i > 1 && u_curr[:, c_i] != u_prev[:, c_i])
                    n_alive += 1
                    com_t += u_curr[:, c_i]
                    push!(trajs_t[c_i], ts[t_i])
                    append!(trajs[c_i], u_curr[:, c_i])
                end
            end
        end

        n_clumps[t_i] = n_alive
        raft_com[t_i, :] = com_t/n_alive
    end

    trajs = [Trajectory(permutedims(xy2sph(reshape(trajs[i], 2, length(trajs_t[i])))), trajs_t[i]) for i = 1:length(trajs) if length(trajs_t[i]) > 0]
    trajs = Dict(1:length(trajs) .=> trajs)
    raft_com = raft_com |> permutedims |> xy2sph |> permutedims |> r -> Trajectory(r, ts)
    rtr = RaftTrajectory(trajectories = trajs, n_clumps = n_clumps, com = raft_com)

    return rtr
end