"""
    struct GriddedField{N, T, U}

A container for gridded data, possibly time-dependent.

### Fields
- `dims_names`: A `Vector` of `Tuple{Symbol, Unitful.Unitlike}`s such that `dims_names[i][1]` is the `i`th dimension of `fields` and \
    `dims_names[i][2]` gives the units of the `i`th dimension.
- `dims`: A `Dict` mapping variable names to ranges they take.
- `fields_names`: A `Vector` of `Tuple{Symbol, Unitful.Unitlike}`s such that `fields_names[i][1]` is the `i`th field and \
`fields_names[i][2]` gives its units.
- `fields`: A `Dict` mapping field names to their arrays.

### Example

If `GriddedField.dims_names == [(:x, u"km"), (:y, u"km"), (:t, u"d")]`, this implies that the order of the dimensions of each field is 
`(x, y, t)` and further that the units of `x, y` and `t` are `km, km` and `d`, respectively.

### Constructor

    GriddedField(n_dims; floats = Float64, ints = Int64)
    
where `n_dims` is the number of dimensions of the field and `floats` and `ints` give the datatypes used. For example \
a water velocity field would have `n_dims = 3` from `(x, y, t)`. A land interpolant would have `n_dims = 2` from \
`(x, y)`, i.e. the land location is not time-dependent.
"""
struct GriddedField{N, T<:Real, U<:Integer}
    dims_names::Vector{Tuple{Symbol, UFUL}}
    dims::Dict{Symbol, StepRangeLen{T, Base.TwicePrecision{T}, Base.TwicePrecision{T}, U}}
    fields_names::Vector{Tuple{Symbol, UFUL}}
    fields::Dict{Symbol, Array{T, N}}

    function GriddedField(
        n_dims::Integer; 
        floats::DataType = Float64, 
        ints::DataType = Int64)

        N = n_dims
        T = floats
        U = ints

        dims_names = Vector{Tuple{Symbol, UFUL}}()
        dims = Dict{Symbol, StepRangeLen{T, Base.TwicePrecision{T}, Base.TwicePrecision{T}, U}}()
        fields_names = Vector{Tuple{Symbol, UFUL}}()
        fields = Dict{Symbol, Array{T, N}}()

        return new{N, T, U}(dims_names, dims, fields_names, fields)
    end
end


"""
    add_spatial_dimension!(gf, infile, dim_name_in, dim_name_out, dim_units_in, dim_units_out; transform)

Add a new spatial dimension to `gf::GriddedField` with data read from a NetCDF or MAT file `infile`.

The new dimension appears last in the list of dimension names.

### Arguments

- `gf`: The [`GriddedField`](@ref) to be modified.
- `infile`: The path to the NetCDF/MAT file.
- `dim_name_in`: A `String` giving the name of the dimension to read in as it appears in the NetCDF/MAT file.
- `dim_name_out`: A `Symbol` giving the name of the added dimension in `gf`.
- `dim_units_in`: A `Unitful.Unitlike` giving the units of the dimension as they appear in the NetCDF/MAT file.
- `dim_units_out`: A `String` giving the kind of quantity being read; should be one of `keys(UNITS)`.

### Optional Arguments

- `transform`: If provided, the dimension will be mapped according to `transform` before any other steps are taken. Default `nothing`.
- `force`: If `true`, the range will be constructed even if the vector isn't linearly spaced by linear interpolation preserving the length. Default `false`.
"""
function add_spatial_dimension!(
    gf::GriddedField,
    infile::String,
    dim_name_in::String,
    dim_name_out::Symbol,  
    dim_units_in::UFUL, 
    dim_units_out::String;
    transform::Union{Function, Nothing} = nothing,
    force::Bool = false)

    extension = infile[findlast(==('.'), infile)+1:end]
    @argcheck extension in ["nc", "mat"] "Require a .nc or .mat file."
    @argcheck dim_units_out in keys(UNITS) "unit type not recognized, type `UNITS` to see options"

    u_out = UNITS[dim_units_out]

    dim = nothing
    if extension == "nc"
        dim = ncread(infile, dim_name_in)
    elseif extension == "mat"
        dim = matread(infile)[dim_name_in]
        dim = ndims(dim) == 2 && (size(dim, 2) == 1 || size(dim, 1) == 1) ? vec(dim) : dim # convert from Matrix to Vector
    end
    (transform !== nothing) && (dim = map(transform, dim))
    dim = dim * uconvert(u_out, 1.0 * dim_units_in).val
    dim = vec2range(dim, force = force)

    push!(gf.dims_names, (dim_name_out, u_out))
    gf.dims[dim_name_out] = dim

    return nothing
end

"""
    add_temporal_dimension!(gf, infile, time_name_in, time_name_out, time_start, time_period; transform, force)

Add a new temporal dimension to `gf::GriddedField` with data read from a NetCDF or MAT file `infile`.

The new dimension appears last in the list of dimension names.

### Arguments

- `gf`: The [`GriddedField`](@ref) to be modified.
- `infile`: The path to the NetCDF/MAT file.
- `time_name_in`: A `String` giving the name of the time dimension to read in as it appears in the NetCDF/MAT file.
- `time_name_out`: A `Symbol` giving the name of the added time dimension in `gf`.
- `time_start`: A `DateTime` giving the reference time of the time dimension, e.g. if the \
units of the NetCDF/MAT are `hours since 1990-01-01` then `time_start == DateTime(1900, 1, 1)`.
- `time_period`: A `Unitful.FreeUnits` giving the time step (units) of the time dimension. \
E.g. if the units of the NetCDF/MAT are `hours since 1990-01-01` then `time_period == u"hr"`.

### Optional Arguments

- `transform`: If provided, the dimension will be mapped according to `transform` before any other steps are taken. Default `nothing`.
- `force`: If `true`, the range will be constructed even if the vector isn't linearly spaced by linear interpolation preserving the length. Default `false`.
"""
function add_temporal_dimension!(
    gf::GriddedField,
    infile::String,
    time_name_in::String,
    time_name_out::Symbol,  
    time_start::DateTime,
    time_period::Unitful.FreeUnits{N, Unitful.𝐓, nothing};
    transform::Union{Function, Nothing} = nothing,
    force::Bool = false) where {N}

    extension = infile[findlast(==('.'), infile)+1:end]
    @argcheck extension in ["nc", "mat"] "Require a .nc or .mat file."

    u_out = UNITS["time"]

    time = nothing
    if extension == "nc"
        time = ncread(infile, time_name_in)
    elseif extension == "mat"
        time = matread(infile)[time_name_in]
        time = ndims(time) == 2 && (size(time, 2) == 1 || size(time, 1) == 1) ? vec(time) : time # convert from Matrix to Vector
    end
    time = float(time)
    (transform !== nothing) && (time = map(transform, time))
    time = map(x -> time_start + x * time_period - T_REF.x, time)
    time = map(x -> uconvert(u_out, x).val, time) |> float
    time = vec2range(time, force = force)

    push!(gf.dims_names, (time_name_out, u_out))
    gf.dims[time_name_out] = time

    return nothing    
end

"""
    add_field!(gf, infile, field_name_in, field_name_out, field_units_in, field_units_out; take_axes, permutation, scale_factor_name, add_offset_name, missings_name, missings_replacement)

Add a new field to `gf::GriddedField` with data read from a NetCDF or MAT file `infile`.

The new dimension appears last in the list of field names.

### Arguments

- `gf`: The [`GriddedField`](@ref) to be modified.
- `infile`: The path to the NetCDF/MAT file.
- `field_name_in`: A `String` giving the name of the field to read in as it appears in the NetCDF/MAT file.
- `field_name_out`: A `Symbol` giving the name of the added field in `gf`.
- `field_units_in`: A `Unitful.Unitlike` giving the units of the field as they appear in the NetCDF/MAT file.
- `field_units_out`: A `String` giving the kind of quantity being read; should be one of `keys(UNITS)`.

### Optional Arguments

- `take_axes`: If provided, only the selected elements will be taken via `field[take_axes...]`. \
    For example, if the `field` is four dimensional, passing `take_axes = [:,:,1,:]` would result in a three dimensional field with \
    dimensions 1, 2 and 4 preserved - indexed on the first element of the third dimension. Default `nothing`.
- `permutation`: If provided, the field will be permuted according to `permutation`. Applied AFTER `take_axes`. Default `nothing`.
- `scale_factor_name`: The name of the scale factor, only for NetCDF files. If no scale factor is found, it is taken to be `1`. Default `"scale_factor"`.
- `add_offset_name`: The name of the additive offset, only for NetCDF files. If no additive offset is found, it is taken to be `0`. Default `"add_offset"`.
- `missings_name`: A vector of names of missing/fill/extra values, only for NetCDF files. Each such value will be replaced by `missings_replacement` if found. Default `["_FillValue", "missing_value"]`.
- `missings_replacement`: `missings_name` replaces the missing/fill/extra values with this. Default `0.0`.
"""
function add_field!(
    gf::GriddedField,
    infile::String,
    field_name_in::String,
    field_name_out::Symbol,  
    field_units_in::UFUL, 
    field_units_out::String;
    permutation::Union{NTuple{N, I}, Nothing} = nothing,
    take_axes::Union{Vector{<:Any}, Nothing} = nothing,
    scale_factor_name::String = "scale_factor",
    add_offset_name::String = "add_offset",
    missings_name::Vector{String} = ["_FillValue", "missing_value"],
    missings_replacement::Real = 0.0) where {N, I<:Integer}

    extension = infile[findlast(==('.'), infile)+1:end]
    @argcheck extension in ["nc", "mat"] "Require a .nc or .mat file."
    @argcheck field_units_out in keys(UNITS) "unit type not recognized, type `UNITS` to see options"

    u_out = UNITS[field_units_out]

    field, missing_vals, scale_factor, add_offset = zeros(4) 

    if extension == "nc"
        field = ncread(infile, field_name_in) |> float
        missing_vals = [ncgetatt(infile, field_name_in, mn) for mn in missings_name]
        scale_factor = ncgetatt(infile, field_name_in, scale_factor_name) |> x -> x === nothing ? 1.0 : x
        add_offset = ncgetatt(infile, field_name_in, add_offset_name) |> x -> x === nothing ? 0.0 : x
    elseif extension == "mat"
        field = matread(infile)[field_name_in] |> float
        missing_vals = [NaN]
        scale_factor = 1.0
        add_offset = 0.0
    end

    unit_factor = uconvert(u_out, 1.0 * field_units_in).val

    for idx in eachindex(field)
        val = field[idx]
        field[idx] = (val in missing_vals) ? missings_replacement : unit_factor*(scale_factor*val + add_offset)
    end

    (take_axes !== nothing) && (field = field[take_axes...])
    (permutation !== nothing) && (field = permutedims(field, permutation))

    push!(gf.fields_names, (field_name_out, u_out))
    gf.fields[field_name_out] = field

    return nothing     
end

"""
    ranges_increasing!(gf)

Moddify `gf::GriddedField` in place so that each dimension has variable which are increasing. Fields are automatically reversed if necessary.
"""
function ranges_increasing!(gf::GriddedField)
    for i = 1:length(gf.dims_names)
        dim_name = gf.dims_names[i][1]
        dim = gf.dims[dim_name]
        if step(dim) < 0
            gf.dims[dim_name] = reverse(dim)
            for name in keys(gf.fields)
                gf.fields[name] = reverse(gf.fields[name], dims = i)
            end
        end
    end

    return nothing
end


"""
    sph2xy!(gf; lon_name, lat_name, x_name, y_name)

Moddify `gf::GriddedField` in place so that its longitudinal and latitudinal dimensions are converted to equirectangular coordinates.

### Optional Arguments

- `lon_name`: A `Symbol` giving the name of the longitudinal variable in `gf`.
- `lat_name`: A `Symbol` giving the name of the latitudinal variable in `gf`.
- `x_name`: A `Symbol` giving the name of the equirectangular `x` variable to be used in the modified `gf`.
- `y_name`: A `Symbol` giving the name of the equirectangular `y` variable to be used in the modified `gf`.
"""
function sph2xy!(
    gf::GriddedField;
    lon_name::Symbol = :lon, 
    lat_name::Symbol = :lat, 
    x_name::Symbol = :x, 
    y_name::Symbol = :y)

    lon = gf.dims[lon_name]
    lat = gf.dims[lat_name]
    x, y = sph2xy(lon, lat)

    idx_lon = findfirst(x -> x[1] == lon_name, gf.dims_names)
    gf.dims_names[idx_lon] = (x_name, unit(EQR.x.R))
    delete!(gf.dims, lon_name)
    gf.dims[x_name] = x

    idx_lat = findfirst(x -> x[1] == lat_name, gf.dims_names)
    gf.dims_names[idx_lat] = (y_name, unit(EQR.x.R))
    delete!(gf.dims, lat_name)
    gf.dims[y_name] = y

    return nothing
end

"""
    struct InterpolatedField{N, T, U, I}

A container for interpolants of gridded data, possibly time-dependent.

### Fields
- `dims_names`: A `Vector` of `Tuple{Symbol, Unitful.Unitlike}`s such that `dims_names[i][1]` is the `i`th dimension of `fields` and \
    `dims_names[i][2]` gives the units of the `i`th dimension.
- `dims`: A `Dict` mapping variable names to ranges they take.
- `fields_names`: A `Vector` of `Tuple{Symbol, Unitful.Unitlike}`s such that `fields_names[i][1]` is the `i`th field and \
`fields_names[i][2]` gives its units.
- `fields`: A `Dict` mapping field names to their interpolants.

### Example

If `InterpolatedField.dims_names == [(:x, u"km"), (:y, u"km"), (:t, u"d")]`, this implies that the order of the dimensions of each field is 
`(x, y, t)` and further that the units of `x, y` and `t` are `km, km` and `d`, respectively.

### Constructor

    InterpolatedField(gf; interpolant_type = "cubic", extrapolate_value = 0.0)
    
where `gf` is a [`GriddedField`](@ref) and with the optional arguments 

- `interpolant_type`: Two convenience flags are provided, `"cubic"` and `"nearest"` which refer to cubic BSpline and nearest-neighbor interpolation, \
    respectively. Alternatively, any `Interpolations.InterpolationType` can be provided. Default `"cubic"`.
- `extrapolate_value`: A constant extrapolation is performed with this value. Default `"0.0"`.

### Plotting

This object can be [`viz`](@ref) and [`viz!`](@ref).
"""
struct InterpolatedField{N, T<:Real, U<:Integer, I<:AbstractInterpolation}
    dims_names::Vector{Tuple{Symbol, UFUL}}
    dims::Dict{Symbol, StepRangeLen{T, Base.TwicePrecision{T}, Base.TwicePrecision{T}, U}}
    fields_names::Vector{Tuple{Symbol, UFUL}}
    fields::Dict{Symbol, I}

    function InterpolatedField(
        gf::GriddedField;
        interpolant_type::Union{String, Interpolations.InterpolationType} = "cubic",
        extrapolate_value::Real = 0.0)

        if interpolant_type isa String
            @argcheck interpolant_type in ["cubic", "nearest"] "kwarg `interpolant_type` should be either $("cubic"), $("nearest") or an `Interpolations.InterpolationType`."

            if interpolant_type == "cubic"
                spline = BSpline(Cubic(Interpolations.Line(OnGrid())))
            elseif interpolant_type == "nearest"
                spline = BSpline(Constant)
            end
        else
            spline = interpolant_type
        end

        vars = [gf.dims[name[1]] for name in gf.dims_names]
        field_names = [name[1] for name in gf.fields_names]
        interps = [
            extrapolate(
                Interpolations.scale(
                    Interpolations.interpolate(gf.fields[name], spline), 
                vars...), 
            extrapolate_value) 
            for name in field_names]
        fields_dict = Dict(field_names .=> interps)
    
        N, T, U = typeof(gf).parameters
        I = typeof(interps[1])

        return new{N, T, U, I}(gf.dims_names, gf.dims, gf.fields_names, fields_dict)
    end
end

"""
    add_derivatives(itrf; interpolant_type, extrapolate_value, xyt_names, vxvy_names, Dx_Dy_vort_names, geometry)

Add three additional fields to [`InterpolatedField`](@ref), namely the x and y components 
of the material derivative and the vorticity.

### Arguments 

- `itrf`: An [`InterpolatedField`](@ref). The field should have `x`, `y` and `t` variables along with `x` and `y` components 
    of the corresponding field (e.g. water currents.)

### Optional Arguments 

- `interpolant_type`: Two convenience flags are provided, `"cubic"` and `"nearest"` which refer to cubic BSpline and 
    nearest-neighbor interpolation, respectively. Alternatively, any `Interpolations.InterpolationType` can be provided. Default `"cubic"`.
- `extrapolate_value`: A constant extrapolation is performed with this value. Default `"0.0"`.
- `xyt_names`: A `Tuple` with three symbols, corresponding to the `x`,` y` and `t` variables in that order. Default `(:x, :y, :t)`.
- `vxvy_names`: A `Tuple` with two symbols, corresponding to the `x` and `y` components of the vector field, in that order. Default `(:u, :v)`.
- `Dx_Dy_vort_names`: A `Tuple` with three symbols, corresponding to the `x` component of the material derivative, the 
    `y` component of the material derivative and the vorticity, in that order. Default `(:DDt_x, :DDt_y, :vorticity)`.
- `geometry`: If `true`, include factors that take into account the spherical geometry of the Earth. Default `true`.
""" 
function add_derivatives!(
    itrf::InterpolatedField;
    interpolant_type::Union{String, Interpolations.InterpolationType} = "cubic", 
    extrapolate_value::Real = 0.0,
    xyt_names::NTuple{3, Symbol} = (:x, :y, :t),
    vxvy_names::NTuple{2, Symbol} = (:u, :v),
    Dx_Dy_vort_names::NTuple{3, Symbol} = (:DDt_x, :DDt_y, :vorticity),
    geometry::Bool = true)

    if interpolant_type isa String
        @argcheck interpolant_type in ["cubic", "nearest"] "kwarg `interpolant_type` should be either $("cubic"), $("nearest") or an `Interpolations.InterpolationType`."

        if interpolant_type == "cubic"
            spline = BSpline(Cubic(Interpolations.Line(OnGrid())))
        elseif interpolant_type == "nearest"
            spline = BSpline(Constant)
        end
    else
        spline = interpolant_type
    end

    x_var, y_var, t_var = [itrf.dims[name] for name in xyt_names]
    vx, vy = [itrf.fields[name] for name in vxvy_names]

    γ(y) = γ_sphere(y, geometry = geometry)
    τ(y) = τ_sphere(y, geometry = geometry)

    DDx(x, y, t) = gradient(vx, x, y, t) ⋅ [vx(x, y, t)/γ(y), vy(x, y, t), 1.0] - τ(y)*vx(x, y, t)*vy(x, y, t)
    DDy(x, y, t) = gradient(vy, x, y, t) ⋅ [vx(x, y, t)/γ(y), vy(x, y, t), 1.0] + τ(y)*vx(x, y, t)^2
    vort(x, y, t) = gradient(vy, x, y, t)[1]/γ(y) - gradient(vx, x, y, t)[2] + τ(y)*vx(x, y, t)

    data_ddx = [DDx(x, y, t) for x in x_var, y in y_var, t in t_var]
    data_ddy = [DDy(x, y, t) for x in x_var, y in y_var, t in t_var]
    data_vort = [vort(x, y, t) for x in x_var, y in y_var, t in t_var]

    itp_ddx = extrapolate(
        Interpolations.scale(
                Interpolations.interpolate(data_ddx, spline), 
            x_var, y_var, t_var), 
        extrapolate_value) 

    itp_ddy = extrapolate(
        Interpolations.scale(
            Interpolations.interpolate(data_ddy, spline), 
        x_var, y_var, t_var), 
    extrapolate_value) 

    itp_vort = extrapolate(
        Interpolations.scale(
            Interpolations.interpolate(data_vort, spline), 
        x_var, y_var, t_var), 
    extrapolate_value)     

    merge!(itrf.fields, Dict(Dx_Dy_vort_names .=> (itp_ddx, itp_ddy, itp_vort)))

    out_units = findfirst(x -> x[1] == xyt_names[3], itrf.dims_names) |> x -> itrf.dims_names[x][2]^(-2)
    for name in Dx_Dy_vort_names
        push!(itrf.fields_names, (name, out_units))
    end

    return nothing
end