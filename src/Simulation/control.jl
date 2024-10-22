"""
    kill!(integrator, i)

Remove the clump with index `i` from `integrator`. 

Can be applied as kill!(integrator, inds) in which case each `i in inds` will be killed in order.

For the [`RaftParameters`](@ref), `rp = integrator.p`, update `rp.living` appropriately.
"""
function kill!(integrator::SciMLBase.DEIntegrator, i::Integer)
    !integrator.p.living[i] && error("kill! was called on a clump that was already dead, idx $(i)")
    integrator.p.living[i] = false
    sum(integrator.p.living) == 0 && terminate!(integrator)
    return nothing
end

function kill!(integrator::SciMLBase.DEIntegrator, inds::Vector{<:Integer})
    for i in inds
        kill!(integrator, i)
    end

    return nothing
end

"""
    grow!(integrator, location)

Add a clump to the [`RaftParameters`](@ref), `rp = integrator.p`, with an index equal to `rp.n_clumps_tot + 1` and also update `rp.living` appropriately.

### Location 

`location` can be a pre-defined flag, an integer, or a `[x, y]` vector. The default value is the flag `"parent"`.

The possible flags are:
- `"parent"`: A parent clump is chosen randomly among clumps that already exist, and the new clump is placed \
a distance `integrator.rp.springs.L` away and at a random angle from it.
- `"com"`: The same as `"parent"`, except the centre location is at the center of mass of the raft.

If `location` is an `Integer` with value `i`, then the new clump will be grown with `i`th clump (by vector location) as its parent.

If `location` is a `Vector{<:Real}`, the new clump will be placed at those `[x, y]` coordinates. 
"""
function grow!(
    integrator::SciMLBase.DEIntegrator; 
    location::Union{String, Integer, Vector{<:Real}} = "parent")

    rp = integrator.p
    u = integrator.u
    rp.n_clumps_tot.x == rp.n_clumps_max && error("grow! was called when the number of living clumps was equal to the maximum possible number.")
    rp.n_clumps_tot.x += 1
    new_idx = rp.n_clumps_tot.x
    rp.living[new_idx] = true

    if location isa String 
        @argcheck location in ["parent", "com"] "If `location` is a string, it must be either $("parent") or $("com")."
        if location == "parent"
            parent = rand(1:n_clumps_old)
            r, θ = rp.springs.L, rand(Uniform(0, 2*π))
            u[:, new_idx] .= clump_i(u, parent) + [r*cos(θ), r*sin(θ)]
        elseif location == "com"
            r, θ = rp.springs.L, rand(Uniform(0, 2*π))
            u[:, new_idx] .= com(u) + [r*cos(θ), r*sin(θ)]
        end
    elseif location isa Integer
        parent = location
        r, θ = rp.springs.L, rand(Uniform(0, 2*π))
        u[:, new_idx] .= clump_i(u, parent) + [r*cos(θ), r*sin(θ)]
    elseif location isa Vector 
        @argcheck length(location) == 2 "The location vector must be [x, y] coordinates."
        u[:, new_idx] .= location
    end
    
    return nothing
end
