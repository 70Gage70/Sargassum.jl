"""
    struct AFAIParameters{U, T}

A container for the parameters required to process the AFAI data.

### Fields 

- `window_size_coast_mask`: An `Integer` giving the distance, in gridpoints, such that all \
gridpoints within that distance of the coastline are masked (removed.) Default: `20`.
- `window_size_median_filter`: An `Integer` giving the size, in gridpoints of the median filter applied to the data. Default: `51`.
- `threshold_median`: A `Real` such that all median-filtered `afai` values below it are considered to not contain Sargassum. Default: `1.79e-4`.
- `afai_U0`: A `Real` giving the global upper limit on `afai` values for Sargassum-containing pixels. Default: `4.41e-2`.
- `afai_L0`: A `Real` giving the global lower limit on `afai` values for Sargassum-containing pixels. Default: `-8.77e-4`.
- `lon_lat_bins_coverage`: A `Tuple{Integer, Integer}` of the form `(lon_bins, lat_bins)` where the final coverage distribution is \
binned with `lon_bins` horizontally and `lat_bins` gridpoints vertically. Default `(134, 64)`.
- `distribution_quant`: A `Real` giving the quantile below which bins are discarded in the final coverage distribution calculation. Default: `0.85`.

### Constructors 

    AFAIParameters(; params...)

Each field has a named kwarg.
"""
struct AFAIParameters{U<:Integer, T<:Real}
    window_size_coast_mask::U
    window_size_median_filter::U
    threshold_median::T
    afai_U0::T 
    afai_L0::T
    lon_lat_bins_coverage::Tuple{U, U}
    distribution_quant::T


    function AFAIParameters(;
        window_size_coast_mask = 20,
        window_size_median_filter = 51,
        threshold_median = 1.79e-4,
        afai_U0 = 4.41e-2,
        afai_L0 = -8.77e-4,
        lon_lat_bins_coverage = (134, 64),
        distribution_quant = 0.85)

        return new{eltype(window_size_coast_mask), eltype(threshold_median)}(
            window_size_coast_mask,
            window_size_median_filter,
            threshold_median,
            afai_U0,
            afai_L0,
            lon_lat_bins_coverage,
            distribution_quant)
    end
end

"""
    mutable struct AFAI{U, T, R}

A container for the AFAI data.

### Fields 

- `lon`: A `Vector` of longitudes.
- `lat`: A `Vector` of latitudes.
- `time`: A `Vector` of `DateTime`s.
- `afai`: An `Array` of AFAI/Sargassum values of the form `afai[lon, lat, time]`.
- `coast`: A `BitMatrix` of size `size(afai)[1:2]` such that `coast[i, j] = 1` when the point `(lon[i], lat[j])` is on a coastline.
- `clouds`: A `BitArray` of size `size(afai)` such that `clouds[i, j, t] = 1` when there is a cloud at `(lon[i], lat[j])` and week `t`.
- `classification`: A `BitArray` of size `size(afai)` such that `clouds[i, j, t] = 1` when there Sargassum at `(lon[i], lat[j])` and week `t`.
- `params`: A [`AFAIParameters`](@ref).

### Constructor

    AFAI(filename::String, params::AFAIParameters)
    
`filename` is a NetCDF of the form `name.nc`

It is assumed that the file is obtained from the NOAA database:

https://cwcgom.aoml.noaa.gov/erddap/griddap/noaa_aoml_atlantic_oceanwatch_AFAI_7D.html

The fields `coast`, `clouds` and `classification` are initialized with 0's by default. Use [`coast_and_clouds!`](@ref)
and [`pixel_classify!`](@ref) to construct them fully.

### Plotting 

This object can be `[viz](@ref)`.
"""
mutable struct AFAI{U<:Integer, T<:Real, R<:Real}
    lon::Vector{T}
    lat::Vector{T}
    time::Vector{DateTime}
    afai::Array{R, 3}
    coast::BitMatrix
    clouds::BitArray
    classification::BitArray
    params::AFAIParameters{U, T}

    function AFAI(filename::String, params::AFAIParameters)
        extension = filename[findlast(==('.'), filename)+1:end]
        @argcheck extension == "nc" "Require a NetCDF (.nc) file."

        tref = DateTime(1970, 1, 1, 0, 0, 0)
        time = tref + Second.(ncread(filename, "time"))
    
        lon = ncread(filename, "longitude")
        lat = ncread(filename, "latitude")
        afai = ncread(filename, "AFAI")
        coast = falses(size(afai)[1:2]...)
        clouds = falses(size(afai)...)
        classification = falses(size(afai)...)
    
        return new{eltype(params.window_size_coast_mask), eltype(lon), eltype(afai)}(lon, lat, time, afai, coast, clouds, classification, params)
    end
end

"""
    clean_pacific!(afai; vertices)

Remove any Sargassum pixels that have crossed the Panama canal from `afai.afai`; by default this is done by removing Sargassum from pixels whose centers 
are inside [`VERTICES_PACIFIC_PANAMA`](@ref). 
"""
function clean_pacific!(afai::AFAI; vertices::Matrix{<:Real} = VERTICES_PACIFIC_PANAMA)
    lon = afai.lon
    lat = afai.lat

    raw_points = Iterators.product(lon, lat) |> collect
    inpoly_points = zeros(length(lon)*length(lat), 2)
    for i = 1:size(inpoly_points, 1)
        inpoly_points[i,:] .= raw_points[i]
    end

    inpoly_res = inpoly2(inpoly_points, vertices)
    for i = 1:size(inpoly_res, 1)
        if inpoly_res[i, 1]
            for t = 1:4
                afai.afai[length(raw_points)*(t - 1) + i] = NaN
            end
        end
    end

    return nothing
end

"""
    coast_and_clouds!(afai; apply_coast)

Compute `afai.coast` and `afai.clouds` and update `afai` in place.

### Optional Arguments

- `apply_coast`: A `Bool` such that, if `true`, `afai.afai` is also updated to remove data \
on the coast. Default `true`.
"""
function coast_and_clouds!(afai::AFAI; apply_coast::Bool = true)
    lon = afai.lon
    lat = afai.lat
    afai_data = afai.afai
    window_size = afai.params.window_size_coast_mask

    # determine whether each point on the afai grid is on land or ocean
    lon_lsm, lat_lsm, lsm = GeoDatasets.landseamask(resolution = 'l', grid = 5)
    lsm[lsm .== 2] .= 1 # lake is not ocean, so it's land
    landseamask_itp = Interpolations.scale(Interpolations.interpolate(lsm, BSpline(Constant())), lon_lsm, lat_lsm)
    landseamask_gridded = [landseamask_itp(lon_i, lat_i) for lon_i in lon, lat_i in lat]

    coast = falses(length(lon), length(lat))
    clouds = falses(size(afai_data)...)
    
    for lon_i = 1:size(landseamask_gridded, 1), lat_i = 1:size(landseamask_gridded, 2)
        lons = max(1, lon_i - round(Integer, window_size/2)):min(length(lon), lon_i + round(Integer, window_size/2))
        lats = max(1, lat_i - round(Integer, window_size/2)):min(length(lat), lat_i + round(Integer, window_size/2))

        if landseamask_gridded[lon_i, lat_i] == 0.0 # point itself is on the ocean
            if 1.0 in landseamask_gridded[lons, lats] # point is within `window_size` of land and is therefore coastal
                coast[lon_i, lat_i] = true
            else
                for t = 1:4 # for each week, check if there is a NaN here - if there is, it's a cloud
                    if isnan(afai_data[lon_i, lat_i, t])
                        clouds[lon_i, lat_i, t] = true
                    end
                end
            end
        end            
    end

    afai.coast = coast
    afai.clouds = clouds

    if apply_coast
        afai.afai = afai_data .* [coast[i, j] ? NaN : 1 for i = 1:length(lon), j = 1:length(lat), t = 1:4]
    end

    return nothing
end


"""
    pixel_classify!(afai::AFAI; verbose::Bool = true)

Compute `afai.classification` and update `afai` in place.

This is accomplished in two steps. First, an `Array` of the same size and eltype of `afai.afai` is computed \
such that the value at each gridpoint is the median of all `afai.afai` values in a window of size \
`afai.params.window_size_median_filter` centered on that gridpoint. \
`NaN`s are ignored when calculating the median. If every value in the window \
is `NaN`, the value of `afai_median` is also `NaN`.

Then, the Sargassum-containing pixels are the entries of `afai.afai - afai_median` that are at least as large \
as `afai.params.threshold_median`.

Computing the median filter is parallelized but can take several minutes, \
hence the status is printed for each week. This can be turned off using the optional argument `verbose`.
"""
function pixel_classify!(afai::AFAI; verbose::Bool = true)
    afai_data = afai.afai
    window_size = afai.params.window_size_median_filter
    afai_median_data = zeros(eltype(afai_data), size(afai_data))

    _median(patch) = begin
        filtered = filter(x->!isnan(x), patch)
        if length(filtered) > 0
            median(filtered)
        else
            NaN
        end
    end

    Threads.@threads for week = 1:4
    # for week = 1:4
        if verbose
            @info "Compuing AFAI median, time slice $(week)/4"
        end

        afai_median_data[:, :, week] = mapwindow(_median, afai_data[:, :, week], (window_size, window_size))
    end

    idx = findall(x -> x > afai.params.threshold_median, afai_data - afai_median_data)
    afai.classification[idx] .= true

    return nothing
end


"""
    pixel_unmix!(afai)

Update `afai.afai` in place such that the value at each gridpoint \
is the percentage coverage of Sargassum in that pixel. The coverage is only computed at the pixels \
given by `afai.classification`, and set to `0.0` elsewhere. 

The coverage is computed as a linear interpolation between global maximum and minimum `afai` values \
provided by `afai.params.afai_U0` and `afai.params.afai_L0`.
"""
function pixel_unmix!(afai::AFAI)
    afai_U0 = afai.params.afai_U0
    afai_L0 = afai.params.afai_L0

    for pixel_index = 1:length(afai.classification)
        if afai.classification[pixel_index]
            alpha = (afai.afai[pixel_index] - afai_L0)/(afai_U0 - afai_L0)
            if alpha > 1
                alpha = 1.0f0
            elseif alpha < 0
                alpha = 0.0f0
            end
        else
            alpha = 0.0f0
        end

        afai.afai[pixel_index] = alpha
    end

    return nothing
end


"""
    struct SargassumDistribution{T, R}

A container for a gridded distribution of Sargassum.

### Fields

- `lon`: A vector of longitudes.
- `lat`: A vector of latitudes.
- `time`: A `DateTime` giving the month and year when the distribution was computed.
- `coast`: A `BitMatrix` of size `size(sargassum)[1:2]` such that `coast[i, j] = 1` when the point `(lon[i], lat[j])` is on a coastline.
- `clouds`: A `BitArray` of size `size(sargassum)` such that `clouds[i, j, t] = 1` when there is a cloud at `(lon[i], lat[j])` and week `t`.
- `sargassum`: An `Array` with dimensions `(lon x lat x 4)` whose entries give the fractional coverage of Sargassum at each gridpoint and \
week of the month. Each value is expressed as a percentage of the total coverage in the entire grid in that month, that is, `sargassum` is \
a probability distribution on the grid of longitudes, latitudes and weeks. Or, more simply put, we have `sum(sargassum) == 1`.

### Constructing from AFAI

    SargassumDistribution(afai::AFAI)

In general, `afai` should be processed with [`clean_pacific!`](@ref), [`coast_and_clouds!`](@ref), [`pixel_classify!`](@ref) and [`pixel_unmix!`](@ref).

The data in `afai` are binned according to the bin size defined by `afai.params.lon_lat_bins_coverage`. For the clouds
and coast, a bin is `true` if its mean over all pixels is greater than 0.5.

### Constructing from a NetCDF file

    SargassumDistribution(infile::String)

A dictionary with entries of the form `(year, month) => distribution` is returned.

### Constructing manually

    SargassumDistribution(; kwargs...)
    
Each field has a named kwarg. If `coast` and `clouds` are not provided, they are initialized using `falses`.

### Plotting

This object can be [`viz`](@ref) and [`viz!`](@ref).
"""
struct SargassumDistribution{T<:Real, R<:Real}
    lon::Vector{T}
    lat::Vector{T}
    time::DateTime
    coast::BitMatrix
    clouds::BitArray
    sargassum::Array{R, 3}

    function SargassumDistribution(;
        lon::Vector{T}, 
        lat::Vector{T}, 
        time::DateTime, 
        sargassum::Array{R, 3},
        coast::Union{BitMatrix, Nothing} = nothing,
        clouds::Union{BitArray, Nothing} = nothing) where {T<:Real, R<:Real}

        coast = isnothing(coast) ? falses(size(sargassum)[1:2]...) : coast
        clouds = isnothing(clouds) ? falses(size(sargassum)...) : clouds

        @argcheck size(coast) == size(sargassum)[1:2] "`coast` must have the same lon-lat shape as `sargassum"
        @argcheck size(clouds) == size(sargassum) "`clouds` must have the same shape as `sargassum"

        return new{eltype(lon), eltype(sargassum)}(lon, lat, time, coast, clouds, sargassum)
    end

    function SargassumDistribution(afai::AFAI)
        # uniformlize gridpoints
        lon = range(afai.lon[1], afai.lon[end], length = length(afai.lon))
        lat = range(afai.lat[1], afai.lat[end], length = length(afai.lat))

        # constructing bins
        n_bins_lon = afai.params.lon_lat_bins_coverage[1]
        n_bins_lat = afai.params.lon_lat_bins_coverage[2]
        lons_fixed = range(lon[1] - step(lon)/2, lon[end] + step(lon)/2, length  = n_bins_lon + 1)
        lon_bins = [ceil(Int64, (lon[i] - lons_fixed[1])/step(lons_fixed)) for i = 1:length(lon)]
        lon_bins = [findall(x -> x == i, lon_bins) for i = 1:maximum(lon_bins)]
        lats_fixed = range(lat[1] - step(lat)/2, lat[end] + step(lat)/2, length  = n_bins_lat + 1)
        lat_bins = [ceil(Int64, (lat[i] - lats_fixed[1])/step(lats_fixed)) for i = 1:length(lat)]
        lat_bins = [findall(x -> x == i, lat_bins) for i = 1:maximum(lat_bins)]      
        
        coast_binned = falses(length(lon_bins), length(lat_bins))
        clouds_binned = falses(length(lon_bins), length(lat_bins), 4)
        sargassum = zeros(eltype(afai.afai), length(lon_bins), length(lat_bins), 4)

        # binning data
        for i = 1:length(lon_bins), j = 1:length(lat_bins)
            coast_binned[i, j] = any(afai.coast[lon_bins[i], lat_bins[j]]) ? true : false

            for week = 1:4
                clouds_mean = mean(afai.clouds[lon_bins[i], lat_bins[j], week])
                clouds_binned[i, j, week] = clouds_mean > 0.1 ? true : false

                sargassum[i, j, week] = mean(afai.afai[lon_bins[i], lat_bins[j], week])
            end
        end
    
        lon_bins = [(lons_fixed[i] + lons_fixed[i + 1])/2 for i = 1:length(lons_fixed)-1]
        lat_bins = [(lats_fixed[i] + lats_fixed[i + 1])/2 for i = 1:length(lats_fixed)-1]
    
        # find afai.params.distribution_quant quantile among bins with positive sargassum
        pos_coverage = filter(x -> x > 0.0, sargassum)
        thresh = length(pos_coverage) > 0 ? quantile(pos_coverage, afai.params.distribution_quant) : 0.0
    
        # get bins with sargassum at least as much as the threshold and apply the root transformation
        thresh_coverage = findall(x -> x < thresh, sargassum)
        sargassum[thresh_coverage] .= 0
    
        # normalize
        sargassum = sargassum / sum(sargassum)

        # the year and month of the distribution (technically gives the first day of the month)
        # assumes that each of `afai.time` is the same year and month, which should be true if calculations based on standard data
        time = DateTime(yearmonth(afai.time[1])...)
    
        return new{eltype(lon), eltype(sargassum)}(lon_bins, lat_bins, time, coast_binned, clouds_binned, sargassum)
    end

    function SargassumDistribution(infile::String)
        extension = infile[findlast(==('.'), infile)+1:end]
        @argcheck extension == "nc" "Require a NetCDF (.nc) file."

        lon = ncread(infile, "lon")
        lat = ncread(infile, "lat")
        time = ncread(infile, "time")
        coast = ncread(infile, "coast")
        clouds = ncread(infile, "clouds")
        sarg = ncread(infile, "sargassum")

        return_dict = Dict{Tuple{Int64, Int64}, SargassumDistribution}()

        for i = 1:length(time)
            date = months2time(time[i])
            return_dict[date] = new{eltype(lon), eltype(sarg)}(
                lon, 
                lat, 
                DateTime(date...), 
                BitMatrix(coast[:,:,i]), 
                BitArray(clouds[:,:,:,i]), 
                sarg[:,:,:,i])
        end

        return return_dict
    end
end

"""
    distribution_to_nc(distributions::Vector{<:SargassumDistribution}, outfile::String)

Write the vector of `SargassumDistribution`s in `distributions` to the NetCDF file named in `outfile`. That is, \
`outfile` should be of the form `name.nc`.

    distribution_to_nc(distribution::SargassumDistribution, outfile::String)

Write a single distribution as above.
"""
function distribution_to_nc(distributions::Vector{<:SargassumDistribution}, outfile::String)
    extension = outfile[findlast(==('.'), outfile)+1:end]
    @argcheck extension == "nc" "Output should be a NetCDF (.nc) file."
    @argcheck length(distributions) > 0 "Need at least one distribution."

    times = [time2months(distribution.time) for distribution in distributions]

    @argcheck allunique(times) "All times must be different."

    # ensure distributions are sorted by increasing time
    sp = sortperm(times)
    sort!(times)
    permute!(distributions, sp)

    # assumes that all distributions are on the same grid
    lon = distributions[1].lon
    lat = distributions[1].lat
    week = [1, 2, 3, 4]

    coast = zeros(Int8, size(distributions[1].coast)..., length(times))
    clouds = zeros(Int8, size(distributions[1].clouds)..., length(times))
    sarg = zeros(eltype(distributions[1].sargassum), size(distributions[1].sargassum)..., length(times))

    for i = 1:length(distributions)
        coast[:,:,i] .= distributions[i].coast
        clouds[:,:,:,i] .= distributions[i].clouds
        sarg[:,:,:,i] .= distributions[i].sargassum
    end

    # attributes
    lonatts = Dict(
        "longname" => "Longitude",
        "units"    => "degrees east",
        "min"      => minimum(lon),
        "max"      => maximum(lon))
    latatts = Dict(
        "longname" => "Latitude",
        "units"    => "degrees north",
        "min"      => minimum(lat),
        "max"      => maximum(lat))
    weekatts = Dict(
        "longname" => "Week",
        "units"    => "number",
        "min"      => minimum(week),
        "max"      => maximum(week))
    timeatts = Dict(
        "longname" => "Time",
        "units"    => "months since $(monthname(T_REF.x)), $(year(T_REF.x))",
        "example"  => "time = 219 is $(monthname(months2time(219)[2])), $(months2time(219)[1])",
        "min"      => minimum(times),
        "max"      => maximum(times))

    coast_atts = Dict(
        "longname" => "coast mask",
        "units"    => "1 or 0")

    clouds_atts = Dict(
        "longname" => "clouds mask",
        "units"    => "1 or 0")

    sarg_atts = Dict(
        "longname" => "Sargassum density",
        "units"    => "monthly fraction")
    
    # writing to file
    isfile(outfile) && rm(outfile)

    nccreate(outfile, 
        "sargassum",
        "lon", lon, lonatts,
        "lat", lat, latatts, 
        "week", week, weekatts,
        "time", times, timeatts, 
        atts = sarg_atts,
        gatts = Dict(
            "info" =>       "The data depend on and are generated by the 
                            dataset with ID `noaa_aoml_atlantic_oceanwatch_AFAI_7D` 
                            and can be obtained here: 
                            https://cwcgom.aoml.noaa.gov/erddap/griddap/noaa_aoml_atlantic_oceanwatch_AFAI_7D.html",
            "github" =>     "https://github.com/70Gage70/SargassumFromAFAI.jl"))

    ncwrite(sarg, outfile, "sargassum")

    nccreate(outfile, 
        "coast",
        "lon", lon, lonatts,
        "lat", lat, latatts, 
        "time", times, timeatts, 
        atts = coast_atts)

    ncwrite(coast, outfile, "coast")

    nccreate(outfile, 
        "clouds",
        "lon", lon, lonatts,
        "lat", lat, latatts, 
        "week", week, weekatts,
        "time", times, timeatts, 
        atts = clouds_atts)

    ncwrite(clouds, outfile, "clouds")

    @info "Sargassum distribution written to $(outfile)."

    return outfile
end

function distribution_to_nc(distribution::SargassumDistribution, outfile::String)
    return distribution_to_nc([distribution], outfile)
end

"""
    afai_to_distribution(file::String, params::AFAIParameters)

Compute a [`SargassumDistribution`](@ref) using the parameters `params` from the raw data file `file`. 
"""
function afai_to_distribution(file::String, params::AFAIParameters)
    afai = AFAI(file, params)
    
    clean_pacific!(afai)
    coast_and_clouds!(afai)
    pixel_classify!(afai)
    pixel_unmix!(afai)
    
    return SargassumDistribution(afai)
end

"""
    sargassum_distribution(year, month_spec, outfile; params)

Write the [`SargassumDistribution`](@ref) at year `year` to the NetCDF file `outfile`.

- `month_spec` can be one of the following 
  - an integer between `1` and `12`: download the data from the corresponding month
  - a vector of integers each between `1` and `12`: download the data from all of the corresponding months
  - omitted: download the data for every month in the given year

This is the highest level function available and attempts to download the data automatically if it hasn't already been \
downloaded and run the full calculation. 

### Optional Arguments

- `params`: The [`AFAIParameters`](@ref) to use for each calculation.
"""
function sargassum_distribution(
    year::Integer, 
    months::Vector{<:Integer}, 
    outfile::String; 
    params = AFAIParameters())

    extension = outfile[findlast(==('.'), outfile)+1:end]
    @argcheck extension == "nc" "Output should be a NetCDF (.nc) file."
    @argcheck !isfile(outfile) "The output file already exists."

    dists = SargassumDistribution[]
    
    for month in months
        try
            download_raw_afai(year, month)
            path = AFAI_DOWNLOADED_PATHS[(year, month)]
            push!(dists, afai_to_distribution(path, params))
        catch
            @warn "Problem with month $(month). This probably means that the raw dataset is incomplete or not available at this time."
        end
    end
    
    return distribution_to_nc(dists, outfile)
end

function sargassum_distribution(
    year::Integer, 
    months::Integer, 
    outfile::String; 
    params = AFAIParameters())

    return sargassum_distribution(year, [months], outfile, params = params)
end

function sargassum_distribution(
    year::Integer, 
    outfile::String; 
    params = AFAIParameters())

    return sargassum_distribution(year, collect(1:12), outfile, params = params)
end