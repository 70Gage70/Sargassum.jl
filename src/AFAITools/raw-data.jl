"""
    const AFAI_DOWNLOADED_PATHS

A `Dict` mapping `(year, month)` pairs to the path of the downloaded data.

### Examples

Obtain a list of all AFAI data that has ever been downloaded.

```julia-repl
julia> keys(AFAI_DOWNLOADED_PATHS)
```

Read the metadata of the .nc file.

```julia-repl
julia> using NetCDF # install this if you haven't already
julia> ncinfo(AFAI_DOWNLOADED_PATHS[(2018, 4)])
```
"""
const AFAI_DOWNLOADED_PATHS = Dict{Tuple{Int64, Int64}, String}()

"""
    update_afai_downloaded_paths!()

Update [`AFAI_DOWNLOADED_PATHS`](@ref) by reading [`_AFAI_RAW_SCRATCH`](@ref).
"""
function update_afai_downloaded_paths!()
    files = readdir(_AFAI_RAW_SCRATCH.x)

    for f in files
        year = parse(Int64, f[6:9])
        month = parse(Int64, f[11:12])
        AFAI_DOWNLOADED_PATHS[(year, month)] = joinpath(_AFAI_RAW_SCRATCH.x, f)
    end

    return nothing
end

"""
    download_raw_afai(year::Integer, month_spec; force = false)

Download raw AFAI data from

`https://cwcgom.aoml.noaa.gov/erddap/griddap/noaa_aoml_atlantic_oceanwatch_AFAI_7D.html`

Four files are downloaded, one on the 7th, 14th, 21nd and 28th of each month, each of which are 7-day aggregates. 

Refer to [`AFAI_DOWNLOADED_PATHS`] for the current status of downloaded data.

### Arguments

- `year` should be an integer equal to at least `2017` (the first full year available).
- `month_spec` can be one of the following 
  - an integer between `1` and `12`: download the data from the corresponding month
  - a vector of integers each between `1` and `12`: download the data from all of the corresponding months
  - omitted: download the data for every month in the given year

### Optional Arguments

- `force`: If `true`, download the data even if it has already been downloaded. Default `false`.
"""
function download_raw_afai(year::Integer, month::Integer; force::Bool = false)
    @argcheck year >= 2017 "Full datasets are only available starting in 2017."
    @argcheck 1 <= month <= 12 "Must be a valid month."

    if (year, month) in keys(AFAI_DOWNLOADED_PATHS) && !force
        @info "AFAI data $((year, month)) has already been downloaded. Pass `force = true` to force download anyway."
        return nothing
    end 

    # construct URL and download file
    month_string = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"][month]

    url_start = "https://cwcgom.aoml.noaa.gov/erddap/griddap/noaa_aoml_atlantic_oceanwatch_AFAI_7D.nc?AFAI"
    url = url_start * "[($(year)-$(month_string)-07T00:00:00Z):7:($(year)-$(month_string)-28T00:00:00Z)][(0.0):1:(38.0)][(-98.0):1:(-38.0)]"

    filename = joinpath(_AFAI_RAW_SCRATCH.x, "afai-$(year)-$(month_string).nc")
    _download_with_progress_http(url, filename)
    AFAI_DOWNLOADED_PATHS[(year, month)] = filename

    time_slices = length(ncread(filename, "time"))
    if time_slices < 4
        @warn "
            Dataset with year $(year), month $(month) is not complete. 
            Expected 4 time slices but got $(time_slices) time slices.
            The dataset was downloaded, but it won't work as expected without further processing. 
            "
    end

    return nothing
end

function download_raw_afai(year::Integer, months::Union{Vector{<:Integer}, AbstractRange}; force::Bool = false)
    for month in months
        download_raw_afai(year, month, force = force)
    end

    return nothing
end

function download_raw_afai(year::Integer; force::Bool = false)
    for month in 1:12
        download_raw_afai(year, month, force = force)
    end

    return nothing
end

"""
    remove_raw_afai(year, month)

Remove the raw data file corresponding to `(year, month)` and update [`AFAI_DOWNLOADED_PATHS`](@ref).

Does not throw an error if the data has not been downloaded.
"""
function remove_raw_afai(year::Integer, month::Integer)
    ym = (year, month)
    rm(AFAI_DOWNLOADED_PATHS[ym], force = true)
    delete!(AFAI_DOWNLOADED_PATHS, ym)
    
    return nothing
end

"""
    remove_raw_afai(; force = false)

Remove all raw data file corresponding to `(year, month)` and update [`AFAI_DOWNLOADED_PATHS`](@ref).

Requires passing `force = true` to work.
"""
function remove_raw_afai(; force::Bool = false)
    if !force
        @warn "NOTHING HAS BEEN DELETED YET. Run `remove_raw_afai(force = true)` to delete ALL of your downloaded data."
    else
        for ym in keys(AFAI_DOWNLOADED_PATHS)
            rm(AFAI_DOWNLOADED_PATHS[ym], force = true)
            delete!(AFAI_DOWNLOADED_PATHS, ym)
        end
    end

    return nothing
end