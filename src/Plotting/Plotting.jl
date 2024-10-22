include(joinpath(@__DIR__, "viz.jl"))
export viz, viz! 

include(joinpath(@__DIR__, "afai.jl"))
export coast!, clouds!

include(joinpath(@__DIR__, "interpolants.jl"))

include(joinpath(@__DIR__, "simulation.jl"))
