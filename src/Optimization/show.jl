function Base.show(io::IO, x::TimeSeries)
    print(io, "TimeSeries[")
    print(io, "$(length(x.t)) weeks ∈ ($(x.t[1][1]), $(x.t[end][end])), ")
    lon_min, lon_max = extrema(x.lon) .|> x -> round(x, sigdigits = 4)
    lat_min, lat_max = extrema(x.lat) .|> x -> round(x, sigdigits = 4)
    print(io, "lon/lat ∈ ($lon_min, $lon_max) × ($lat_min, $lat_max), ") 
    if x.exclude_clouded_bins
        print(io, "clouds excluded]")
    else
        print(io, "clouds not excluded]")
    end
end