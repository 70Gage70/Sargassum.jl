include(joinpath(@__DIR__, "utils.jl"))
# no exports

include(joinpath(@__DIR__, "units.jl"))
export UNITS

include(joinpath(@__DIR__, "time.jl"))
export T_REF
export time2months, months2time
export datetime2time, time2datetime
export ymw2time, time2ymw
export ymwspan2weekspan, ymwplusweek

include(joinpath(@__DIR__, "coordinates.jl"))
export EARTH_RADIUS, EquirectangularReference, EQR
export sph2xy, xy2sph, γ_sphere, τ_sphere

include(joinpath(@__DIR__, "show.jl"))
export show