function Base.show(io::IO, x::EquirectangularReference)
    print(io, "EquirectangularReference[lon0 = $(x.lon0), lat0 = $(x.lat0), R = $(x.R)]")
end