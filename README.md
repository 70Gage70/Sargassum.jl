# Sargassum.jl

Documentation coming soon.

First, install Julia as per the instructions [here](https://github.com/JuliaLang/juliaup).

Execute the following command in the terminal to install. 
```sh
julia -e 'file = download("https://raw.githubusercontent.com/70Gage70/Sargassum.jl/master/src/installer.jl"); include(file)'
```
Sargassum.jl depends on some of the heaviest Julia packages, and may take several minutes to precompile.

The highest level usage is provided by [SargassumInterface.jl](https://github.com/70Gage70/SargassumInterface.jl). This is reexported by Sargassum.jl, in a terminal simply run

```sh
julia -e 'using Sargassum; interface()'
```

Be aware that if this is your first time opening the interface, it will take several minutes to load. In particular, raw data for the default interpolants will be downloaded automatically (roughly 1.2 GB of NetCDF files). These are required to run the interface initially; custom interpolants can be loaded later. 