"""
    QuickRaftParameters()

Return a simple [`RaftParameters`](@ref) with fixed parameters suitable for testing purposes.
"""
function QuickRaftParameters()
    tspan = (DateTime(2018, 4, 13), DateTime(2018, 4, 15)) .|> datetime2time
    ics = InitialConditions(tspan, range(-55.0, -50.0, length = 5), range(5.0, 10.0, length = 5), to_xy = true)
    n_clumps_max = size(ics.ics, 2)
    clumps = ClumpParameters()
    springs = BOMBSpring(1.0, ΔL(ics))
    connections = ConnectionsNearest(n_clumps_max, 2)
    gd_model = ImmortalModel()
    land = Land()

    return RaftParameters(
        ics = ics,
        clumps = clumps,
        springs = springs,
        connections = connections,
        gd_model = gd_model,
        land = land,
        n_clumps_max = n_clumps_max
    )
end

"""
    QuickRaftParameters(ics; kwargs...)

Generate a [`RaftParameters`](@ref) object to integrate from `ics::InitialConditions`.

### Optional Arguments 

- `use_biology`: If `true`, include biological effects in the simulation. Default `false`.
- `n_connections`: The number of inter-clump nearest neighbor connectionsto form. Default `2`. 
- `delta`: The bouyancy of the particle. Default: `1.14`.
- `tau`: The inertial response time, measured in days. Default `0.0103`.
- `sigma`: The Stokes drift coefficient. Default `1.20`.
- `A_spring`: The magnitude of the eBOMB spring stiffness. Default `15.1`.
- `lambda_spring`: A factor multiplying the springs' natural lengths. Default `2.97`.
- `mu_max`: Sargassum maximum growth rate, measured in inverse days. Default `0.00542`.
- `m`: Sargassum mortality rate, measured in inverse days. Default `0.00403`.
- `k_N`: Sargassum nutrient (N) uptake half saturation, measured in mmol N/m^3. Default `0.000129`.
- `S_min`: A clump dies when it's "amount" drops below this value. Default `-0.00481`.
- `S_max`: A clump dies when it's "amount" grows above this value. Default `0.001`.
- `geometry`: A `Bool` that toggles whether to apply the geometric correction factors [`γ_sphere`](@ref) \
and [`τ_sphere`](@ref). Note that the simulation still uses the available interpolants, therefore if the \
interpolants have been created with geometric corrections included, but `RaftParameters` is created with \
`geometry == false`, the result will be a mixture of corrected and uncorrected terms. Default `true`.
- `verbose`: Whether to print out clump growths/deaths at each step. Default `false`.
"""
function QuickRaftParameters(
	ics::InitialConditions;
    use_biology::Bool = false,
	n_connections::Integer = 2, 
	delta::Real = 1.14,
    tau::Real = 0.0103,
    sigma::Real = 1.20,
    A_spring::Real = 15.1,
    lambda_spring::Real = 2.97,
    mu_max::Real = 0.00542,
    m::Real = 0.00403,
    k_N::Real = 0.000129,
    S_min::Real = -0.00481,
    S_max::Real = 0.001,
	geometry::Bool = true,
	verbose::Bool = false)
	
	n_clumps_max = size(ics.ics, 2)

	# Pick bio model
	if use_biology
		n_clumps_max_rp = 2*n_clumps_max
		gd_model = BrooksModel(
	        n_clumps_max_rp,
	        params = BrooksModelParameters(
	            μ_max = mu_max,
	            m = m,
	            k_N = k_N,
	            S_min = S_min,
	            S_max = S_max),
			verbose = verbose)
	else
		n_clumps_max_rp = n_clumps_max
		gd_model = ImmortalModel()
	end

	clumps = begin c_p = ClumpParameters(δ = delta) ; ClumpParameters(c_p.α, tau, c_p.R, c_p.Ω, sigma) end

	connections = ConnectionsNearest(n_clumps_max_rp, n_connections)
	
	return RaftParameters(
	    ics = ics,
	    clumps = clumps,
	    springs = BOMBSpring(A_spring, lambda_spring*ΔL(ics)),
	    connections = connections,
	    gd_model = gd_model,
	    land = Land(verbose = verbose),
	    n_clumps_max = n_clumps_max_rp,
		geometry = geometry,
	    fast_raft = false
	)
end