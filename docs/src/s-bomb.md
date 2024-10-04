# SargassumBOMB.jl

# First Steps

Here we will learn the basic workflow of SargassumBOMB by integrating a small raft. 
You can follow along with this tutorial by executing each code block in the REPL or skip 
ahead to the copy-pastable example to execute everything all at once.

```@contents
Pages = ["first-steps.md"]
```

## Full Tutorial

Before doing anything, we should make sure to use the package:

```julia
using SargassumBOMB
```

The highest level function in the package is [`simulate`](@ref), which takes one mandatory argument, a [`RaftParameters`](@ref) object. The general plan is therefore to build the `RaftParameters` object that defines the problem we want to solve. Then, we will simply invoke `simulate`.

A `RaftParameters` constructor needs the following fields

- The time span of the simulation, of the form `(t_initial, t_final)`, where the times are measured in days since January 1, 2018 by default.
- Initial conditions; the actual coordinates of the clumps initially. Contained in an [`InitialConditions`](@ref) object.
- Physics parameters defining each (identical) clump; buoyancy, windage etc. Contained in a [`ClumpParameters`](@ref) object.
- Spring parameters defining each (identical) spring; length and stiffness function. Contained in a [`SpringParameters`](@ref) object.
- Connections defining how the clumps are connected by the springs. Contained in an [`AbstractConnections`](@ref) object.
- A model controling how clumps grow and die due to biological effects. Contained in an [`AbstractGrowthDeathModel`](@ref) object.
- A land model; how clumps should behave when reaching land. Contained in an [`AbstractLand`](@ref) object.

First, the time of the simulation. By default, all the interpolants (wind, currents, etc.) all start on January 1, 2018 and end on December 31, 2018. Supposing that we want to integrate for the month of January, we should take `tspan = (0, 31)`. 

```julia
t_initial = 0
t_final = 31
tspan = (t_initial, t_final)
```
Next, the clump initial conditions. Important to note is that all calculations are performed on a flat plane, in equirectangular coordinates but it is often more convenient to begin with definitions in spherical coordinates. 
Helper functions [`sph2xy`](@ref) and [`xy2sph`](@ref) are provided with a variety of methods to make conversion between both worlds easy. 
Such conversions require reference longitudes and latitudes contained in an [`EquirectangularReference`](@ref) object. 
The default is [`EQR`](@ref) which has a reference longitude of $75\degree\,\text{W}$  and $10\degree\,\text{N}$. 

We will place the clumps in a rectangular arrangement, with longitudes in $[55\degree\,\text{W}, 50\degree\,\text{W}]$ and latitudes in $[5\degree\,\text{N}, 10\degree\,\text{N}]$. 
Note that we use the convention that the western and southern directions are negative. 
We will place 5 clumps in each direction for a total of 25 clumps in the simulation. The function [`InitialConditions`](@ref) will handle the preprocessing.

```julia
lon_range = range(-55.0, -50.0, length = 5)
lat_range = range(5.0, 10.0, length = 5)
ics = InitialConditions(lon_range, lat_range, ref = EQR)
```

Next, the clump parameters; we'll stick with the defaults.

```julia
clumps = ClumpParameters()
```

Next, the spring parameters; we'll use a constant spring stiffness of 1.0 and a spring length provided automatically by the function [`ΔL`](@ref). 

```julia
spring_k(k) = 1.0 # note that `spring_k` is actually a function even though the stiffness is constant
spring_L = ΔL(lon_range, lat_range, ref = EQR)
springs = SpringParameters(spring_k, spring_L)
```

Next, the connections; we'll connect every clump to every other clump using [`ConnectionsFull`](@ref).

```julia
connections = ConnectionsFull()
```

Next, the growth and death model; we'll use the [`ImmortalModel`](@ref) so no clumps grow or die to keep things simple.

```julia
gd_model = ImmortalModel()
```

Finally, the land model; we'll use the default [`Land`](@ref) object.

```julia
land = Land()
```

We can therefore construct our `RaftParameters`,

```julia
rp = RaftParameters(
    tspan = tspan,
    ics = ics,
    clumps = clumps,
    springs = springs,
    connections = connections,
    gd_model = gd_model,
    land = land
)
```

And run our simulation,

```julia
rtr = simulate(rp)
```

The output of `simulate` is, by default, a [`RaftParameters`](@ref) object, which neatly organizes all of the individual clump trajectories including the possibilities that some clumps grow and die at arbitrary times.

Finally, we can quickly visualize our trajectory using the [`geo_axis!`](@ref), [`trajectory!`](@ref) and [`land!`](@ref) functions. These integrate into the `Makie` ecosystem; we'll use `Makie` and `CairoMakie` to quickly examine the trajectories.
If these packages aren't in your environment, run

```julia
import Pkg
Pkg.add(Makie)
Pkg.add(CairoMakie)
```

We can then make our plots

```julia
using Makie, CairoMakie

fig = default_fig()

limits = (-100, -40, 5, 35)
ax = geo_axis(fig[1, 1], limits = limits, title = L"\mathrm{First Steps}")

trajectory!(ax, rtr)

land!(ax)

fig
```

### TODO: ADD FIGURE

## Copy-pastable Code

```julia
using SargassumBOMB

t_initial = 0
t_final = 31
tspan = (t_initial, t_final)

lon_range = range(-55.0, -50.0, length = 5)
lat_range = range(5.0, 10.0, length = 5)
ics = InitialConditions(lon_range, lat_range, ref = EQR)

clumps = ClumpParameters()

spring_k = k -> 1.0
spring_L = ΔL(lon_range, lat_range, ref = EQR)
springs = SpringParameters(spring_k, spring_L)

connections = ConnectionsFull()

gd_model = ImmortalModel()

land = Land()

rp = RaftParameters(
    tspan = tspan,
    ics = ics,
    clumps = clumps,
    springs = springs,
    connections = connections,
    gd_model = gd_model,
    land = land
)

rtr = simulate(rp)

### plotting

using Makie, CairoMakie

fig = default_fig()

limits = (-100, -40, 5, 35)
ax = geo_axis(fig[1, 1], limits = limits, title = L"\mathrm{First Steps}")

trajectory!(ax, rtr)

land!(ax)

fig
```