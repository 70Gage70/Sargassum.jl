# Getting Started with Sargassum.jl

## Introduction

`Sargassum.jl` is a meta package for the [Julia](https://julialang.org/) programming language that bundles the following component 
packages all in one location.

- [`SargassumInterface.jl`](https://github.com/70Gage70/SargassumInterface.jl): High level, zero-code interface.
- [`SargassumBOMB.jl`](https://github.com/70Gage70/SargassumBOMB.jl): Main modelling and simulation tools.
- [`SargassumFromAFAI.jl`](https://github.com/70Gage70/SargassumFromAFAI.jl): Downloading raw AFAI data and generating Sargassum distribution maps.
- [`SargassumColors.jl`](https://github.com/70Gage70/SargassumColors.jl): Color maps and general plot styling.

Each of these packages can be used individually, but most end-users will want to simply using `Sargassum.jl`
to have all functionality in one location. Together, this represents a fully featured Sargassum analysis toolkit.

Sargassum.jl was developed by the [Nonlinear Dynamics Group](https://nonlinear.earth.miami.edu/index.html) at the University of Miami. Refer [here](cite.md) for citation information.

## Installation

### Step 1: Installing Julia

Julia 1.10 or later is required to use this package.  For most users, it is enough to run the following command in a terminal. See [here](https://github.com/JuliaLang/juliaup) for installation instructions if this is not sufficient.

!!! details "Windows"
    ```sh
    winget install julia -s msstore
    ```

!!! details "Mac/Linux"
    ```sh
    curl -fsSL https://install.julialang.org | sh
    ```

### Step 2: Installing Sargassum.jl

!!! warning
    Sargassum.jl can be installed by running the following command in a terminal. Sargassum.jl is distributed without any raw data to keep the initial download size small. To run simulations, interpolants for ocean velocity, wind etc. are required. Default interpolants are provided for the year 2018 in the north Atlantic, but the raw data need to be downloaded (roughly 1.2 GB). The first command does this automatically and only needs to be run once. If you don't want to do this, e.g. because you have your own raw data or you don't need the simulation capabilities of the package, then run the second command.

!!! details "Install with default interpolants (recommended)"
    Run in the terminal, not in Julia!
    ```sh
    julia -e 'import Pkg; Pkg.add(url = "https://github.com/70Gage70/Sargassum.jl"); using Sargassum; itps_default_construct(download = true);'
    ```

!!! details "Install without default interpolants"
    Run in the terminal, not in Julia!
    ```sh
    julia -e 'import Pkg; Pkg.add(url = "https://github.com/70Gage70/Sargassum.jl"); using Sargassum;'
    ```

Advanced Julia users can [add the package](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-unregistered-packages) to their preferred environment.

## Next Steps

In general, this documentation can be read in order, but refer to the following for further direction.

!!! tip "I want to get started as quickly as possible and/or do as little coding as possible."
    See [SargassumInterface](s-interface.md).

!!! tip "I want to learn the core simulation tools of the package or create custom biology/physics functionality."
    See [SargassumBOMB](s-bomb.md).

!!! tip "I want analyze satellite data or create Sargassum distribution maps."
    See [SargassumFromAFAI](s-afai.md).       

