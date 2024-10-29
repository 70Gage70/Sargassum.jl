# Simulation API

These are the full docstrings for the Simulation subsection of Sargassum.jl.

## Index
```@index
Pages = ["simulation-api.md"]
```

## Interpolants 
```@autodocs
Modules = [Sargassum]
Pages = "Interpolants/" .* [
    "main.jl", 
    "definitions.jl", 
    "default.jl", 
    "interface.jl"]
``` 

## RaftParameters

### Rafts and Clumps

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "rafts-clumps.jl"]
``` 

### Initial Conditions

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "ics.jl"]
``` 

### Springs

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "springs.jl"]
``` 

### Land

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "land.jl"]
``` 

### Biology

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "growth-death.jl",
    "control.jl"]
``` 

## Simulation

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "physics.jl",
    "main.jl",
    "trajectories.jl"]
``` 

## I/O

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "io.jl"]
``` 

## Examples

```@autodocs
Modules = [Sargassum]
Pages = "Simulation/" .* [
    "examples.jl"]
``` 