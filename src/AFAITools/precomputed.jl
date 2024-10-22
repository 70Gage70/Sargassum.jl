"""
    const SARGASSUM_DISTRIBUTION_PRECOMPUTED

A dictionary mapping years to \
[`SargassumDistribution`](@ref) precomputed for that year using default [`AFAIParameters`](@ref).

Use [`download_precomputed()`](@ref) to populate this dictionary.

### Examples

Populate the dictionary

```julia-repl
julia> download_precomputed()
```

Access the [`SargassumDistribution`](@ref) from April, 2018.

```julia-repl
julia> SARGASSUM_DISTRIBUTION_PRECOMPUTED[(2018, 4)]
```

See all available `(year, month)` pairs.

```julia-repl
julia> keys(SARGASSUM_DISTRIBUTION_PRECOMPUTED)
```
"""
const SARGASSUM_DISTRIBUTION_PRECOMPUTED = Dict{Tuple{Int64, Int64}, SargassumDistribution}()

"""
    update_sargassum_distribution_precomputed!()

Update [`SARGASSUM_DISTRIBUTION_PRECOMPUTED`](@ref) by reading [`_SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH`](@ref).
"""
function update_sargassum_distribution_precomputed!()
    files = readdir(_SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH.x)

    for f in files
        sd = SargassumDistribution(joinpath(_SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH.x, f))

        for ym in keys(sd)
            SARGASSUM_DISTRIBUTION_PRECOMPUTED[ym] = sd[ym]
        end
    end

    return nothing
end

"""
    const _SARGASSUM_DISTRIBUTION_PRECOMPUTED_LINKS

A dictionary mapping years to the link where the precomputed [`SargassumDistribution`](@ref)s can be downloaded for that year.
"""
const _SARGASSUM_DISTRIBUTION_PRECOMPUTED_LINKS = Dict(
    2017 => "https://www.dropbox.com/scl/fi/yqygl49zd5n2t1a4j0z0b/dist-2017.nc?rlkey=qqcggtzkowktmclrzoakr3b1e&st=dv702rwv&dl=1",
    2018 => "https://www.dropbox.com/scl/fi/vq5kq4u76336acm97h4tg/dist-2018.nc?rlkey=6xlp5q72v457gkqdlvfbl4xlw&st=tsen2xos&dl=1",
    2019 => "https://www.dropbox.com/scl/fi/2sdlolv820riniek8ranu/dist-2019.nc?rlkey=56jtu5ltsvr6pbwjboymduidg&st=apj8ccd2&dl=1",
    2020 => "https://www.dropbox.com/scl/fi/9a147lfz6w3s5ikpwt4nn/dist-2020.nc?rlkey=30jx19xjw1of0gz8i7gm02e87&st=bele3ggi&dl=1",
    2021 => "https://www.dropbox.com/scl/fi/xqmxajf3kth3w8cop1ig5/dist-2021.nc?rlkey=mmi8tyzp678n0dw2peoe2zynb&st=f24jr7re&dl=1",
    2022 => "https://www.dropbox.com/scl/fi/gz7d6swepd2q898q9nvi5/dist-2022.nc?rlkey=b0lqpre6k32toq6mykglxos5k&st=cmorf1g4&dl=1",
    2023 => "https://www.dropbox.com/scl/fi/40hndtk9h2apqyxdfsumu/dist-2023.nc?rlkey=juuc1t7hta6kfmk6r0ms5hdyv&st=m83ft1kt&dl=1",
    2024 => "https://www.dropbox.com/scl/fi/0xoa6f19kammr8wksybp5/dist-2024.nc?rlkey=cpazpxfhf77r3dgzwxyrvb6pf&st=kw0iruzz&dl=1"
)

"""
    download_precomputed()

Download [`SargassumDistribution`](@ref) precomputed using default [`AFAIParameters`](@ref).

This overwrites all precomputed distributions.
"""
function download_precomputed()
    for year in keys(_SARGASSUM_DISTRIBUTION_PRECOMPUTED_LINKS)
        filename = joinpath(_SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH.x, "dist-$(year).nc")
        rm(filename, force = true)
        _download_with_progress(_SARGASSUM_DISTRIBUTION_PRECOMPUTED_LINKS[year], filename)

        sd = SargassumDistribution(filename)
        for ym in keys(sd)
            SARGASSUM_DISTRIBUTION_PRECOMPUTED[ym] = sd[ym]
        end
    end

    return nothing
end

