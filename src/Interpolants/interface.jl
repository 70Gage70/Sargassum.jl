"""
    update_interpolant!(itp, itp_new)

Update (replace) `itp` with `itp_new`, where `itp_new` should be an [`InterpolatedField`](@ref) and \
`itp` should be one of 

- `WATER_ITP`
- `WIND_ITP`
- `STOKES_ITP`
- `WAVES_ITP`
- `NUTRIENTS_ITP`
- `TEMPERATURE_ITP`
- `LAND_ITP`
"""
function update_interpolant!(itp::Ref{InterpolatedField}, itp_new::InterpolatedField)
    itp.x = itp_new
    return nothing
end

"""
    boundary(itp)

Return a the corners of the spatio-temporal box the interpolant is defined in.

If `itp` is time-dependent, return `(lon_min, lon_max, lat_min, lat_max, t_min, t_max)`.

If `itp` is time-independent, `(lon_min, lon_max, lat_min, lat_max)`.

Assumes that the `(x, y, t)` variables are named `(:x, :y, :t)`, respectively.

### Examples

```julia-repl
julia> (lon_min, lon_max, lat_min, lat_max, t_min, t_max) = boundary(WATER_ITP)
```

```julia-repl
julia> (lon_min, lon_max, lat_min, lat_max) = boundary(LAND_ITP)
```
"""
function boundary(itp::InterpolatedField)
	lon, lat = xy2sph(itp.dims[:x], itp.dims[:y]) .|> extrema
	lon = lon .|> x -> round(x, sigdigits = 4)
	lat = lat .|> x -> round(x, sigdigits = 4)

    if :t ∈ keys(itp.dims)
	    tmin, tmax = extrema(itp.dims[:t]) .|> time2datetime .|> string
	    return (lon[1], lon[2], lat[1], lat[2], tmin, tmax)
    else
        return (lon[1], lon[2], lat[1], lat[2])
    end
end

boundary(ritp::Ref{InterpolatedField}) = boundary(ritp.x)

"""
    dim(itp, name)

Return the variable of `itp` whose value corresponds to the dimension indicated by `name`.

Use [`dims`](@ref) to see a list of possible values of `name`.

### Example

```julia-repl
julia> x = dim(WATER_ITP, :x) # the x values defining interpolant knots
```
"""
dim(itp::Ref{InterpolatedField}, name::Symbol) = itp.x.dims[name] 

"""
    dims(itp)

Return the list of variable name/unit pairs of `itp`.

### Example

```julia-repl
julia> dims(WATER_ITP)
```
"""
dims(itp::Ref{InterpolatedField}) = itp.x.dims_names

"""
    field(itp, name)

Return the sub-interpolant of `itp` whose value corresponds to the field indicated by `name`.

Use [`fields`](@ref) to see a list of possible values of `name`.

### Example

```julia-repl
julia> v_x = field(WATER_ITP, :u) # the x component of the water velocity
julia> v_x(1, 2, 3) # evaluate it at `(x, y, t) = (1, 2, 3)`.
```
"""
field(itp::Ref{InterpolatedField}, name::Symbol) = itp.x.fields[name] 

"""
    fields(itp)

Return the list of field name/unit pairs of `itp`.

### Example

```julia-repl
julia> fields(WATER_ITP)
```
"""
fields(itp::Ref{InterpolatedField}) = itp.x.fields_names