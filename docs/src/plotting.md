# Plotting

Sargassum.jl has built-in plotting via the [`viz`](@ref) function. In general, all of the key objects across the ecosystem such as [`InterpolatedField`](@ref), [`RaftTrajectory`](@ref) and [`SargassumDistribution`](@ref) can all be visualized quickly with `viz(object)`. Sargassum.jl further interfaces easily with Julia's [Makie](https://docs.makie.org/stable/) plotting system via the [`viz!`](@ref) function. This allows Sargassum.jl objects to be plotted on a preexisting axis for greater control over the style of the plot. Refer to the full documentation of `viz` and `viz!` for further details. 

## Index
```@index
Pages = ["plotting.md"]
```

## Core Functions

```@autodocs
Modules = [Sargassum]
Pages = "PlottingCore/" .* [
    "eureka.jl", 
    "shadden.jl", 
    "geo_theme.jl", 
    "land.jl"]
``` 

## AFAI-specific

```@autodocs
Modules = [Sargassum]
Pages = "Plotting/" .* [
    "afai.jl"]
``` 

## General objects

```@autodocs
Modules = [Sargassum]
Pages = "Plotting/" .* [
    "viz.jl"]
``` 
