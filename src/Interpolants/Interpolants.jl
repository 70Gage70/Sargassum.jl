include(joinpath(@__DIR__, "main.jl"))
export GriddedField, InterpolatedField
export add_spatial_dimension!, add_temporal_dimension!, add_field!, ranges_increasing!, sph2xy!, add_derivatives!

include(joinpath(@__DIR__, "definitions.jl"))
export ITPS_DEFAULT_DIR
export WATER_ITP, WIND_ITP, WAVES_ITP, STOKES_ITP, LAND_ITP, TEMPERATURE_ITP, NUTRIENTS_ITP
export itps_load

include(joinpath(@__DIR__, "default.jl"))
export itps_default_construct

include(joinpath(@__DIR__, "interface.jl"))
export update_interpolant!, boundary, dim, dims, field, fields

include(joinpath(@__DIR__, "show.jl"))
export show