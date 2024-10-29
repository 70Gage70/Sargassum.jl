# Units and Time

Here we describe how units and time are handled across Sargassum.jl. The bulk of unit definitions and conversions are handled through the Julia package [`Unitful`](https://github.com/PainterQubits/Unitful.jl). Occasionally, more advanced use of this package will require entering units, hence we review this process briefly.

## A Short Review of Unitful.jl
  
Define units with the syntax `u"unit_symbol_here"`. For example, meters, kilometer per day and degrees are defined respectively by

```@setup units-1
using Sargassum
using Unitful
using Dates
```

```@example units-1
u"m"
u"km/d"
u"°"
nothing # hide
```

Quantities are defined by multiplying a number by a unit,

```@example units-1
5.0 * u"m"
nothing # hide
```

Units are converted using the `uconvert(unit_target, quantity_to_convert)` function, e.g.

```@example units-1
uconvert(u"m", 2.0 * u"km") # convert 2km to m
```

## Units

All units are converted internally to a consistent unit based on its function according to the global dictionary [`UNITS`](@ref). 

```@example units-1
UNITS
```

For example, distances are measured in `UNITS["distance"]`, which is `km`. 

## Coordinates

`Sargassum.jl` uses both spherical (longitude/latitude) and equirectangular (x/y) coordinates as needed. The underlying physics equations must be integrated in equirectangular coordinates, but the user-facing coordinates are generally converted to spherical coordinates as much as possible.

In order to convert between spherical and equirectangular coordinates, a reference longitude `lon0` and latitude `lat0` are required. This is held by an [`EquirectangularReference`](@ref) object which can be constructed with `lon0` and `lat0` as kwargs,

```@example units-1
EquirectangularReference(lon0 = -75, lat0 = 10)
```

Note that the `EquirectangularReference` also has a field for the radius of the Earth, in units of `UNITS["distance"]`. There is a global reference [`EQR`](@ref) that is used by default for all conversions. This reference is generally appropriate for the Caribbean region. 

```@example units-1
EQR
```

The primary functions for conversion are [`sph2xy`](@ref) and [`xy2sph`](@ref). These can be applied to a variety of objects, refer to the full documentation for details. The most basic usage is `sph2xy(x, y; eqr = EQR)` and `xy2sph(x, y; eqr = EQR)`.

```@example units-1
x, y = sph2xy(-80, 15)
```

```@example units-1
xy2sph(x, y)
```

```@example units-1
x, y = sph2xy(-80, 15, eqr = EquirectangularReference(lon0 = -80, lat0 = 15))
```

```@example units-1
xy2sph(x, y, eqr = EquirectangularReference(lon0 = -80, lat0 = 15))
```

## Times

Specific times are defined using the [`Dates`](https://docs.julialang.org/en/v1/stdlib/Dates/) module. For `Sargassum.jl`, in almost all cases, the only function actually required is `DateTime(year, month, day)`, e.g.

```@example units-1
DateTime(2000, 1, 1) # January 1, 2000
```

All times are internally converted to `UNITS["times"]` (equal to days) since a reference time [`T_REF`](@ref)

```@example units-1
T_REF
```

Note that `T_REF` is a [Ref](https://docs.julialang.org/en/v1/base/c/#Core.Ref), i.e. its actual value is accessed using `T_REF.x` although this should generally not be required.

For conversions, the functions [`datetime2time`](@ref) and [`time2datetime`](@ref) are inverses.

```@example units-1
t = datetime2time(DateTime(2018, 4, 14))
```

```@example units-1
time2datetime(t)
```

The AFAI functionality of `Sargassum.jl` generally works in terms of weeks, rather than days. For this, [`ymw2time`](@ref) and [`time2ymw`](@ref) are inverses, acting on `(year, month, week)` tuples.

```@example units-1
ymw = time2ymw(t)
```

```@example units-1
ymw2time(ymw)
```

Note that only certain times can be converted to `(year, month, week)`, in particular the day of the month must be one of `[7, 14, 21, 28]`.

```julia
ymw = time2ymw(DateTime(2018, 4, 13)) # will error
```

## Spherical Geometry Corrections

There are two terms, [`γ_sphere`](@ref) and [`τ_sphere`](@ref) that take into account corrections required to the differential equations due to the sphericity of the Earth. These functions should not need to be accessed directly, but their effects can be turned off via the `geometry` kwarg of [`RaftParameters`](@ref).
