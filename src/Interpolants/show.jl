function Base.show(io::IO, x::Union{GriddedField, InterpolatedField})
    if x isa GriddedField
        println(io, "GriddedField")
    else
        println(io, "InterpolatedField")
    end

    print(io, "Dimensions = ")
    for y in x.dims_names
        print("$(y) ")
    end

    println()    

    print(io, "Fields = ")
    for y in x.fields_names
        print("$(y) ")
    end

    println()

    if (:x in keys(x.dims)) && (:y in keys(x.dims))
        lon, lat = xy2sph(x.dims[:x], x.dims[:y]) .|> extrema
        lon = lon .|> x -> round(x, sigdigits = 4)
        lat = lat .|> x -> round(x, sigdigits = 4)
        println(io, "lon/lat ∈ ($(lon[1]), $(lon[2])) × ($(lat[1]), $(lat[2]))]")
    end    

    if (:t in keys(x.dims))
        tmin, tmax = extrema(x.dims[:t])
        print(io, "time ∈ ($(time2datetime(tmin)), $(time2datetime(tmax)))")
    end
end