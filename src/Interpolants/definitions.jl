"""
    const WATER_ITP

The interpolant for ocean currents. This is a `Ref`, access or modify the actual interpolant with `WATER_ITP.x`.
"""
const WATER_ITP = Ref{InterpolatedField}()

"""
    const WIND_ITP

The interpolant for wind speed. This is a `Ref`, access or modify the actual interpolant with `WIND_ITP.x`.
"""
const WIND_ITP = Ref{InterpolatedField}()

"""
    const STOKES_ITP

The interpolant for Stokes drift velocity. This is a `Ref`, access or modify the actual interpolant with `STOKES_ITP.x`.
"""
const STOKES_ITP = Ref{InterpolatedField}()

"""
    const WAVES_ITP

The interpolant for wave height. This is a `Ref`, access or modify the actual interpolant with `WAVES_ITP.x`.
"""
const WAVES_ITP = Ref{InterpolatedField}()

"""
    const NUTRIENTS_ITP

The interpolant for ocean nitrogen content. This is a `Ref`, access or modify the actual interpolant with `NO3_ITP_ITP.x`.
"""
const NUTRIENTS_ITP = Ref{InterpolatedField}()

"""
    const TEMPERATURE_ITP

The interpolant for ocean temperature. This is a `Ref`, access or modify the actual interpolant with `TEMPERATURE_ITP.x`.
"""
const TEMPERATURE_ITP = Ref{InterpolatedField}()

"""
    const LAND_ITP

The interpolant for landmass location. This is a `Ref`, access or modify the actual interpolant with `LAND_ITP.x`.
"""
const LAND_ITP = Ref{InterpolatedField}()

"""
    itps_load(; dir = _ITPS_SCRATCH.x)

Attempt to load the interpolants in directory `dir`.

This assumes that there exists in this directory the following files, each containing a variable as follows

| File Name           | Variable Name     | 
|:--------------------|:------------------|
| WATER_ITP.jld2      | WATER_ITP         |
| WIND_ITP.jld2       | WIND_ITP          |
| STOKES_ITP.jld2     | STOKES_ITP        |
| WAVES_ITP.jld2      | WAVES_ITP         |
| NUTRIENTS_ITP.jld2  | NUTRIENTS_ITP     |
| TEMPERATURE_ITP.jld2| TEMPERATURE_ITP   |
| LAND_ITP.jld2       | LAND_ITP          |

"""
function itps_load(; dir::String = _ITPS_SCRATCH.x)
    try
        WATER_ITP.x = load(joinpath(dir, "WATER_ITP.jld2"), "WATER_ITP")
    catch
        error("Could not load `WATER_ITP`.")
    end

    try
        WIND_ITP.x = load(joinpath(dir, "WIND_ITP.jld2"), "WIND_ITP")
    catch
        error("Could not load `WIND_ITP`.")
    end

    try
        STOKES_ITP.x = load(joinpath(dir, "STOKES_ITP.jld2"), "STOKES_ITP")
    catch
        error("Could not load `STOKES_ITP`.")
    end

    try
        WAVES_ITP.x = load(joinpath(dir, "WAVES_ITP.jld2"), "WAVES_ITP")
    catch
        error("Could not load `WAVES_ITP`.")
    end

    try
        NUTRIENTS_ITP.x = load(joinpath(dir, "NUTRIENTS_ITP.jld2"), "NUTRIENTS_ITP")
    catch
        error("Could not load `NUTRIENTS_ITP`.")
    end

    try
        TEMPERATURE_ITP.x = load(joinpath(dir, "TEMPERATURE_ITP.jld2"), "TEMPERATURE_ITP")
    catch
        error("Could not load `TEMPERATURE_ITP`.")
    end

    try
        LAND_ITP.x = load(joinpath(dir, "LAND_ITP.jld2"), "LAND_ITP")
    catch
        error("Could not load `LAND_ITP`.")
    end

    return nothing
end