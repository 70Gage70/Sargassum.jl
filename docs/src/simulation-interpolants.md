# Interpolants

Sargassum.jl comes with 7 global variables (technically [Ref](https://docs.julialang.org/en/v1/base/c/#Core.Ref)s) that store computed interpolants. These are [`WATER_ITP`](@ref), [`WIND_ITP`](@ref), [`STOKES_ITP`](@ref), [`WAVES_ITP`](@ref), [`NUTRIENTS_ITP`](@ref), [`TEMPERATURE_ITP`](@ref) and [`LAND_ITP`](@ref). These variables are initially undefined but default interpolants for the year 2018 are available for download directly from within the package. These default interpolants are useful for testing purposes and for simulations, but are not strictly required.

Interpolants are [`InterpolatedField`](@ref) objects. Refer to the `InterpolatedField` documentation for the full details of this object. Here we will use the interfacing functions that will allow us to avoid dealing with the details.

## Constructing the Default Interpolants

The raw data that the interpolants depend on must first be downloaded, and then the interpolants themselves must be constructed. This process only needs to happen once. The main function to accomplish this is [`itps_default_construct`](@ref). This function takes no argument, but has a keyword `download`, such that if `download = true` is passed, the raw data will be downloaded. If the data have already been downloaded, `itps_default_construct` will rebuild the interpolants. An easy way to check if you have the default interpolants loaded is to simply run `WATER_ITP`,

```@setup ints-1
using Sargassum
```

```@example ints-1
WATER_ITP
```

!!! tip
    Did you run `WATER_ITP` and get no output? Try running `itps_default_construct()`. If this doesn't work, then run `itps_default_construct(download = true)`, which will download roughly 1.2 GB of data.

We see that several useful pieces of information have been printed out that let us know the variables, fields and limits that define the interpolant. The other interpolants can be inspected in the same way.

## Inspecting Interpolants

The primary elements of an [`InterpolatedField`](@ref) are dimensions (things like `x`, `y` and `t`) and fields (things like velocity and temperature). We can use [`dims`](@ref), [`fields`](@ref) and [`boundary`](@ref) to quickly inspect these.

```@example ints-1
dims(WATER_ITP)
```

```@example ints-1
fields(WATER_ITP)
```

```@example ints-1
boundary(WATER_ITP)
```

We see each dimension and field along with its units. The `boundary` function prints its output in the form `(lon_min, lon_max, lat_min, lat_max, time_min, time_max)` for time-dependent fields and `(lon_min, lon_max, lat_min, lat_max)` for time-independent fields.

!!! tip
    Why does `boundary` print longitudes and latitudes if `dims` indicates that the fields `:x` and `:y` have units of `km`? The answer is that `InterpolatedFields` are assumed to the in equirectangular coordinates, since these are the coordinates expected by the differential equations we eventually integrate. However, these coordinates are hard to parse, so they are converted to spherical coordinates before printing.

We can access the actual value of dimensions and fields using the [`dim`](@ref) and [`field`](@ref) functions, respectively. The first argument to each is the `InterpolatedField` and the second argument is one of the `Symbol`s in the output of `dims` or `fields`.

```@example ints-1
x_water = dim(WATER_ITP, :x)
y_water = dim(WATER_ITP, :y)
t_water = dim(WATER_ITP, :t)
```

```@example ints-1
u_water = field(WATER_ITP, :u)
size(u_water) # just print the size, since the actual array is huge
```

Note that the order that the dimensions appear in in the output of `dims` is the same order that they are defined for the `fields`. Here, `field(WATER_ITP, :u)` is the interpolant of a three dimensional array where the first dimension corresponds to `:x`:, the second to `:y` and the third to `:t`.

The interpolant fields can be called like functions.

```@example ints-1
pt = x_water[10], y_water[10], t_water[10]
u_water(x_water[10], y_water[10], t_water[10])
```

Finally, a field from an `InterpolatedField` can be quickly visualized with [`viz`](@ref),

```@example ints-1
viz(WATER_ITP, :u)
```

## Building Your Own Interpolants

Here we will describe the functions that allow the construction of interpolants from raw data. We will recreate `WIND_ITP` from scratch to see how this is done. In order to follow this tutorial, the default interpolants should be downloaded. The first step is to locate the NetCDF file that contains the data. For this we use the variable [`Sargassum._ITPS_RAW_SCRATCH`](@ref) which is generally not intended to be user-facing, but suffice to say that the following command will retrieve the path to the required NetCDF field.

```@setup ints-2
using Sargassum
using NetCDF
using Unitful
using Dates
using JLD2
```

```@example ints-2
infile = joinpath(Sargassum._ITPS_RAW_SCRATCH.x, "wind.nc")
```

Now, we will use the Julia package [`NetCDF`](https://github.com/JuliaGeo/NetCDF.jl) to inspect this file via the `ncinfo` function.

```@example ints-2
using NetCDF
ncinfo(infile)
```

This prints a lot of information, and we should take particular note of 

The names and units of the dimensions
- `latitude` in degrees north
- `longitude` in degrees east
- `time` in hours since `1900-01-01`

The names and units of the fields
- `u10` in m/s
- `v10` in m/s

Click the tabs to see the steps of the construction.

::: tabs

== 1. GriddedField

To begin construction of the interpolant, we start with a [`GriddedField`](@ref) whose job it is to hold the raw data and variable definitions before the actual interpolation in performed. The `GriddedField` constructor takes a single argument, the number of dimensions of the field in question. In this case, `3` since we have a time-dependent field.

```julia
using Unitful
using Dates
gf = GriddedField(3)
```

== 2. Adding spatial dimensions

Next we apply [`add_spatial_dimension!`](@ref) to populate `gf` with the longitude and latitude. The signature for `add_spatial_dimension!` is

```julia
add_spatial_dimension!(gf, infile, dim_name_in, dim_name_out, dim_units_in, dim_units_out; transform)
```

- `gf`: The `GriddedField`.
- `infile`: The `NetCDF` file holding the raw data.
- `dim_name_in`: The name (as a `String`) of the dimension. In our case this will be `"longitude"` and `"latitude"`.
- `dim_name_out`: The name (as a `Symbol`) of the output dimension. In our case this will be `:lon` and `:lat`.
- `dim_units_in`: The units of the dimension. In this case, it is `u"°"`.
- `dim_units_out`: The kind of quantity this is; should be one of the keys of [`UNITS`](@ref). In this case, it is `"degrees"`.

Therefore, we have

```julia
add_spatial_dimension!(gf, infile, "longitude", :lon, u"°", "degrees")
add_spatial_dimension!(gf, infile, "latitude", :lat, u"°", "degrees")
```

== 3. Adding time dimensions

Next we apply [`add_temporal_dimension!`](@ref) to populate `gf` with the time variable. The signature for `add_temporal_dimension!` is

```julia
add_temporal_dimension!(gf, infile, time_name_in, time_name_out, time_start, time_period; transform, force)
```

- `gf`: The `GriddedField`.
- `infile`: The `NetCDF` file holding the raw data.
- `time_name_in`: The name (as a `String`) of the dimension. In our case this will be `"time"`.
- `time_name_out`: The name (as a `Symbol`) of the output dimension. In our case this will be `:t`.
- `time_start` and `time_period`: The units of the time dimension are `time_period` since `time_start`. In our case, `time_period` will be `u"hr"` and `time_start` will be `DateTime(1900, 1, 1)`.

Therefore, we have

```julia
add_temporal_dimension!(gf, infile, "time", :t, DateTime(1900, 1, 1), u"hr")
```

== 4. Adding fields

Next we apply [`add_field!`](@ref) to populate `gf` with the actual fields - velocities in this case. The signature of `add_field!` is 

```julia
add_field!(gf, infile, field_name_in, field_name_out, field_units_in, field_units_out; kwargs...)
```

- `gf`: The `GriddedField`.
- `infile`: The `NetCDF` file holding the raw data.
- `field_name_in`: The name (as a `String`) of the field. In our case this will be `"u10"` and `"v10"`.
- `field_name_out`: The name (as a `Symbol`) of the output field. In our case this will be `":u"` and `":v"`.
- `field_units_in`: The units of the field. In this case, it is `u"m/s"`.
- `field_units_out`: The kind of quantity this is; should be one of the keys of [`UNITS`](@ref). In this case, it is `"speed"`.

Therefore, we have

```julia
add_field!(gf, infile, "u10", :u, u"m/s", "speed")
add_field!(gf, infile, "v10", :v, u"m/s", "speed")
```

== 5. Post-processing

We now apply the post-processing functions [`ranges_increasing!`](@ref) and [`sph2xy!`](@ref). The function `ranges_increasing!` ensures that the dimensions are increasing lists. It is not required if the dimensions are already increasing, but is very inexpensive. Since the dimensions are longitude and latitude (spherical coordinates), we use `sph2xy!` to convert the dimensions to equirectangular coordinates as required by the final field.

```julia
ranges_increasing!(gf)
sph2xy!(gf)
```

== 6. InterpolatedField

The last thing required is to compute the `InterpolatedField`. Since this is a time-dependent field, material derivatives will be required. These can be added using [`add_derivatives!`](@ref).

```julia
itp = InterpolatedField(gf)
add_derivatives!(itp)
```

== 7. Saving

Now that the `InterpolatedField` is created, we should save it for future use. For this we use the Julia package [`JLD2`](https://github.com/JuliaIO/JLD2.jl). The relevant function is `jldsave(filename, variable_name = variable)`. We should use `WIND_ITP` as the variable name to be consistent with the expected interpolant names.


```julia
wind_test_file = "WIND_ITP_TEST.jld2"
jldsave(wind_test_file, WIND_ITP = itp)
```

:::

## Loading Your Own Interpolants

We will use the interpolant created in the previous section as an example, i.e. we assume there is a file `wind_test_file = "WIND_ITP_TEST.jld2"` in the current working directory. We can load the interpolant into memory using `load(file, variable)` from `JLD2`. 

```julia
wind_itp_test = load(wind_test_file, "WIND_ITP")
```

To "activate" this interpolant, we must replace the current wind interpolant. This is accomplished using [`update_interpolant!`],

```julia
update_interpolant!(WIND_ITP, wind_itp_test)
```