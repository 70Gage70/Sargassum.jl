# Simulation

Sargassum.jl contains full physics and biology simulation for Sargassum clumps. To follow along with this tutorial, ensure that Sargassum.jl has been installed with the default interpolants as described in [Getting Started](getting-started.md). 

## First Steps

Before doing anything else, ensure that the package is loaded into your Julia session,

```julia
using Sargassum
```

The highest level function in the package is [`simulate`](@ref), which takes one mandatory argument, a [`RaftParameters`](@ref) object. The general plan is therefore to build the `RaftParameters` object that defines the problem we want to solve. Then, we will simply invoke `simulate`.

To get up and running as fast as possible, we can use [`QuickRaftParameters`](@ref) to generate our `RaftParameters`.

```@example s-bomb-1
using Sargassum # hide
rp = QuickRaftParameters()
```

Observe that `RaftParameters` prints out information about its contents, which we will discuss further later. For now, note that the initial conditions inform us that we are simulating from April 13, 2018 to April 15, 2018 with 25 clumps. A "clump" is a discrete chunk of Sargassum. In the language of Sargassum.jl, a "Raft" is a collection of any number of clumps (including a single clump). Each clump in a raft shares a number of physics parameters via [`ClumpParameters`](@ref). For now, we will proceed with the simulation.

```@example s-bomb-1
rtr = simulate(rp)
```

The output of `simulate` is a [`RaftTrajectory`](@ref) object. This holds all of the information about each clump's trajectory during the simulation. The easiest way to interpret the results of the simulation is to create a plot. We can use the [`viz`](@ref) function to get a plot with some default arguments already chosen for us.

```@example s-bomb-1
viz(rtr, limits = (-60, -45, 0, 15)) # limits = (lon_min, lon_max, lat_min, lat_max)
```

We see a small amount of movement off the coast of Brazil. Suppose we want to save this data for future analysis; for this we can use the [`rtr2mat`](@ref) function to generate a `.mat` file which can be read in [MATLAB](https://www.mathworks.com/help/matlab/ref/load.html), [Python](https://github.com/skjerns/mat7.3), [Julia](https://github.com/JuliaIO/MAT.jl) and other languages with the appropriate package.

```julia
rtr2mat(rtr, "first_steps.mat")
```

Run `pwd()` to see your current working directory, and find the file `first_steps.mat`.


## Building your own RaftParameters

### Introduction to RaftParameters

The "atom" of a Sargassum simulation is called a *clump* such that a clump is qualitatively a handful of Sargassum. Each clump has identical physics parameters and is modeled as a hard sphere via the [Maxey-Riley equations](https://www.cambridge.org/core/journals/journal-of-fluid-mechanics/article/abs/minimal-maxeyriley-model-for-the-drift-of-sargassum-rafts/5236FED7891D4309789EF0696907655F). Sets of clumps are referred to as *rafts* and are joined together by springs that model interaction forces. Clumps grow and die by biological effects and may die when reaching land. The [`RaftParameters`](@ref) collects all of this information. 

We now provide a walkthrough of the construction of a [`RaftParameters`](@ref) object. We will essentially recreate `Examples.QuickRaftParameters()` to show how this is done. The signature of the basic [`RaftParameters`](@ref) constructor is

```julia
RaftParameters(; ics, clumps, springs, connections, gd_model, land, n_clumps_max, geometry = true, fast_raft = false)
```

Each of these kwargs are defined as follows. We describe the fields with minimal jargon here, see [`RaftParameters`](@ref) and the references therein for the full documentation.

- `ics`: The initial conditions of the simulation, including coordinates and simulation time span. Contained in an [`InitialConditions`](@ref).
- `clumps`: Physics parameters defining each (identical) clump; buoyancy, windage etc. Contained in a [`ClumpParameters`](@ref) object.
- `springs`: Spring parameters defining each (identical) spring. Contained in a [`AbstractSpring`](@ref) object.
- `connections`: Connections defining how the clumps are connected by the springs. Contained in an [`AbstractConnections`](@ref) object.
- `gd_model`: A model controling how clumps grow and die due to biological effects. Contained in an [`AbstractGrowthDeathModel`](@ref) object.
- `land`: A land model; how clumps should behave when reaching land. Contained in an [`AbstractLand`](@ref) object.
- `n_clumps_max`: The maximum number of clumps allowed to exist across the entire simulation. Should be a positive integer.
- `geometry`: A Boolean flag. If `true`, corrections are applied to account for the spherical geometry of the Earth. The default value of this is `true` and we will leave it alone for now.
- `fast_raft`: A Boolean flag that controls whether a "total" interpolant is created before the integration to save time on multiple evaluations. This is technical, and we omit the discussion for now. The default value of this flag is `false` and we leave this set as is.

### Defining each argument

Click the relevant tab to see how each argument is constructed.

::: tabs

== ics and n\_clumps\_max

We construct `ics`, an [`InitialConditions`](@ref) object. There are several constructors for different situations, but to create a rectangular arrangement, the appropriate constructor is 

```julia
InitialConditions(t_span, x_range, y_range; to_xy)
```

The integration time span is controlled by `t_span`, of the form `(t_initial, t_final)` and we want to integrate from April 13, 2018 to April 15, 2018. We can use Julia's built-in [`Dates`](https://docs.julialang.org/en/v1/stdlib/Dates/) module to easily define times as `DateTime(year, month, day)`:

```@example s-bomb-2
using Sargassum # hide
using Dates
t_initial = DateTime(2018, 4, 13)
t_final = DateTime(2018, 4, 15)
t_span = (t_initial, t_final)
nothing # hide
```

Next, we need `x_range` and `y_range` which can be created quickly using `range(start, stop; length)`. Our example consisted of a 5 x 5 grid of clumps off the coast of Brazil. We can recreate this via

```@example s-bomb-2
x_range = range(-55.0, -50.0, length = 5)
y_range = range(5.0, 10.0, length = 5)
nothing # hide
```

Note that we have defined our ranges in terms of longitude/latitude. The optional argument `to_xy` of `InitialConditions` should therefore be set to `true` to automatically convert these spherical coordinates to equirectangular coordinates.

```@example s-bomb-2
ics = InitialConditions(t_span, x_range, y_range, to_xy = true)
```

While we're here, we can define the maximum number of clumps we want to allow. This example contains no biological effects, so the maximum number of clumps will simply be equal to the initial number of clumps, 25.

```@example s-bomb-2
n_clumps_max = 25
nothing # hide
```

== clumps

We construct `clumps`, a [`ClumpParameters`](@ref) object. Various physics constants can be set as desired e.g. the buoyancy of the clumps. For now, we will use the defaults and therefore simply have

```@example s-bomb-2
clumps = ClumpParameters()
```

== springs

We construct `springs`, a [`AbstractSpring`](@ref) object. Built in to Sargassum.jl are two basic spring types, [`HookeSpring`](@ref) with a traditional Hookian stiffness and [`BOMBSpring`](@ref) with an adaptive stiffness. We will use the `BOMBSpring` here. Its constructor is 

```julia
BOMBSpring(A, L)
```

Here, `A` represents the amplitude of the stiffness, and `L` represents the natural length of the spring. We will take the amplitude to be `A = 1`. A convenient way to obtain `L` is using the function [`ΔL`](@ref), which takes an `InitialConditions` as its only argument and computes an appropriate natural spring length based on the average separation of clumps in their initial state. Recall that `Δ` can be entered by typing `\Delta` and then pressing `TAB` on your keyboard. We therefore have

```@example s-bomb-2
springs = BOMBSpring(1.0, ΔL(ics))
```

== connections

We construct `connections`, a [`AbstractConnections`](@ref) object. Several connections types are available, here will will use [`ConnectionsNearest`](@ref) to connect each clump to its 2 nearest neighbors. The signature of `ConnectionsNearest` is

```julia
ConnectionsNearest(n_clumps_max, neighbors)
```

Hence, we have

```@example s-bomb-2
connections = ConnectionsNearest(n_clumps_max, 2)
```

== gd_model

We construct `gd_model`, an [`AbstractGrowthDeathModel`](@ref) object. Built in to Sargassum.jl are two basic biological model types, [`ImmortalModel`](@ref) where clumps do not grow or die by biological effects and [`BrooksModel`](@ref) with a full model based on [Brooks et. al. (2018)](https://www.int-res.com/abstracts/meps/v599/p1-18/). We will use the `ImmortalModel` here, which has a constructor with `n_clumps_max` as its only argument. Hence, we have

```@example s-bomb-2
gd_model = ImmortalModel(n_clumps_max)
```

== land

We construct `land`, an [`AbstractLand`](@ref) object. Built in to Sargassum.jl are two basic land model types, [`NoLand`](@ref) where clumps do not interact with land and [`Land`](@ref) where clumps die when their position is within a polygon that defines land locations. We will use the `Land` here, which has a constructor with no arguments. Hence, we have

```@example s-bomb-2
land = Land()
```

:::

### Application

Now that all the appropriate arguments are defined, we simply use the `RaftParameters` constructor.

```@example s-bomb-2
rp = RaftParameters(
    ics = ics,
    clumps = clumps,
    springs = springs,
    connections = connections,
    gd_model = gd_model,
    land = land,
    n_clumps_max = n_clumps_max
)
```

And now we can simulate and plot as earlier:

```@example s-bomb-2
rtr = simulate(rp)
viz(rtr, limits = (-60, -45, 0, 15))
```

Comparing this to our [earlier example](#First-Steps), we see that they are indeed identical.

## Advanced RaftParameters Construction

An easy way to see the available options for a certain [`RaftParameters`](@ref) object is to use the `subtypes` command. For example, the `connections` argument is an [`AbstractConnections`](@ref) and we have

```@example s-bomb-3
using Sargassum # hide
using InteractiveUtils # hide
subtypes(AbstractConnections)
```

Then, we can examine the documentation of any of these by typing `?` to access the `help>` prompt followed by the desired name. For example, [`ConnectionsNearest`](@ref) reads

```@docs; canonical=false
ConnectionsNearest
```

In this case, we see that [`ConnectionsNearest`](@ref) assigns connections between a clump's `k`-nearest neighbors and has the constructor `ConnectionsNearest(n_clumps_max, neighbors)`. 

Refer to the simulation [API](simulation-api.md) for further information on the built-in options and refer to the [advanced](simulation-advanced.md) section for tutorials on building your own tools (e.g. building a custom biology model).

