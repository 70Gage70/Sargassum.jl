function Base.show(io::IO, x::ClumpParameters)
    α, τ, R, Ω, σ = (x.α, x.τ, x.R, x.Ω, x.σ) .|> x-> round(x, sigdigits = 4)
    print(io, "ClumpParameters[α = $α, τ = $τ, R = $R, Ω = $Ω, σ = $σ]")
end

function Base.show(io::IO, x::HookeSpring)
    print(io, "HookeSpring[k = ")
    show(io, x.k)
    print(io, ", L = ")
    show(io, x.L)
    print(io, "]")
end

function Base.show(io::IO, x::BOMBSpring)
    print(io, "BOMBSpring[A = ")
    show(io, x.A)
    print(io, ", L = ")
    show(io, x.L)
    print(io, "]")
end

function Base.show(io::IO, x::InitialConditions)
    print(io, "InitialConditions[")
    print(io, "time ∈ ($(time2datetime(x.tspan[1])), $(time2datetime(x.tspan[2]))), ")
    print(io, "n_clumps = $(size(x.ics, 2)), ")
    xmin, xmax = extrema(x.ics[1:2:end])
    ymin, ymax = extrema(x.ics[2:2:end])
    lon_min, lat_min = xy2sph(xmin, ymin) .|> x -> round(x, sigdigits = 4)
    lon_max, lat_max = xy2sph(xmax, ymax) .|> x -> round(x, sigdigits = 4)
    print(io, "lon/lat ∈ ($lon_min, $lon_max) × ($lat_min, $lat_max)]")
end

function Base.show(io::IO, x::RaftParameters)
    println(io, " RaftParameters")
    println(io, "ICS = $(x.ics)")
    println(io, "Clumps = $(x.clumps)")
    println(io, "Springs = $(x.springs)")
    println(io, "Connections = $(typeof(x.connections).name.name)")
    println(io, "GrowthDeath = $(x.gd_model)")
end

function Base.show(io::IO, x::Trajectory)
    if length(x.t) == 0
        print(io, "Trajectory[0 pts]")
    else
        print(io, "Trajectory[(")
        show(io, first(x.t))
        print(io, ", ")
        show(io, last(x.t))
        print(io, "), ")
        show(io, length(x.t))
        print(io, " pts]")
    end
end

function Base.show(io::IO, x::RaftTrajectory)
    print(io, "RaftTrajectory[")
    show(io, length(keys(x.trajectories)))
    print(io, " trajectories, ")
    show(io, length(x.t))
    print(io, " times]")
end

function Base.show(io::IO, x::NoLand)
    print(io, "NoLand")
end

function Base.show(io::IO, x::Land)
    print(io, "Land[land_itp = LAND_ITP.x]")
end

function Base.show(io::IO, x::ImmortalModel)
    print(io, "ImmortalModel")
end

function Base.show(io::IO, x::BrooksModelParameters)
    println(io, "BrooksModelParameters")
    println(io, " μ_max = $(x.μ_max)")
    println(io, " m = $(x.m)")
    println(io, " k_N = $(x.k_N)")
    println(io, " T_min = $(x.T_min)")
    println(io, " T_max = $(x.T_max)")
    println(io, " clumps_limits = $(x.clumps_limits)")
    println(io, " S_min = $(x.S_min)")
    println(io, " S_max = $(x.S_max)")
    println(io, " dSdt = $(nameof(x.dSdt))")
end

function Base.show(io::IO, x::BrooksModel)
    print(io, "BrooksModel")
end