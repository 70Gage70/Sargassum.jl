include(joinpath(@__DIR__, "raw-data.jl"))
export AFAI_DOWNLOADED_PATHS, update_afai_downloaded_paths!, download_raw_afai, remove_raw_afai

include(joinpath(@__DIR__, "earth-polygons.jl"))
export VERTICES_PACIFIC_PANAMA, VERTICES_NORTH_ATLANTIC

include(joinpath(@__DIR__, "main.jl"))
export AFAIParameters, AFAI, SargassumDistribution
export clean_pacific!, coast_and_clouds!, pixel_classify!, pixel_unmix!
export distribution_to_nc, afai_to_distribution
export sargassum_distribution

include(joinpath(@__DIR__, "precomputed.jl"))
export SARGASSUM_DISTRIBUTION_PRECOMPUTED, update_sargassum_distribution_precomputed!, download_precomputed

include(joinpath(@__DIR__, "show.jl"))
export show # various Base extensions