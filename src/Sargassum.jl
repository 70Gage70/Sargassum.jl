module Sargassum

using Scratch

"""
    const _AFAI_RAW_SCRATCH

A `Ref` whose field is the path to the location of the raw AFAI data. 
"""
const _AFAI_RAW_SCRATCH = Ref{String}()

"""
    const _SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH

A `Ref` whose field is the path to the location of the precomputed [`SargassumDistribution`(@ref)s. 
"""
const _SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH = Ref{String}()

"""
    const _ITPS_RAW_SCRATCH

A `Ref` whose field is the path to the location of the raw data that generates default interpolants.
"""
const _ITPS_RAW_SCRATCH = Ref{String}()

"""
    const _ITPS_RAW_SCRATCH

A `Ref` whose field is the path to the location of the raw data that generates default interpolants.
"""
const _ITPS_SCRATCH = Ref{String}()

"""
    const _INTERFACE_SCRATCH

A `Ref` whose field is the path to the location of the editable interface notebook.
"""
const _INTERFACE_SCRATCH = Ref{String}()

###############################################################

# general
using ArgCheck, Dates, Statistics, Distributions, Interpolations, Unitful
using LinearAlgebra: norm, ⋅ # dot product
using Random: seed!

# general downloading
using Downloads, HTTP, CodecZlib, BufferedStreams

# general plotting
using CairoMakie

# general io
using NetCDF, MAT, JLD2

# general printing
using Crayons.Box, ProgressBars

# For PlottingCore
using Colors, ColorSchemes
using NaturalEarth
import GeometryBasics, GeoInterface, GeoJSON
using GeoDatasets

# For AFAITools
using ImageFiltering, PolygonInbounds

# For Simulation
using OrdinaryDiffEqTsit5, NearestNeighbors, SparseArrays

# For Interface
using Pluto

############################################################

include(joinpath(@__DIR__, "Utilities", "Utilities.jl"))

include(joinpath(@__DIR__, "PlottingCore", "PlottingCore.jl"))

include(joinpath(@__DIR__, "AFAITools", "AFAITools.jl"))

include(joinpath(@__DIR__, "Interpolants", "Interpolants.jl"))

include(joinpath(@__DIR__, "Simulation", "Simulation.jl"))

include(joinpath(@__DIR__, "Plotting", "Plotting.jl"))

include(joinpath(@__DIR__, "Interface", "Interface.jl"))

function __init__()
    ### AFAITools downloaded data
    _AFAI_RAW_SCRATCH.x = @get_scratch!("_AFAI_RAW_SCRATCH")
    update_afai_downloaded_paths!()

    ### AFAITools precomputed distributions
    _SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH.x = @get_scratch!("_SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH")
    update_sargassum_distribution_precomputed!()

    ### Interpolants raw data
    _ITPS_RAW_SCRATCH.x = @get_scratch!("_ITPS_RAW_SCRATCH")

    ### Interpolants computed (.jld2)
    _ITPS_SCRATCH.x = @get_scratch!("_ITPS_SCRATCH")

    version_minor = VERSION.minor
    if version_minor < 10
        @warn "Sargassum.jl should be used with Julia version 1.10 or higher."
    else 
        try
            itps_load()
        catch
            try 
                itps_default_construct(verbose = false)
            catch
                nothing
            end
        end
    end

    ### Interface
    _INTERFACE_SCRATCH.x = @get_scratch!("_INTERFACE_SCRATCH")

    nb_orig = joinpath(@__DIR__, "Interface", "interface-original.jl")
    nb_edit = joinpath(_INTERFACE_SCRATCH.x, "interface-edit.jl")

    if !isfile(nb_edit)
        Pluto.readwrite(nb_orig, nb_edit)
    end
end

end # module Sargassum