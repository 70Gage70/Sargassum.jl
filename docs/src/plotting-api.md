# Plotting API

These are the full docstrings for the Plotting subsection of Sargassum.jl.

## Index
```@index
Pages = ["plotting-api.md"]
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
