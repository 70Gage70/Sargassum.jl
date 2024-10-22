include("land.jl")
export AbstractLand, NoLand, Land

include("ics.jl")
export InitialConditions

include("springs.jl")
export AbstractSpring, HookeSpring, BOMBSpring, ΔL, spring_force
export AbstractConnections, ConnectionsNone, ConnectionsFull, ConnectionsRadius, ConnectionsNearest, form_connections

include("growth-death.jl")
export AbstractGrowthDeathModel, ImmortalModel, BrooksModelParameters, BrooksModel

include("rafts-clumps.jl")
export ClumpParameters, RaftParameters, dxdy_MR

include("physics.jl")
export FastRaft!, Raft!, Leeway!

include("control.jl")
export kill!, grow!

include("trajectories.jl")
export Trajectory, time_slice, RaftTrajectory, bins

include("main.jl")
export simulate

include("io.jl")
export rtr2mat, rtr2nc

include("show.jl")
export length, show, iterate # various Base extensions

include("examples.jl")
export QuickRaftParameters