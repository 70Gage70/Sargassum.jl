# AFAI API

These are the full docstrings for the AFAI subsection of Sargassum.jl.

## Index
```@index
Pages = ["afai-api.md"]
```

## Downloading AFAI Data

```@autodocs
Modules = [Sargassum]
Pages = "AFAITools/" .* [
    "raw-data.jl"]
``` 

## AFAI

```@docs
AFAI
AFAIParameters
```

## SargassumDistribution

```@docs
SargassumDistribution
sargassum_distribution
distribution_to_nc
```

## Precomputed Sargassum distributions

```@autodocs
Modules = [Sargassum]
Pages = "AFAITools/" .* [
    "precomputed.jl"]
``` 

## Earth Polygons

```@autodocs
Modules = [Sargassum]
Pages = "AFAITools/" .* [
    "earth-polygons.jl"]
``` 

## Internal SargassumDistribution Calculations

```@docs
clean_pacific!
coast_and_clouds!
pixel_classify!
pixel_unmix!
afai_to_distribution
```
