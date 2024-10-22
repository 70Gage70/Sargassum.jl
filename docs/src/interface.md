# Interface

Sargassum.jl comes with a zero-code interface to all of the core functionality. The interface is a reactive notebook powered by [Pluto.jl](https://plutojl.org/).

All of the documentation required to use the interface is built in directly. Ensure that Sargassum.jl has been installed with the default interpolants as described in [Getting Started](getting-started.md).

!!! tip
    The interface runs directly in your default browser, check there if it doesn't open automatically.

## Running the interface from the terminal

```sh
julia -e 'using Sargassum; interface()'
```

## Running the interface from Julia

```julia
using Sargassum; interface()
```