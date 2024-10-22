"""
    const EARTH_RADIUS

The radius of the Earth, equal to `6371 km`.
"""
const EARTH_RADIUS = 6371.0 * u"km"

"""
    EquirectangularReference{U}

A container for the reference longitude and latitude of an equirectangular projection.

### Fields

- `lon0`: The standard longitude degrees (East/West).
- `lat0`: The standard latitude degrees (North/South).
- `R`: The radius of the Earth. The units of this quantity are the units of the equirectangular coordinates.

### Constructor

    EquirectangularReference(; lon0 = -75.0, lat0 = 10.0, units = UNITS["distance"])

### Example

To measure distances in meters,  

```julia
eqr = EquirectangularReference(units = u"m")
```
"""
struct EquirectangularReference{U<:Unitful.AbstractQuantity}
    lon0::Float64
    lat0::Float64
    R::U

    function EquirectangularReference(; lon0::Real = -75.0, lat0::Real = 10.0, units::Unitful.Unitlike = UNITS["distance"])
        @argcheck -180.0 <= lon0 <= 180.0 "The longitude must be between -180 degrees and 180 degrees."
        @argcheck -90 <= lat0 <= 90 "The latitude must be between -90 degrees and 90 degrees."
    
        R = uconvert(units, EARTH_RADIUS)
    
        return new{typeof(R)}(lon0, lat0, R)
    end
end

"""
    const EQR
    
The [`EquirectangularReference`](@ref) used during all conversions. This is a `Ref`, use `EQR.x` to acess the actual `EquirectangularReference`.

### Defaults

- `lon0`: -75.0 degrees
- `lat0`: 10.0 degrees
- `R`: 6731 km 
"""
const EQR = Ref{EquirectangularReference}(EquirectangularReference())

"""
    sph2xy(lon, lat; eqr = EQR.x)

Compute planar coordinates `[x, y]` from spherical coordinates `(lon, lat)` [deg E/W, deg N/S] using [`EquirectangularReference`](@ref), `eqr`, default [`EQR`](@ref).

The units of `x` and `y` the same as `eqr.R`.

### Further Methods

    sph2xy(lon_range, lat_range; eqr = EQR)
    
where `lon_range` and `lat_range` are `AbstractRange`. Returns `(x_range, y_range)`.

    sph2xy(lon_lat; eqr = EQR) 
    
where `lon_lat` is a `2 x N` `Matrix. Returns a result in the same shape as the input.
"""
function sph2xy(lon::Real, lat::Real; eqr::EquirectangularReference = EQR.x)
    @argcheck -180.0 <= lon <= 180.0 "The longitude must be between -180 degrees and 180 degrees."
    @argcheck -90 <= lat <= 90 "The latitude must be between -90 degrees and 90 degrees."

    lon0, lat0, R = (eqr.lon0, eqr.lat0, eqr.R.val)
    deg2rad = π/180

    x = R*(lon - lon0)*deg2rad*cos(lat0*deg2rad)
    y = R*(lat - lat0)*deg2rad

    return [x, y]
end

function sph2xy(lon_range::AbstractRange, lat_range::AbstractRange; eqr::EquirectangularReference = EQR.x)
    # uses the fact that the translation between eqr and spherical is linear
    lonmin, latmin = sph2xy(first(lon_range), first(lat_range), eqr = eqr)
    lonmax, latmax = sph2xy(last(lon_range), last(lat_range), eqr = eqr)

    return  (
            range(start = lonmin, length = length(lon_range), stop = lonmax), 
            range(start = latmin, length = length(lat_range), stop = latmax)
            )
end

function sph2xy(lon_lat::Matrix{T}; eqr::EquirectangularReference = EQR.x) where {T<:Real}
    @argcheck size(lon_lat, 1) == 2 "lon_lat should be an `2 x N` matrix"
    xy = zeros(T, size(lon_lat))
    
    for i = 1:size(lon_lat, 2)
        xy[:,i] .= sph2xy(lon_lat[1,i], lon_lat[2,i], eqr = eqr)
    end

    return xy
end


"""
    xy2sph(x, y, eqr = EQR.x)

Compute spherical coordinates `[lon, lat]` [deg] from rectilinear coordinates `(x, y)` using [`EquirectangularReference`](@ref) `eqr`, default [`EQR`](@ref).

The units of `x` and `y` should be the same as `eqr.R`.

### Further Methods

    xy2sph(x_range, y_range)
    
where `x_range` and `y_range` are `AbstractRange`. Returns `(lon_range, lat_range)`.

    xy2sph(xy) 
    
where `xy` is a `2 x N` `Matrix`. 
"""
function xy2sph(x::Real, y::Real; eqr::EquirectangularReference = EQR.x)
    lon0, lat0, R = (eqr.lon0, eqr.lat0, eqr.R.val)
    deg2rad = π/180
    rad2deg = 1/deg2rad

    lon = lon0 + rad2deg*x/(R*cos(lat0*deg2rad))
    lat = lat0 + rad2deg*y/R 

    return [lon, lat]
end

function xy2sph(x_range::AbstractRange, y_range::AbstractRange; eqr::EquirectangularReference = EQR.x)
    # uses the fact that the translation between eqr and spherical is linear
    xmin, ymin = xy2sph(first(x_range), first(y_range), eqr = eqr)
    xmax, ymax = xy2sph(last(x_range), last(y_range), eqr = eqr)

    return  (
            range(start = xmin, length = length(x_range), stop = xmax), 
            range(start = ymin, length = length(y_range), stop = ymax)
            )
end

function xy2sph(xy::Matrix{T}; eqr::EquirectangularReference = EQR.x) where {T<:Real}
    @argcheck size(xy, 1) == 2 "xy should be an `2 x N` matrix"
    lonlat = zeros(T, size(xy))
    
    for i = 1:size(xy, 2)
        lonlat[:,i] .= xy2sph(xy[1,i], xy[2,i], eqr = eqr)
    end

    return lonlat
end

function _y2lat(y::Real; eqr::EquirectangularReference = EQR.x)
    lat0, R = (eqr.lat0, eqr.R.val)
    deg2rad = π/180
    rad2deg = 1/deg2rad

    lat = lat0 + rad2deg*y/R

    return lat*deg2rad
end

"""
    γ_sphere(y; eqr = EQR.x, geometry = true)

Calculate the geometric correction factor `sec(lat_0) * cos(lat)`, converting `y` to `lat` automatically \
using [`EquirectangularReference`](@ref) `eqr`, default [`EQR`](@ref).

If `geometry == false`, `γ_sphere` is always equal to `1.0`.
"""
function γ_sphere(y::Real; eqr::EquirectangularReference = EQR.x, geometry::Bool = true)    
    return geometry ? sec(eqr.lat0*π/180) * cos(_y2lat(y, eqr = eqr)) : 1.0
end

"""
    τ_sphere(y; eqr = EQR.x, geometry = true)

Calculate the geometric correction factor `τ = tan(lat)/R` converting `y` to `lat` automatically \
using [`EquirectangularReference`](@ref) `eqr`, default [`EQR`](@ref).

If `geometry == false`, `τ_sphere` is always equal to `0.0`.
"""
function τ_sphere(y::Real; eqr::EquirectangularReference = EQR.x, geometry::Bool = true)    
    return geometry ? tan(_y2lat(y, eqr = eqr))/eqr.R.val : 0.0
end