"""
    abstract type AbstractConnections

A supertype for all connections between clumps.

Every subtype of `AbstractConnections` should be mutable with a field `connections` which is similar to a vector
of vectors such that that `connections[i]` is a list of clump indices that
are connected to clump `i`.

This should be updated in-place during the integration, i.e. it only shows the connections at the current time.

Every subtype of `AbstractConnections` should implement a `form_connections(con::Connections, u)` method which
returns what `con.connections` should be updated with, assuming that `u` is the solution vector. The correction
of indices due to living clumps is provided automatically later, so here it can be assumed that `u` contains
only living clumps.

Any subtype of `AbstractConnections` can be evaluated at an `OrdinaryDiffEq.integrator` for callback purposes.
"""
abstract type AbstractConnections end

# callback helper
function (::AbstractConnections)(integrator)
    living = integrator.p.living
    conns = form_connections(integrator.p.connections, view(integrator.u, :, living))
    conns2living = (1:integrator.p.n_clumps_max)[living]
    integrator.p.connections.connections[living] .= conns .|> x -> map(y -> conns2living[y], x)

    return nothing
end


"""
    struct ConnectionsNone

A connection type such that no clumps are connected.

### Constructor

    ConnectionsNone(n_clumps_max)
"""
struct ConnectionsNone <: AbstractConnections
    connections::Vector{Vector{Int64}}

    function ConnectionsNone(n_clumps_max::Integer)
        return new([Int64[] for _ = 1:n_clumps_max]) # 1:0 gives empty range
    end
end

function form_connections(con::ConnectionsNone, u)
    return [Int64[] for i = 1:size(u, 2)]
end

"""
    struct ConnectionsFull

A connection type such that every clump is connected to every other clump.

### Constructor

    ConnectionsFull(n_clumps_max)
"""
struct ConnectionsFull <: AbstractConnections
    connections::Vector{Vector{Int64}}
    
    function ConnectionsFull(n_clumps_max::Integer)
        return new([Int64[] for _ = 1:n_clumps_max]) 
    end
end

function form_connections(con::ConnectionsFull, u)
    return [collect(1:size(u,2)) for i = 1:size(u,2)]
end

"""
    struct ConnectionsRadius

A connection type such that every clump is connected to every clump within a given radius.

### Fields 

- `radius`: A distance (assumed in `UNITS["distance"]`) such that each clump is connected \
to every clump whose distance is at most `radius` from it.

### Constructor

    ConnectionsRadius(n_clumps_max, radius)
"""
struct ConnectionsRadius <: AbstractConnections
    connections::Vector{Vector{Int64}}
    radius::Float64

    function ConnectionsRadius(n_clumps_max::Integer, radius::Real)
        @argcheck radius > 0 "`radius` must be positive"

        return new([Int64[] for _ = 1:n_clumps_max], radius)
    end
end

function form_connections(con::ConnectionsRadius, u)    
    return inrange(BallTree(u), u, con.radius, true) # sortres = true sorts the indices for us
end

"""
    struct ConnectionsNearest

A connection type such that every clump is connected to a number of its nearest neighbors.

### Fields 

- `neighbors`: The number of nearest neighbors each clump should be connected to.

### Constructors

    ConnectionsNearest(n_clumps_max, neighbors)
"""
struct ConnectionsNearest <: AbstractConnections
    connections::Vector{Vector{Int64}}
    neighbors::Int64

    function ConnectionsNearest(n_clumps_max::Integer, neighbors::Integer)
        @argcheck neighbors > 0 "`neighbors` must be positive"

        return new([Int64[] for _ = 1:n_clumps_max], neighbors)
    end
end

function form_connections(con::ConnectionsNearest, u)
    k = con.neighbors + 1   # each point is considered one of its own nearest neighbors, so have to add 1     
    k = min(size(u, 2), k)  # there can not be more neighbors than there are clumps

    idx, dists = knn(KDTree(u), u, k)

    return idx .|> sort # sortres = true sorts by distance, not index value so do it manually
end


"""
    abstract type AbstractSpring

A supertype for all spring parameters. Each clump, when conncted, is joined by the same kind of spring.

Every subtype of `AbstractSpring` should have a field `k::Function` representing the stiffness force 
and callable as `k(x)` as well as a field `L::Real` representing the spring's natural length.

All forces are computed using 

```julia
parameters.k(d)*(parameters.L/d - 1)*(xy1 - xy2)
```

where `d = norm(xy1 - xy2)`.
"""
abstract type AbstractSpring end

"""
    HookeSpring{F}

A subtype of `AbstractSpring` representing a spring with a constant stiffness.

### Constructor

    HookeSpring(k::Real, L::Real)
"""
struct HookeSpring{F<:Function} <: AbstractSpring
    k::F
    L::Float64

    function HookeSpring(k::Real, L::Real)
        sk(x::Real; k::Real = k) = k
        return new{typeof(sk)}(sk, L)
    end
end

"""
    BOMBSpring{F}

A subtype of `AbstractSpring` representing a BOMB spring of the form `A * (exp((x - 2*L)/0.2) + 1)^(-1)`.

### Extra fields

- `A`: The amplitude of the force.

### Constructor

    BOMBSpring(A::Real, L::Real)
"""
struct BOMBSpring{F<:Function} <: AbstractSpring
    k::F
    L::Float64
    A::Float64

    function BOMBSpring(A::Real, L::Real)
        sk(x::Real; A::Real = A, L::Real = L) = A * (exp((x - 2*L)/0.2) + 1)^(-1)
        return new{typeof(sk)}(sk, L, A)
    end
end

"""
    ΔL(x_range, y_range; to_xy)

Compute a spring length from a rectangular arrangement of clumps provided by `x_range` and `y_range`. This is the distance between the centers of 
diagonally-adjacent gridpoints. These should be equirectangular coordinates.

### Optional Arguments

`to_xy`: If `true`, the coordinates are converted from spherical to equirectangular coordinates. Default `false`.
"""
function ΔL(x_range::AbstractRange, y_range::AbstractRange; to_xy::Bool = false)
    if to_xy
        x_range, y_range = sph2xy(x_range, y_range)
    end

    return norm([x_range[1], y_range[1]] - [x_range[2], y_range[2]])
end

"""
    ΔL(dist::SargassumDistribution)

Compute a spring length from a `SargassumDistribution`. This is the equirectangular distance between the centers of 
diagonally-adjacent gridpoints.
"""
function ΔL(dist::SargassumDistribution)
    p1 = sph2xy(dist.lon[1], dist.lat[1])
    p2 = sph2xy(dist.lon[2], dist.lat[2])
    return norm(p1 - p2)
end

"""
    ΔL(ics::InitialConditions; k::Integer)

Compute a spring length from a `InitialConditions`. This is the median among all pairwise 
equirectangular distances between points' `k` nearest neighbors. Default `k = 5`.
"""
function ΔL(ics::InitialConditions; k::Integer = 5)
    xy = ics.ics
    kdtree = KDTree(xy)
    idx, dists = knn(kdtree, xy, k, true)
    dists = [sum(d)/(k - 1) for d in dists] # k - 1 since self is included   

    return median(dists)
end