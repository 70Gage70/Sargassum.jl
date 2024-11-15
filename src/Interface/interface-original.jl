### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 589f251d-a2df-4879-9933-4deb95a8003a
begin
    import Pkg
    Pkg.activate(".")
	Pkg.Registry.add("General")
	Pkg.add(url = "https://github.com/70Gage70/Sargassum.jl", rev = "master")
	Pkg.add([
		"PlutoUI", "HypertextLiteral", "NativeFileDialog", "PlutoHooks", "GLMakie", 
		"Dates", "JLD2", "MAT", "NetCDF", "Unitful"])
	
	using Sargassum
	using PlutoUI, HypertextLiteral, NativeFileDialog, PlutoHooks # interactivity in notebook
	using GLMakie # plots
	using Dates # dates
	using JLD2, MAT, NetCDF # io
	using Unitful # units

	try
		itps_load()
	catch
		itps_default_construct(download = true)
	end

	if isempty(Sargassum._SARGASSUM_DISTRIBUTION_PRECOMPUTED_SCRATCH.x)
		download_precomputed()
	end
	
	@info "Loaded dependencies."
end

# ╔═╡ 7fd8cc7c-a2e0-4cae-8448-e6a16d1b0b9c
module MyUnits
	using Unitful 
	@unit naumi "naumi" NauticalMile (1852)*u"m" false
	@unit knots "knots" Knots (0.5144)*u"m/s" false
	@affineunit alon "alon" (-180)u"°"
	@affineunit alat "alat" (-90)u"°"

	Unitful.register(@__MODULE__)
end

# ╔═╡ 7573642c-d0c4-4f44-bd21-c0c7cd0abf2a


# ╔═╡ c3eddd51-43c4-42f4-800a-ae9945df1e86
md"""
---
---
---
---
---
"""

# ╔═╡ 52e78695-a940-4a62-820b-71724a947c43
md"""
---
"""

# ╔═╡ 81769b34-5373-43fe-88ef-82bb3a714ff6
md"""
---
"""

# ╔═╡ 3770ede8-77e4-47e3-bb70-6fd4d486d0b7
md"""
---
"""

# ╔═╡ e0d8925d-cc12-4a72-a383-93f07cb3d495
md"""
---
"""

# ╔═╡ 9b647b4f-233f-4795-8760-7472eeea422d
md"""
---
"""

# ╔═╡ df24d7ca-2143-481d-80fe-b8f31f0a3bb8
md"""
---
"""

# ╔═╡ 66c7f34f-378d-4a37-a112-5032c4cf07a4
md"""
---
---
"""

# ╔═╡ d512eee1-890c-40ce-ab0e-54d1004ad5d2
# Spacer
md"""
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
"""

# ╔═╡ f6b36bcc-5162-4d84-a1a2-9cb3ff0e8ac1
md"""
# Interface Engine
"""

# ╔═╡ ea2ec22b-69ab-40d6-b8ea-704e4e6c3de8
md"""
!!! danger "Danger Zone!"
	\
	\
	**Don't edit anything after this point unless you know what you're doing!** 😀
	\
	\
	\
"""

# ╔═╡ 10a16ae5-044a-47e2-8964-13b334f5d0a8
md"""
## Front Matter
"""

# ╔═╡ 1b874c8c-08dd-4064-9afc-d62b2e900921
begin
	@info "Setting notebook width."
	html"""
	<style>
		main {
			margin: 0 auto;
			max-width: 2000px;
	    	padding-left: 31%;
	    	padding-right: 20%;
		}
	</style>
	"""
end

# ╔═╡ 8638b7a5-1ee0-47d2-aa6b-54cc9ab996ff
begin

@info "Hiding header"

html"""
<style>
    header {
		display:none
    }
</style>
"""
end

# ╔═╡ 65c5d259-943f-432a-8e02-ba77c8650723
begin

@info "Hiding Pluto errors"
	
html"""<style>.dont-panic{ display: none }</style>"""
end

# ╔═╡ 7ca9e647-d06e-4815-b30b-eb1a4e5f1577
md"""
## Simulation
"""

# ╔═╡ 65b2ceb8-40d4-4f97-9541-36e0023c5d6b
md"""
### Initial Conditions
"""

# ╔═╡ 8ba55d2d-53fa-4206-872c-0470e76fcf6b
md"""
### Clump Parameters
"""

# ╔═╡ 943f8d1a-335a-4321-8d2b-b29e5ca5845c
md"""
### Springs
"""

# ╔═╡ 2e4142db-6a64-4c57-a227-8d055f458863
md"""
### N clumps max
"""

# ╔═╡ cac6046f-0d45-4f1a-b062-b8cc53044807
md"""
### Connections
"""

# ╔═╡ 8e250f3e-e5b9-4c76-9eac-39a4a60ded57
md"""
### Growth and Death
"""

# ╔═╡ 7aea397d-a1b3-4e2d-a265-3b528762415c
md"""
### Land
"""

# ╔═╡ fb9970b9-25a9-4235-a01c-5f4b6b2b2580
md"""
### Integration
"""

# ╔═╡ 7d0b8d87-d783-467b-8240-deaa2e88963d
md"""
## Display
"""

# ╔═╡ 58d3a9da-c4df-4ec3-953e-1946495945bc
let
	@info "Defining inspected plot options."
	
	ui_inspect_plot(Child) = md"""
		Plot type: $(Child(Select(["Trajectories", "Heat Map"], default = "Trajectories")))
		"""
	global plot_window = @bind plot_params PlutoUI.combine() do Child
		ui_inspect_plot(Child)
	end

	nothing
end

# ╔═╡ c29585d8-885c-4b5a-b530-9d34ec8daeb2
md"""
### Sargassum Distribution
"""

# ╔═╡ 154d4bd2-85c9-41dd-a68e-1f9028c55500
md"""
## Exporting
"""

# ╔═╡ e90936ec-f215-4a03-bd75-da2df6308ed0
md"""
## Utilities
"""

# ╔═╡ 67c5ed03-7e1b-4c4d-8fa1-837848a37924
ad(text, kind) = Markdown.MD(Markdown.Admonition(kind, "", [text]))

# ╔═╡ b503b1ff-18b5-46b9-9809-88b54240a762
let
	tutorial = md"""
	This is the interface to the [Sargassum.jl](https://github.com/70Gage70/Sargassum.jl) package and companion packages.

	- The interface will look best in fullscreen mode.
	
	- All of the integration parameters - including the ability to create and load your own interpolants - are set in this column. Scroll down to see them all, and click the [❓HELP❓] boxes for further explanation.

	- Tip! When adjusting sliders, click on them and use your arrow keys to make small changes. Try it: $(@bind test_slide PlutoUI.Slider(1:0.1:10, show_value = true))

	- The main integration plot is displayed on the upper left of the screen. When parameters are changed the plot is hidden. When you are done changing parameters, click `RUN` to recompute the plot.

	- After a plot is created, a new button will appear labeled `Inspect/export`. This will open up a much larger view of the plot along with some further parameters to edit and and interface allowing you to export the data.

	- At the bottom left of the screen, the AFAI-derived satellite data can be viewed by checking `Show satellite data` and setting the desired date and plot parameters. Currently, only select months from 2017 and 2018 are available.

	- At the top right of the screen, further information about the interface can be found.
	"""

	troubleshooting = md"""
	- If the progress bar is hanging, or the interface seems unresponsive, refreshing the page will almost always fix this. This is **non-destructive**, you won't lose any of your work. 
	- If a major problem occurs, press the `RESTART` button in the top right drop-down box. This is **destructive**, you will lose your work. 
	- If you expected some output, but didn't get any, double check that any entered values adhere to the guidelines in the relevant [❓ HELP ❓] box.
	- Still having problems? Open an issue on [GitHub](https://github.com/70Gage70/Sargassum.jl).
	"""

	advanced = md"""
	- All of the code that runs this interface is right here! Click on the eye 👁 icons to the left of each cell to see the code that generated it.
	- For example, the slider values in this interface have been chosen to assume reasonable ranges. If you wanted to extend those, all you would have to do is open the code and change something like `Slider(1.0:0.1:10.0)` to `Slider(1.0:0.1:20.0)`.
	- Want to dig even deeper? See [Sargassum.jl](https://github.com/70Gage70/Sargassum.jl).
	"""

	blurb = md"""
	# Sargassum.jl Interface
	$(details("💡 Click me for tutorial! 💡", tutorial))
	$(details("🛠️ Troubleshooting 🛠️", troubleshooting))
	$(details("⚙️ Advanced Usage ⚙️", advanced))
	"""
	
	ad(blurb, "danger")
end

# ╔═╡ 6e7da02d-a6ac-4065-9b8a-370033450646
let
	itp_loader_help = md"""
	- Here you can load any custom interpolants you have created. Check the box of the associated interpolant you would like to load. Uncheck the box to return to the default interpolants.

	- This will open up a prompt for you to pick a file. Interpolants are stored in the `.jld2` file format. *Don't see a prompt?* It might not have been brought to the front of the screen if you're viewing the interface in fullscreen mode.

	- To *make* your own interpolants, see the next section of the interface.

	- Refer to the help section of "Current active interpolants" above for further information on the meaning of each interpolant.
	"""
	
	wtr(Child) = Child(CheckBox(default = false))
	wnd(Child) = Child(CheckBox(default = false))
	stk(Child) = Child(CheckBox(default = false))
	tmp(Child) = Child(CheckBox(default = false))
	nut(Child) = Child(CheckBox(default = false))
		
	ui_itp_loader(Ch) = md"""
	### Load custom interpolants

	$(details("❓ HELP ❓", itp_loader_help))
	
	| Water      | Wind       | Stokes     | Temperature | Nutrients   |
	|:----------:|:----------:|:----------:|:-----------:|:-----------:|
	| $(wtr(Ch)) | $(wnd(Ch)) | $(stk(Ch)) | $(tmp(Ch))  | $(nut(Ch))  |
	"""

	@bind custom_itp_load PlutoUI.combine() do Child
		ad(ui_itp_loader(Child), "info")
	end
end

# ╔═╡ 7f2022c7-a510-46a5-9090-84f58693815c
let
	custom_itp_load;
	
	help_blurb = md"""
	This box allows you inspect the details of the active interpolants "at-a-glance." Refer to this to ensure that your integration ranges fall within these limits. The following interpolants are active:

	- `Water Velocity`: The ocean velocity.
	- `Wind Velocity`: The wind velocity.
	- `Stokes Drift`: The Stokes drift velocity.
	- `Temperature`: The ocean temperature.
	- `Nutrients`: The nutrient content of the ocean. Currently, only nitrogen content is used.

	When you load custom interpolants, the inspection window will close automatically if it is already open, since the limits may change. Re-open it to see the new limits.
	"""

	toggle(Child) = Child(CheckBox(default = false))

	final_blurb = md"""
	## Current active interpolants

	$(details("❓ HELP ❓", help_blurb))

	**Inspect interpolants**: $(@bind check_limits CheckBox(default = false))
	
	"""

	ad(final_blurb, "tip")
end

# ╔═╡ c6cf756a-1c17-44bc-8655-b2d674888971
water_load, wind_load, stokes_load, temp_load, nutr_load = custom_itp_load; # toggling one load checkbox won't trigger the others

# ╔═╡ cb2ae3f7-ee48-43e3-8a98-e89977440305
let
	help = md"""
	- This part of the interface will allow you to create custom interpolants from raw data. The raw data is assumed to be uniformly gridded.

	- Your data must be stored in either a `.nc` or `.mat` format. When you choose the appropriate format, a prompt will open and you may select your file.

	- The interface will expand with further instructions.

	- After you have created your interpolant, you can load it with the "Load custom interpolants" block above.

	- Reset this part of the interface by setting the file type to be blank.
	"""
	
	blurb = md"""
	## Create custom interpolants

	$(details("❓ HELP ❓", help))
	
	| Interpolant kind | File type | 
	|:--:|:--:|
	| $(@bind itp_make_kind Select(["WATER", "WIND", "STOKES", "TEMPERATURE", "NUTRIENTS"], default = "WATER")) | $(@bind itp_make_raw_file_type Select(["", ".nc", ".mat"], default = "")) |
	"""
		
	ad(blurb, "info")
end

# ╔═╡ 8f0df9e4-3cc9-4265-9727-14bd7cf4497f
begin
	local blurb = md"""
	These settings control the initial locations of clumps. One of two types of initial position distributions can be chosen.
	
	- `"Rectangle"`: Clumps are initialized in a rectangle inside the defined latitude/longitude box with `N clumps x` in the ``x`` direction and `N clumps y` in the ``y`` direction. The integration takes place between the indicated initial and final times.
	
	- `"AFAI"`: Clumps are initialized according to the Sargassum distribution at the indicated date and week. `Levels` is related to the total number of clumps; the higher it is, the closer the initialized distribution is to the actual distribution. The integration starts at the indicated date and week and proceeds for the number of selected weeks.
	"""
	ad(
		md""" 
		## Initial Conditions 
		$(details("❓ HELP ❓", blurb))""", 
	"tip")
end

# ╔═╡ 62907762-cad8-483f-9dd1-5907c43b49ab
let	
	blurb = md"""
		### Initial conditions type: $(@bind ics_type Select(["Rectangle", "AFAI"], default = "AFAI"))
		"""
	ad(blurb, "info")

end

# ╔═╡ ed4f082b-237c-4b08-b3b9-2f1846b0ecfb
let
	if ics_type == "Rectangle"

	lonmin(Child) = Child(PlutoUI.Slider(-100:-40; default=-55, show_value = true))
	lonmax(Child) = Child(PlutoUI.Slider(-100:-40; default=-50, show_value = true))
	latmin(Child) = Child(PlutoUI.Slider(0:40; default=5, show_value = true))
	latmax(Child) = Child(PlutoUI.Slider(0:40; default=10, show_value = true))
	ncx(Child) = Child(PlutoUI.Slider(1:50; default=5, show_value = true))
	ncy(Child) = Child(PlutoUI.Slider(1:50; default=5, show_value = true))
		
	ui_rect(Child) = md"""
	### Rectangular distribution parameters
	
	|               |                   |               |                   |
	|---------------|-------------------|---------------|-------------------|
	| Lon min (°) | $(lonmin(Child))  | Lat min (°)  | $(latmin(Child))  |
	| Lon max (°) | $(lonmax(Child))  | Lat max (°) | $(latmax(Child)) |
	| N clumps x    | $(ncx(Child)) | N clumps y    | $(ncy(Child)) |
	"""
	@bind rect_params PlutoUI.combine() do Child
		ad(ui_rect(Child), "info")
	end
		
	end # if
end

# ╔═╡ 76d60013-1856-4970-b2bd-cebea929fbd6
let
	if ics_type == "Rectangle"
		dst(Child) = Child(DatePicker(default = Date(2018, 4, 07)))
		den(Child) = Child(DatePicker(default = Date(2018, 4, 14)))
		
		ui_tspan(Child) = md"""
		### Integration time span
		
		| Start Date    | End Date     | 
		|:---------------:|:---------------:|
		| $(dst(Child))| $(den(Child)) |
		"""
		@bind tspan_data_rect PlutoUI.combine() do Child
			ad(ui_tspan(Child), "info")
		end
	end
end

# ╔═╡ ebc20b02-83d5-4b94-ae76-16a1bd619312
let
	if ics_type == "AFAI"
		ui_tspan(Child) = md"""
			### Integration time span
			Weeks: $(Child(PlutoUI.Slider(1:20; default=1, show_value = true)))
			"""
		@bind tspan_data_afai PlutoUI.combine() do Child
			ad(ui_tspan(Child), "info")
		end
	end
end

# ╔═╡ 75898dc7-beec-4c4d-8580-79ec1df8cc42
begin
	local blurb = md"""
	These settings control the physics parameters for each clump.
	
	- ``\delta``: The buoyancy of the clump, where $\delta \geq 1$.
	- ``a``: The radius of the (assumed spherical) clump.
	- ``\sigma``: The prefactor multiplying the Stokes drift.
	- ``\alpha``: The "leeway" parameter. Depends on ``\delta`` in general, select the `"Force"` checkbox to ignore this dependence.
	- ``\tau``: The inertial response time. Depends on ``\delta`` and ``a`` in general, select the `"Force"` checkbox to ignore this dependence.
	"""
	ad(
		md""" 
		## Clump Parameters
		$(details("❓ HELP ❓", blurb))""", 
	"tip")
end

# ╔═╡ d2dd84eb-e2cc-4c32-9966-7803549a993d
let
	delta(Child) = Child(PlutoUI.Slider(1.01:0.01:1.30; default = 1.14, show_value = true))
	a(Child) = Child(PlutoUI.Slider(0.1:0.1:10.0; default = 1.0, show_value = true))
	sigma(Child) = Child(PlutoUI.Slider(0.5:0.01:1.5; default = 1.2, show_value = true))
	alpha(Child) = Child(PlutoUI.Slider(0.1:0.01:3; default = 0.33, show_value = true))
	tau(Child) = Child(PlutoUI.Slider(0.01:0.01:0.4; default = 0.01, show_value = true))
	forcealpha(Child) = Child(CheckBox(default = true))
	forcetau(Child) = Child(CheckBox(default = true))
	
	

	ui_clump_params(Child) = md"""
	| Parameter   | Units      | Value       | Force     | 
	|:-------------:|:------------:|:-------------:|:-----------:|
	| ``\delta``  | ``\cdot``  | $(delta(Child))  | ``\cdot`` |
	| ``a``       | ``\times 10^{-4} \, \text{km}``  | $(a(Child))  | ``\cdot`` |
	| ``\sigma``  | ``\cdot``  | $(sigma(Child))  | ``\cdot`` |
	| ``\alpha``  | ``\%``  | $(alpha(Child))  | $(forcealpha(Child)) |
	| ``\tau``    | ``\text{d}``  | $(tau(Child))  | $(forcetau(Child)) |
	"""
	
	@bind clump_parameters PlutoUI.combine() do Child
		ad(ui_clump_params(Child), "info")
	end
end

# ╔═╡ 8c14a852-3bd4-4dda-b812-6c1378d676d5
let
	δ, a, σ, α, force_α, τ, force_τ = clump_parameters
	α = α * 0.01
	a = a * 10^(-4)
	global clumps = ClumpParameters(δ = δ, a = a, σ = σ)

	if force_α
		
		clumps = ClumpParameters(α, clumps.τ, clumps.R, clumps.Ω, clumps.σ)
	end

	if force_τ
		clumps = ClumpParameters(clumps.α, τ, clumps.R, clumps.Ω, clumps.σ)
	end

	clumps
end

# ╔═╡ 6bda3ba9-fbba-4ce5-8a23-0c606845b31a
begin
	local blurb = md"""
	These settings control the physics parameters for the springs connecting paris of clumps.

	The natural length of the spring is chosen dynamically based on initial conditions.
	
	- `"BOMB"`: Has a stiffness function ``k(x) = k (1 + \exp((x - 2L)/0.2))^{-1}`` where ``L`` is the natural length of the spring.
	- `"Hooke"`: Has a stiffness function ``k(x) = k``.

	Select ``\times 10`` to multiply the displayed value by ``10``.
	"""
	ad(
		md""" 
		## Spring Parameters
		$(details("❓ HELP❓ ", blurb))""", 
	"tip")
end

# ╔═╡ 72107d04-8ce2-4636-921b-d52d8431be46
let
	ktype(Child) = Child(Select(["BOMB", "Hooke"], default = "BOMB"))
	kval(Child) = Child(PlutoUI.Slider(0.1:0.1:20.0; default = 10.0, show_value = true))
	tten(Child) = Child(CheckBox(default = false))
	
	ui_clump_params(Child) = md"""
	| Type             | ``k \, [\text{d}^{-2}]`` | ``\times 10`` |
	|:----------------:|:------------------------:|:-------------:|
	| $(ktype(Child))  | $(kval(Child))           | $(tten(Child))|
	"""
	
	@bind spring_parameters PlutoUI.combine() do Child
		ad(ui_clump_params(Child), "info")
	end
end

# ╔═╡ c60bb5f5-82b7-484c-b56b-ded74a1e651f
begin
	local blurb = md"""
	These settings control the logic that determines how clumps are connected by springs.

	- `"Full"`: every clump is connected to every other clump.
	- `"None"`: no clumps are connected.
	- `"Radius"`: each clump is connected to each clump within a radius of `Radius multiple` multipled by the natural length of the spring.
	- `"Nearest"`: each clump is connected to a number of its nearest neighbors.
	"""
	ad(
		md""" 
		## Connections
		$(details("❓ HELP ❓", blurb))""", 
	"tip")
end

# ╔═╡ e1fd0825-6b16-4fb6-9358-4252b1bd77e9
let
		
	blurb = md"""
		### Connections Type: $(@bind conn_type Select(["Full", "None", "Radius", "Nearest"], default = "Nearest"))
		"""
	ad(blurb, "info")

end

# ╔═╡ 3b123c70-d3b9-4b3d-8c38-f4d3457f079d
let
	if conn_type == "Nearest"
		
		ui_conn_nearest(Child) = md"""
			Number of neighbors: $(Child(PlutoUI.Slider(1:20, default = 2, show_value = true)))
			"""
		@bind conn_params PlutoUI.combine() do Child
			ad(ui_conn_nearest(Child), "info")
		end

	elseif conn_type == "Radius"

		ui_conn_radius(Child) = md"""
			Radius multiple: $(Child(PlutoUI.Slider(0.1:0.1:5.0, default = 2.0, show_value = true)))
			"""
		@bind conn_params PlutoUI.combine() do Child
			ad(ui_conn_radius(Child), "info")
		end

	else 
		conn_params = (nothing,)
		nothing
	end # if
end

# ╔═╡ 5bdbce07-0f50-459f-8ea6-6bb670aea47d
begin
	local blurb = md"""
	These settings control the biology parameters for the lifecyles model.

	There are two models, `"Immortal"` and `"Brooks"`. 
	
	The `"Immortal"` model has no parameters, and no clumps with grow or die by biological effects. 
	
	The `"Brooks"` model has the following parameters:
	
	- ``\mu_\text{max}``: Sargassum maximum growth rate.
	- ``m``: Sargassum mortality rate.
	- ``k_\text{N}``: Sargassum nitrogen (N) uptake half saturation.
	- ``T_\text{min}``: The temperature below which there is no growth.
	- ``T_\text{max}``: The temperature above which there is no growth. The optimal growth temperature is taken to be ``(T_{\text{min}} + T_{\text{max}})/2``.
	- ``S_{\text{min}}``: The threshold for clump death. Smaller values of ``S_{\text{min}}`` makes it harder for clumps to die.
	- ``S_{\text{max}}``: The threshold for clump growth. Larger values of ``S_{\text{max}}`` makes it harder for clumps to grow.
	- ``C_{\text{min}}`` the number of clumps will not die below this value multiplied by the initial number of clumps. If ``C_{\text{min}} = 0``, then the integration may stop early if all clumps die.
	- ``C_{\text{max}}`` the number of clumps will not grow above this value multiplied by the initial number of clumps.
	"""
	ad(
		md""" 
		## Biology
		$(details("❓ HELP ❓", blurb))""", 
	"tip")
end

# ╔═╡ 61ebe90a-60e9-4e77-9a24-a793e4701209
let
	blurb = md"""
		### Life Cycles Model: $(@bind gd_type Select(["Immortal", "Brooks"], default = "Immortal"))
		"""
	ad(blurb, "info")

end

# ╔═╡ dd199ecb-16cf-4e58-8918-64077b6c192c
let
	if gd_type == "Brooks"

	mu(Child) = Child(PlutoUI.Slider(0.1:0.01:10; default = 0.54, show_value = true))
	m(Child) = Child(PlutoUI.Slider(0.1:0.01:10; default = 0.40, show_value = true))
	kN(Child) = Child(PlutoUI.Slider(0.1:0.01:10; default = 1.29, show_value = true))
	Tmn(Child) = Child(PlutoUI.Slider(5:20; default = 10, show_value = true))
	Tmx(Child) = Child(PlutoUI.Slider(30:50; default = 40, show_value = true))
	Smn(Child) = Child(PlutoUI.Slider(-1.0:0.01:0.0; default = -0.48, show_value = true))
	Smx(Child) = Child(PlutoUI.Slider(0.0:0.01:1.0; default = 0.1, show_value = true))
	Cmn(Child) = Child(PlutoUI.Slider(0:0.01:1.0; default = 0.0, show_value = true))
	Cmx(Child) = Child(PlutoUI.Slider(1.0:0.01:3.0; default = 2.0, show_value = true))

	ui_gd_params(Child) = md"""
	| Parameter             | Units                            | Value           | 
	|:---------------------:|:--------------------------------:|:---------------:|
	| ``\mu_{\text{max}}``  |``\times 10^{-2} \, \text{d}^{-1}``  |$(mu(Child)) |
	| ``m``                 |``\times 10^{-2} \, \text{d}^{-1}``  |$(m(Child)) |
	| ``k_{\text{N}}``      |``\times 10^{-4} \, \text{mmol/m}^3``|$(kN(Child)) |
	| ``T_{\text{min}}``    | ``\degree \text{C}``            | $(Tmn(Child)) |
	| ``T_{\text{max}}``    | ``\degree \text{C}``            | $(Tmx(Child)) |
	| ``S_{\text{min}}``    | ``\times 10^{-2}``  | $(Smn(Child)) |
	| ``S_{\text{max}}``    | ``\times 10^{-2}`` | $(Smx(Child)) |
	| ``C_{\text{min}}``    | ``\cdot``  | $(Cmn(Child)) |
	| ``C_{\text{max}}``    | ``\cdot``  | $(Cmx(Child)) |
	"""
	
	@bind gd_params_brooks PlutoUI.combine() do Child
		ad(ui_gd_params(Child), "info")
	end
		
	end # if
end

# ╔═╡ e537ca5d-86d6-423b-a3b9-d9ba503c4d31
begin
	local blurb = md"""
	These settings control how clumps interact with land/shorelines.

	There are two models, `"Land"` and `"NoLand"`. 
	
	In the `"Land"` model, clumps die when reaching land or hitting a shoreline. 

	In the `"NoLand"` model, clumps do not die when reaching land or hitting a shoreline. 
	"""
	ad(
		md""" 
		## Land
		$(details("❓ HELP ❓", blurb))""", 
	"tip")
end

# ╔═╡ 8a5827c1-8655-4808-8fe0-ff46fc25f982
begin
		
	local blurb = md"""
		### Land Model: $(@bind land_type Select(["Land", "NoLand"], default = "Land"))
		"""
	ad(blurb, "info")

end

# ╔═╡ 4568d0b9-e6a2-4653-abc5-44e229cc3ded
begin
	if land_type == "Land"
		land = Land()
	elseif land_type == "NoLand"
		land = NoLand()
	end
	land
end

# ╔═╡ 99b628f1-c072-4d06-a32c-1d0f8d4789bb
let
	blurb = md"""
			# End of interface
			"""

	ad(blurb, "danger")
end

# ╔═╡ 084700f3-4f35-466f-91e1-f4853c426abf
let
	@info "Defining notebook info box."

	restart_button = HTML("""
	<!-- the wrapper span -->
	<div>
		<button id="myrestart" href="#">Restart</button>
		
		<script>
			const div = currentScript.parentElement
			const button = div.querySelector("button#myrestart")
			const cell= div.closest('pluto-cell')
			console.log(button);
			button.onclick = function() { restart_nb() };
			function restart_nb() {
				console.log("Restarting Notebook");
			        cell._internal_pluto_actions.send(                    
			            "restart_process",
	                            {},
	                            {
	                                notebook_id: editor_state.notebook.notebook_id,
	                            }
	                        )
			};
		</script>
	</div>
	""")	

	blurb = md"""
	This is a [Pluto notebook](https://plutojl.org/) powered by the [Julia programming language](https://julialang.org/).

	- [GitHub](https://github.com/70Gage70/Sargasum.jl)
	- [Citation](https://70gage70.github.io/Sargassum.jl/dev/cite)
	
	$(restart_button)
	"""

	blurb2 = ad(
		details("ABOUT/CITE/RESTART", [blurb], open = false), 
	"warning")
	
	@htl """<div style="
	position: fixed; 
	right: 1rem; 
	top: 1rem; 
	padding: 1px;
	text-align: left;
	z-index: 99;
	max-width: 18%;
	background-color: var(--main-bg-color);">
	$(blurb2)
	</div>"""
end

# ╔═╡ e25ab537-8be8-46e1-9b8c-e9c1f8a4dc30
let
	@info "Defining reactive plot button."

	plot_box = ad(
	md"""
	Simulation: $(@bind trigger_calculation CounterButton("RUN"))
	""", 
	"danger")

	@htl """<div style="
	position: fixed; 
	left: 1rem; 
	top: 1rem; 
	padding: 1px;
	text-align: left;
	z-index: 100;
	max-width: 20%;
	max-height: 10%;
	background-color: var(--main-bg-color);">
	$(plot_box)
	</div>"""
end

# ╔═╡ 78a2638f-f10e-443f-835e-0c8454981617
begin
	@info "Defining inspect plot trigger."
	
	plot_box = ad(
	md"""
	Inspect/export: $(@bind inspect_plot CheckBox(default=false))
	""", 
	"danger")

	nothing
end

# ╔═╡ 32f6f7a5-19b7-4c71-9d0a-865d4f6d0506
let

@info "Defining inspected plot background 1."
	
	if inspect_plot
	
		@htl """<div style="
		position: fixed; 
		left: 1rem; 
		top: 6rem; 
		padding: 1000px;
		text-align: left;
		z-index: 100;
		max-width: 75%;
		background-color: var(--main-bg-color);">
		</div>"""
	end
end

# ╔═╡ a9741ea1-32b7-477a-be23-a3f74fe8c359
let

@info "Defining inspected plot background 2."
	
	if inspect_plot
	
		@htl """<div style="
		position: fixed; 
		right: 1rem; 
		top: 0rem; 
		padding: 35%;
		text-align: left;
		z-index: 100;
		max-width: 20%;
		background-color: var(--main-bg-color);">
		</div>"""
	end
end

# ╔═╡ e75adad7-7416-4962-9308-44e1425a8ff3
let
	@info "Defining inspected plot options window."

	if inspect_plot
		@htl """<div style="
		position: fixed; 
		right: 1rem; 
		top: 6rem; 
		padding: 1px;
		text-align: left;
		z-index: 101;
		max-width: 20%;
		background-color: var(--main-bg-color);">
		$(ad(plot_window, "info"))
		</div>"""
	end
end

# ╔═╡ a7de95ce-62b9-40e6-a7f5-1d833bedff87
let
	@info "Defining export options window."

	export_details = md"""
	Select the `".mat"` type to export the raw trajectory data in [MATLAB's file format](https://www.mathworks.com/help/matlab/import_export/mat-file-versions.html). Choose this option if you want the most control over the data.

	Select the `".nc"` type to export binned trajectory data in a [NetCDF file format](https://github.com/JuliaGeo/NetCDF.jl). Choose this option if you primarily need distribution data.

	Select `".png"` to output the figure itself.

	Check "With parameters" to output the physics/biology parameters as well as the trajectories. These are incompatible wit `".nc"` files, so a separate `.mat` file is created in that case.
	"""
	
	export_blurb = md"""
	$(details("❓ EXPORT HELP ❓", export_details))
	Type: $(@bind export_type Select([".mat", ".nc", ".png"], default = ".mat"))
	
	With parameters: $(@bind export_parameters CheckBox(default = true))
	
	$(@bind export_button CounterButton("EXPORT"))
	"""
	
	export_blurb = ad(export_blurb, "info")
	
	if inspect_plot
		@htl """<div style="
		position: fixed; 
		right: 1rem; 
		top: 10rem; 
		padding: 1px;
		text-align: left;
		z-index: 101;
		max-width: 30%;
		background-color: var(--main-bg-color);">
		$(export_blurb)
		</div>"""
	end
end

# ╔═╡ 59ae76ce-1655-4173-a368-125805c75497
let
	afyrmn = keys(SARGASSUM_DISTRIBUTION_PRECOMPUTED) |> collect |> sort
	
	NUM2MON = Dict(1 => "JAN", 2 => "FEB", 3 => "MAR", 4 => "APR", 5 => "MAY", 6 => "JUN", 7 => "JUL", 8 => "AUG", 9 => "SEP", 10 => "OCT", 11 => "NOV", 12 => "DEC")

	afyrmn_parsed = ["$(valid[1]), $(NUM2MON[valid[2]])" for valid in afyrmn]

	global VALID_AFAI_YEAR_MONTHS = afyrmn .=> afyrmn_parsed
end

# ╔═╡ c75d9b70-d3bb-41fe-84bf-53c0ab41f406
let
	if ics_type == "AFAI"
		
	afyrmn(Child) = Child(Select(VALID_AFAI_YEAR_MONTHS, default = (2018, 4)))
	afwk(Child) = Child(Select([1, 2, 3, 4], default = 1))
	aflv(Child) = Child(PlutoUI.Slider(1:20; default=1, show_value = true))
		
	ui_afai(Child) = md"""
	### AFAI-based initial distribution parameters

	AFAI distributions are only available at certain times.
	
	| Year/Month      | Week              | Levels         |
	|:-----------------:|:-------------------:|:----------------:|
	| $(afyrmn(Child))| $(afwk(Child))    | $(aflv(Child)) |
	"""

	@bind afai_params PlutoUI.combine() do Child
		ad(ui_afai(Child), "info")
	end
		
	end # if
end

# ╔═╡ 2c38594d-7d78-49d8-9597-0b723f56e76f
let
	if ics_type == "Rectangle"
		t1, t2 = tspan_data_rect .|> DateTime .|> datetime2time
		tspan = (t1, t2)
		cor = rect_params[1:4] # lon min, lat min, lon max, lat max
		n_c_xy = rect_params[5:6]
		x_range = range(cor[1], cor[3], length = n_c_xy[1])
		y_range = range(cor[2], cor[4], length = n_c_xy[2])
		global ics = InitialConditions(tspan, x_range, y_range, to_xy = true)
	elseif ics_type == "AFAI"
		y1, m1 = afai_params[1]
		w1 = afai_params[2]
		levels = afai_params[3]
		y2, m2, w2 = ymwplusweek((y1, m1, w1), tspan_data_afai[1])
		tspan = (ymw2time(y1, m1, w1), ymw2time(y2, m2, w2))
		dist = SARGASSUM_DISTRIBUTION_PRECOMPUTED[(y1, m1)]
		global ics = InitialConditions(tspan, dist, [w1], levels)
	end
end

# ╔═╡ a644a9ff-9cf2-4121-a764-ea2e3cbb76d9
try
	y1, m1 = afai_params[1]
	w1 = afai_params[2]
	y2, m2, w2 = ymwplusweek((y1, m1, w1), tspan_data_afai[1])
	ad(md"""Integrating from week $(w1) of $(monthname(m1)), $(y1) --> week $(w2) of $(monthname(m2)), $(y2) with $(size(ics.ics,2)) clumps.""", "info")
catch
	try
		d1 = DateTime(tspan_data_rect[1])
		d2 = DateTime(tspan_data_rect[2])
		ad(md"""Integrating from $(monthname(d1)), $(day(d1)), $(year(d1)) --> $(monthname(d2)), $(day(d2)), $(year(d2)) with $(size(ics.ics,2)) clumps.""", "info")
	catch
		ad(md"""**Total clumps: ERROR**""", "info")
	end
end

# ╔═╡ 4430e3f8-ee7d-46ab-a98a-573db7815670
let
	spring_type, amplitude, tten = spring_parameters
	amplitude = tten ? amplitude * 10 : amplitude

	if spring_type == "BOMB"
		global springs = BOMBSpring(amplitude, ΔL(ics))
	elseif spring_type == "Constant"
		global springs = HookeSpring(amplitude, ΔL(ics))
	end
end

# ╔═╡ c979a8ff-c400-419e-9199-886d17bdda6a
if gd_type == "Brooks"
	n_clumps_max = round(Int, size(ics.ics, 2)*gd_params_brooks[end], RoundUp)
else
	n_clumps_max = size(ics.ics, 2)
end

# ╔═╡ 7f4daf85-2b36-4450-bf48-a4d77b4d4af3
begin
	if conn_type == "None"
		connections = ConnectionsNone(n_clumps_max)
	elseif conn_type == "Full"
		connections = ConnectionsFull(n_clumps_max)
	elseif conn_type == "Nearest"
		connections = ConnectionsNearest(n_clumps_max, conn_params[1])
	elseif conn_type == "Radius"
		connections = ConnectionsRadius(n_clumps_max, conn_params[1]*ΔL(ics))
	end
end

# ╔═╡ dc6651a1-4c47-4cd7-a831-f37812e8a8e6
let
	if gd_type == "Immortal"
        global gd_model = ImmortalModel()
	elseif gd_type == "Brooks"
		μ_max, m, k_N, T_min, T_max, S_min, S_max, c_min, c_max = gd_params_brooks
		μ_max = μ_max * 10^(-2)
		m = m * 10^(-2)
		k_N = k_N * 10^(-4)
		S_min = S_min * 10^(-2)
		S_max = S_max * 10^(-2)
		c_min = c_min*size(ics.ics, 2) |> x -> round(Int, x, RoundDown)
		
        bmp = BrooksModelParameters(
            μ_max = μ_max,
            m = m,
            k_N = k_N,
			T_min = T_min,
			T_max = T_max,
			S_min = S_min,
			S_max = S_max,
			clumps_limits = (c_min, n_clumps_max))
       
		global gd_model = BrooksModel(n_clumps_max, params = bmp)
    end
end

# ╔═╡ d355db80-b403-4200-a4b4-a6eb6f13a79e
begin
	@info "Calculating integration."

	custom_itp_load;
	
	rp = RaftParameters(
				ics = ics,
				clumps = clumps,
				springs = springs,
				connections = connections,
				gd_model = gd_model,
				land = land,
				n_clumps_max = n_clumps_max
			)
	
	@use_memo([trigger_calculation]) do
		# if trigger_calculation > 0
			global sol = simulate(rp, showprogress = false)
		# end
	end
end

# ╔═╡ 846659d3-e922-4aed-90ff-0cbab92b1639
let
	@info "Defining main plot + small window."
	
try
	plot_type = plot_params[1]
	
	set_theme!(GEO_THEME())
	global fig = Figure(
		size = 2.0 .* (800, 400), 
		fontsize = 20, 
		figure_padding = (10, 70, 10, 20))
	ax = Axis(fig[1, 1], limits = (-100, -40, 0, 40), title = "")
	if plot_type == "Trajectories"
		viz!(ax, sol)
	elseif plot_type == "Heat Map"
		viz!(ax, sol, SARGASSUM_DISTRIBUTION_PRECOMPUTED[(2018, 4)], 1, log_scale = true)
	end
	land!(ax)
	
	@htl """<div style="
	position: fixed; 
	left: 1rem; 
	top: 6rem; 
	padding: 1px;
	text-align: left;
	z-index: 100;
	max-width: 27%;
	background-color: var(--main-bg-color);">
	$(fig)
	</div>"""
catch
	global fig = nothing
	
	bad_fig = ad(md"""The integration parameters have changed.""", "warning")

	@htl """<div style="
	position: fixed; 
	left: 1rem; 
	top: 6rem; 
	padding: 1px;
	text-align: left;
	z-index: 100;
	max-width: 27%;
	background-color: var(--main-bg-color);">
	$(bad_fig)
	</div>"""
end # try
end # let

# ╔═╡ 76d7cff9-02ad-4841-8c50-dd3e50dcf1a4
let

@info "Defining inspect plot trigger window."
	
	if fig !== nothing
		
		@htl """<div style="
		position: fixed; 
		left: 12rem; 
		top: 1rem; 
		padding: 1px;
		text-align: left;
		z-index: 100;
		max-width: 20%;
		max-height: 10%;
		background-color: var(--main-bg-color);">
		$(plot_box)
		</div>"""
	end
end

# ╔═╡ b4a1e899-a142-4513-aa1b-3f65bcdd0b74
let

@info "Defining inspected plot."
	
	if inspect_plot
	
		@htl """<div style="
		position: fixed; 
		left: 1rem; 
		top: 6rem; 
		padding: 1px;
		text-align: left;
		z-index: 101;
		max-width: 75%;
		background-color: var(--main-bg-color);">
		$(fig)
		</div>"""
	end
end

# ╔═╡ 5fa34147-a71a-43bb-8f5f-689d830508b3
let
	@info "Exporting"

	@use_memo([export_button]) do
		if export_button > 0
			outfile = save_file()
	
			if export_type == ".mat"
				rtr2mat(sol, outfile * ".mat")
				export_parameters && Sargassum._rp2mat!(rp, outfile * ".mat")
			elseif export_type == ".nc"
				lon_bins = range(-100.0, -40.0, length = 134)
				lat_bins = range(0.0, 40.0, length = 64)
				rtr2nc(sol, outfile * ".nc", lon_bins, lat_bins)
				export_parameters && Sargassum._rp2mat(rp, outfile * ".mat", force = true)
			elseif export_type == ".png"
				save(outfile * ".png", fig)
				export_parameters && Sargassum._rp2mat(rp, outfile * ".mat", force = true)
			end
		end
	end
end

# ╔═╡ d31c10fc-1d99-4d49-9a28-111b993d0936
let
	@info "Defining AFAI parameter window."

	sat(Child) = Child(CheckBox(default = false))
	afyrmn(Child) = Child(Select(VALID_AFAI_YEAR_MONTHS, default = (2018, 4)))
	wk(Child) = Child(Select([1, 2, 3, 4], default = 1))
	clouds(Child) = Child(Select(["Show", "Hide"], default = "Hide"))
	scl(Child) = Child(Select(["Log", "Linear"], default = "Log"))

	ui_afai_plot(Child) = md"""
	Show satellite data: $(sat(Child)) 
	
	|         |                |               |               |
	|:-------:|:--------------:|:-------------:|:-------------:|
	| Date    |$(afyrmn(Child))| Week          | $(wk(Child))  |
	| Clouds  |$(clouds(Child))| Scale         | $(scl(Child)) |
	"""
	afai_params = @bind afai_plot_params PlutoUI.combine() do Child
		ad(ui_afai_plot(Child), "info")
	end

	@htl """<div style="
	position: fixed; 
	left: 1rem; 
	bottom: 3rem; 
	padding: 1px;
	text-align: left;
	z-index: 98;
	max-width: 28%;
	max-height: 20%;
	background-color: var(--main-bg-color);">
	$(afai_params)
	</div>"""
end

# ╔═╡ 4ff1d478-90de-42ad-af3c-7085cec44e41
let
@info "Defining AFAI plot window."	
	
if afai_plot_params[1]
	set_theme!(GEO_THEME())
	global fig_afai = Figure(
			size = 2.0 .* (800, 400), 
			fontsize = 20, 
			figure_padding = (10, 70, 10, 20))
	ax = Axis(fig_afai[1, 1], limits = (-100, -40, 0, 40), title = "")
	date, week, clouds, scale = afai_plot_params[2:5]
	viz!(ax, SARGASSUM_DISTRIBUTION_PRECOMPUTED[date], week, log_scale = scale == "Log")
	clouds == "Show" ? clouds!(ax, SARGASSUM_DISTRIBUTION_PRECOMPUTED[date], week) : nothing
	land!(ax)

	@htl """<div style="
	position: fixed; 
	left: 1rem; 
	bottom: 13rem; 
	padding: 1px;
	text-align: center;
	z-index: 99;
	max-width: 27%;
	background-color: var(--main-bg-color);">
	$(fig_afai)
	</div>"""
end
end

# ╔═╡ f862d2fc-e230-457b-969a-77c599380605
function get_limits(itp)
	x = itp.x
	lon, lat = xy2sph(x.dims[:x], x.dims[:y]) .|> extrema
	lon = lon .|> x -> round(x, sigdigits = 4)
	lat = lat .|> x -> round(x, sigdigits = 4)

	tmin, tmax = extrema(x.dims[:t]) .|> time2datetime .|> x -> "$(monthname(x)), $(day(x)), $(year(x))"

	return (lon[1], lon[2], lat[1], lat[2], tmin, tmax)
end

# ╔═╡ cbade461-3782-428c-9f3f-218646adfb4b
function clean_matdict(dict)
	labels = collect(keys(dict))
	d = Dict{String, Any}()

	for l in labels
		if ndims(dict[l]) == 2 && size(dict[l], 2) == 1
			d[l] = vec(dict[l])
		else
			d[l] = dict[l]
		end
	end

	return d
end

# ╔═╡ 621934b4-6454-470d-a72b-a522fa723d50
function matinfo(path, dict)
	labels = sort(collect(keys(dict)))
	sizes = [size(dict[v]) for v in labels]

	p = sortperm(length.(sizes))
	labels = labels[p]
	sizes = sizes[p]

	println(path)
	println("--------")
    for i = 1:length(labels)
		println("$(labels[i]): $(sizes[i])")
	end
end

# ╔═╡ 7430330c-7bc1-4404-997b-9f2ea1967a41
### SELECT FILE TO LOAD
if itp_make_raw_file_type == ".mat"
	@info "A .mat file picker dialog has been opened (possibly behind this interface)."
	itp_make_raw_file = pick_file(filterlist = "mat")
	matdict = clean_matdict(matread(itp_make_raw_file))
	matinfo(itp_make_raw_file, matdict)
	nothing
elseif itp_make_raw_file_type == ".nc"
	@info "A .nc file picker dialog has been opened (possibly behind this interface)."
	itp_make_raw_file = pick_file(filterlist = "nc")
	ncinfo(itp_make_raw_file)
	nothing
else
	itp_make_raw_file = ""
	nothing
end

# ╔═╡ 13064d2c-b96a-4c93-bcd9-35264ab55cc5
### DATA ENTRY
let
if itp_make_raw_file_type in [".nc", ".mat"] && itp_make_raw_file !== ""

### LON LAT	
lonname(Child) = Child(TextField(default = "lon"))
latname(Child) = Child(TextField(default = "lat"))
ulnname(Child) = Child(Select([u"°" => "(-180°, 180°)", u"alon" => "(0°, 360°)", u"km" => "Kilometers", u"m" => "Meters", u"mi" => "Miles", u"naumi" => "Nautical Miles"], default = "(-180°, 180°)"))
ultname(Child) = Child(Select([u"°" => "(-90°, 90°)", u"alat" => "(0°, 180°)", u"km" => "Kilometers", u"m" => "Meters", u"mi" => "Miles", u"naumi" => "Nautical Miles"], default = "(-90°, 90°)"))
lonref(Child) = Child(TextField(default = ""))
latref(Child) = Child(TextField(default = ""))
	
blurb_lon_lat(Child) = md"""
|                   | Longitude         | Latitude          |
|:-----------------:|:-----------------:|:-----------------:|
|Name               |$(lonname(Child))  |$(latname(Child))  |
|Units              |$(ulnname(Child))  |$(ultname(Child))  |
|Reference          |$(lonref(Child))   |$(latref(Child))   |
"""

help_lonlat = md"""
- `Name`: The name of the lon/lat variables in your file.
- `Units`: The units of the lon/lat variables in your file. 
- `Reference`: If you selected non-degree units, you must provide the reference longitude and latitude so that they may be converted to spherical coordinates. Enter in the actual values, not their names.
"""
	
### TIME
tname(Child) = Child(TextField(10, default = "time"))
tstart1(Child) = Child(DatePicker())	
tstart2(Child) = Child(TimePicker(default = Dates.Time(0,0,0), show_seconds = true))	
tper(Child) = Child(Select([u"d" => "Day", "rdd" => "Rata Die Days", u"h" => "Hour", u"minute" => "Minute", u"s" => "Second", u"ms" => "Millisecond"], default = "Day"))
	
blurb_time(Child) = md"""
| Name              | Start             | Period            |
|:-----------------:|:-----------------:|:-----------------:|
|$(tname(Child))    |$(tstart1(Child)) $(tstart2(Child))  |$(tper(Child))  |
"""

help_time = md"""
- `Name`: The name of the time variable in your file.
- `Start`: The value of the time variable will be of the form `X since Y`, e.g. `seconds since January 1, 1970`. This quantity is `Y`. The time can be typed manually or entered with the calendar interface.
- `Period`: This quantity is `X` as defined above.
- Tip: You do not need to set the `Start` for `Rata Die Days` since it is computed automatically.
"""
	
######### FIELD
### WATER, WIND, STOKES
if itp_make_kind in ["WATER", "WIND", "STOKES"]
	uxname(Child) = Child(TextField(default = "u"))
	uyname(Child) = Child(TextField(default = "v"))
	vu_num(Child) = Child(Select([u"km" => "Kilometers", u"m" => "Meters", u"mi" => "Miles", u"naumi" => "Nautical Miles"], default = "Kilometers"))
	vu_den(Child) = Child(Select([u"d" => "Day", u"hr" => "Hour", u"minute" => "Minute", u"s" => "Second", u"ms" => "Millisecond"], default = "Day"))
		
	vfrem(Child) = Child(Select(["", 1, 2, 3, 4], default = ""))
	vford(Child) = Child(Select([(1, 2, 3) => "(x, y, t)", (2, 1, 3) => "(y, x, t)", (3, 1, 2) => "(t, x, y)", (3, 2, 1) => "(t, y, x)"], default = "(x, y, t)"))
	vfscn(Child) = Child(TextField(default = "scale_factor"))
	vfoff(Child) = Child(TextField(default = "add_offset"))
	vfmis(Child) = Child(TextField(default = "_FillValue, missing_value"))
	
	blurb_field_v(Child) = md"""
	|    			    |    				|
	|:-----------------:|:-----------------:|
	|``\hat{x}`` name  	|$(uxname(Child))  	|
	|``\hat{y}`` name  	|$(uyname(Child))  	|
	|Field units  		|$(vu_num(Child)) per  $(vu_den(Child)) 	|
	|Depth axis   		|$(vfrem(Child))  	|
	|Dim. Order   	    |$(vford(Child))     |
	|Scale factor name  |$(vfscn(Child))     |
	|Offset factor name |$(vfoff(Child))     |
	|Missings name(s)   |$(vfmis(Child))     |
	"""
	
	help_field_v = md"""
	- ``\hat{x}`` name: The name of the ``x`` component of the velocity in your file.
	- ``\hat{y}`` name: The name of the ``y`` component of the velocity in your file.
	- `Field units`: The units of the velocity in your file.
	- `Depth axis`: In the case that you have a four dimensional field, select the axis to be removed (by default, the resulting interpolant will be indexed on the first entry of this axis).
	- `Dim. order`: Enter the dimension order of the velocities.
	- `Scale factor`: Enter the name of the scale factor (if none is found by the given name, it is taken to be ``1``).
	- `Offset factor`: Enter the name of the offset factor (if none is found by the given name, it is taken to be ``0``).
	- `Missings factor`: Enter the name of the attribute(s) that define the value of missing or `NaN` data.
	"""

	ui_itp_maker_v(Child) = md"""
	### Longitude and latitude
	
	$(details("❓ HELP ❓", help_lonlat))
	
	$(blurb_lon_lat(Child))
	
	### Time
	
	$(details("❓ HELP ❓", help_time))
	
	$(blurb_time(Child))
	
	### Field
	
	$(details("❓ HELP ❓", help_field_v))
	
	$(blurb_field_v(Child))
	
	### Generate and export: $(Child(CheckBox(default = false)))
	"""
		
	@bind custom_itp_make PlutoUI.combine() do Child
		ad(ui_itp_maker_v(Child), "info")
	end
	
### TEMPERATURE
elseif itp_make_kind == "TEMPERATURE"
	Tname(Child) = Child(TextField(default = "temp"))
	Tunits(Child) = Child(Select([u"°C" => "°C", u"°F" => "°F"], default = "°C"))
		
	Tfrem(Child) = Child(Select(["", 1, 2, 3, 4], default = ""))
	Tford(Child) = Child(Select([(1, 2, 3) => "(x, y, t)", (2, 1, 3) => "(y, x, t)", (3, 1, 2) => "(t, x, y)", (3, 2, 1) => "(t, y, x)"], default = "(x, y, t)"))
	Tfscn(Child) = Child(TextField(default = "scale_factor"))
	Tfoff(Child) = Child(TextField(default = "add_offset"))
	Tfmis(Child) = Child(TextField(default = "_FillValue, missing_value"))
	
	blurb_field_T(Child) = md"""
	|    			    |    				|
	|:-----------------:|:-----------------:|
	|``T`` name  	    |$(Tname(Child))  	|
	|Field units  		|$(Tunits(Child))    |
	|Depth axis   		|$(Tfrem(Child))  	|
	|Dim. Order   	    |$(Tford(Child))     |
	|Scale factor name  |$(Tfscn(Child))     |
	|Offset factor name |$(Tfoff(Child))     |
	|Missings name(s)   |$(Tfmis(Child))     |
	"""
	
	help_field_T = md"""
	- ``T`` name: The name of the temperature variable in your file.
	- `Field units`: The units of the temperature in your file.
	- `Depth axis`: In the case that you have a four dimensional field, select the axis to be removed (by default, the resulting interpolant will be indexed on the first entry of this axis).
	- `Dim. order`: Enter the dimension order of the velocities.
	- `Scale factor`: Enter the name of the scale factor (if none is found by the given name, it is taken to be ``1``).
	- `Offset factor`: Enter the name of the offset factor (if none is found by the given name, it is taken to be ``0``).
	- `Missings factor`: Enter the name of the attribute(s) that define the value of missing or `NaN` data.
	"""

	ui_itp_maker_T(Child) = md"""
	### Longitude and latitude
	
	$(details("❓ HELP ❓", help_lonlat))
	
	$(blurb_lon_lat(Child))
	
	### Time
	
	$(details("❓ HELP ❓", help_time))
	
	$(blurb_time(Child))
	
	### Velocity field
	
	$(details("❓ HELP ❓", help_field_T))
	
	$(blurb_field_T(Child))
	
	### Generate and export: $(Child(CheckBox(default = false)))
	"""
		
	@bind custom_itp_make PlutoUI.combine() do Child
		ad(ui_itp_maker_T(Child), "info")
	end
	
### NUTRIENTS
elseif itp_make_kind == "NUTRIENTS"
	Nname(Child) = Child(TextField(default = "no3"))
	N_num(Child) = Child(Select([u"mmol" => "mmol", u"mol" => "mol"], default = "mmol"))
	N_den(Child) = Child(Select([u"m^3" => "Cubic meter", u"km^3" => "Cubic kilometer", u"L" => "Liter"], default = "Cubic meter"))
		
	Nfrem(Child) = Child(Select(["", 1, 2, 3, 4], default = ""))
	Nford(Child) = Child(Select([(1, 2, 3) => "(x, y, t)", (2, 1, 3) => "(y, x, t)", (3, 1, 2) => "(t, x, y)", (3, 2, 1) => "(t, y, x)"], default = "(x, y, t)"))
	Nfscn(Child) = Child(TextField(default = "scale_factor"))
	Nfoff(Child) = Child(TextField(default = "add_offset"))
	Nfmis(Child) = Child(TextField(default = "_FillValue, missing_value"))
	
	blurb_field_N(Child) = md"""
	|    			    |    				|
	|:-----------------:|:-----------------:|
	|``N`` name  	    |$(Nname(Child))  	|
	|Field units  		|$(N_num(Child)) per  $(N_den(Child)) 	|
	|Depth axis   		|$(Nfrem(Child))  	|
	|Dim. Order   	    |$(Nford(Child))     |
	|Scale factor name  |$(Nfscn(Child))     |
	|Offset factor name |$(Nfoff(Child))     |
	|Missings name(s)   |$(Nfmis(Child))     |
	"""
	
	help_field_N = md"""
	- ``N`` name: The name of the nitrogen concentration variable in your file.
	- `Field units`: The units of the nitrogen concentration in your file.
	- `Depth axis`: In the case that you have a four dimensional field, select the axis to be removed (by default, the resulting interpolant will be indexed on the first entry of this axis).
	- `Dim. order`: Enter the dimension order of the velocities.
	- `Scale factor`: Enter the name of the scale factor (if none is found by the given name, it is taken to be ``1``).
	- `Offset factor`: Enter the name of the offset factor (if none is found by the given name, it is taken to be ``0``).
	- `Missings factor`: Enter the name of the attribute(s) that define the value of missing or `NaN` data.
	"""

	ui_itp_maker_N(Child) = md"""
	### Longitude and latitude
	
	$(details("❓ HELP ❓", help_lonlat))
	
	$(blurb_lon_lat(Child))
	
	### Time
	
	$(details("❓ HELP ❓", help_time))
	
	$(blurb_time(Child))
	
	### Velocity field
	
	$(details("❓ HELP ❓", help_field_N))
	
	$(blurb_field_N(Child))
	
	### Generate and export: $(Child(CheckBox(default = false)))
	"""
		
	@bind custom_itp_make PlutoUI.combine() do Child
		ad(ui_itp_maker_N(Child), "info")
	end
end # if for itp type
end # if for evaluating this cell
end # let

# ╔═╡ c52db42a-97ab-4364-ac58-704baa7aac36
### FILE GENERATE AND EXPORT
let
if itp_make_raw_file_type in [".nc", ".mat"] && itp_make_raw_file !== "" && custom_itp_make[end]
	@info "Generating interpolant. This may take several seconds."

	infile = itp_make_raw_file
	lon_name, lat_name, lon_units, lat_units, lon0, lat0 = custom_itp_make[1:6]
	time_name, t_start_day, t_start_time, t_period = custom_itp_make[7:10]
	
	if itp_make_kind in ["WATER", "WIND", "STOKES"]
		u_name, v_name, vel_num, vel_den = custom_itp_make[11:14]
		remove_axes, permutation, scale_factor_name, add_offset_name, missings_name = custom_itp_make[15:19]
	elseif itp_make_kind == "TEMPERATURE"
		T_name, T_units = custom_itp_make[11:12]
		remove_axes, permutation, scale_factor_name, add_offset_name, missings_name = custom_itp_make[13:17]
	elseif itp_make_kind == "NUTRIENTS"
		N_name, N_units_num, N_units_den = custom_itp_make[11:13]
		remove_axes, permutation, scale_factor_name, add_offset_name, missings_name = custom_itp_make[14:18]
	end

	####################
	gf = GriddedField(3)

	### LAT/LON
	try
		if !(lon_units in [u"°", u"alon"]) # have to transform to eqr
			try 
				lon0 = parse(Float64, lon0)
				lat0 = parse(Float64, lat0)
			catch e
				@info "Could not parse reference lon/lat as numbers. $(e)"
			end
				
			eqr = EquirectangularReference(lon0 = lon0, lat0 = lat0, 
				units = lon_units)
			add_spatial_dimension!(gf, infile, lon_name, :lon, u"°", "degrees", 
				transform = x -> xy2sph(x, 0.0, eqr = eqr)[1], force = true)
		else
			add_spatial_dimension!(gf, infile, lon_name, :lon, lon_units, "degrees", force = true)
		end
	
		if !(lat_units in [u"°", u"alat"]) # have to transform to eqr
			try 
				lon0 = parse(Float64, lon0)
				lat0 = parse(Float64, lat0)
			catch e
				@info "Could not parse reference lon/lat as numbers. $(e)"
			end
			
			eqr = EquirectangularReference(lon0 = lon0, lat0 = lat0, 
				units = lat_units)
			add_spatial_dimension!(gf, infile, lat_name, :lat, u"°", "degrees", 
				transform = y -> xy2sph(0.0, y, eqr = eqr)[2], force = true)
		else
			add_spatial_dimension!(gf, infile, lat_name, :lat, lon_units, "degrees", force = true)
		end

	catch e
		@info "Could not add latitude/longitude variables. $(e)"
	end

	### TIME
	try
		if t_period == "rdd" # Rata Die Days
			add_temporal_dimension!(gf, infile, time_name, :t, DateTime(0000, 12, 31), u"d", force = true)
		else
			t_start = DateTime(t_start_day + t_start_time)
			add_temporal_dimension!(gf, infile, time_name, :t, t_start, t_period, force = true)
		end
	catch e
		@info "Could not add time variable. $(e)"
	end

	### FIELD
	if itp_make_kind in ["WATER", "WIND", "STOKES"]
		try
			take_axes = remove_axes === "" ? [:,:,:] : [i == remove_axes ? 1 : Colon() for i = 1:4]
			vel_units = vel_num/vel_den
			missings_name_parsed = String.(split(missings_name, ","))
			add_field!(gf, infile, u_name, :u, vel_units, "speed",
				take_axes = take_axes, permutation = permutation, scale_factor_name = scale_factor_name, add_offset_name = add_offset_name, missings_name = missings_name_parsed)
			add_field!(gf, infile, v_name, :v, vel_units, "speed",
				take_axes = take_axes, permutation = permutation, scale_factor_name = scale_factor_name, add_offset_name = add_offset_name, missings_name = missings_name_parsed)
		catch e
			@info "Could not add velocity variables. $(e)"
		end
	elseif itp_make_kind == "TEMPERATURE"
		try
			take_axes = remove_axes === "" ? [:,:,:] : [i == remove_axes ? 1 : Colon() for i = 1:4]
			missings_name_parsed = String.(split(missings_name, ","))
			add_field!(gf, infile, T_name, :temp, T_units, "temperature",
				take_axes = take_axes, permutation = permutation, scale_factor_name = scale_factor_name, add_offset_name = add_offset_name, missings_name = missings_name_parsed)
		catch e
			@info "Could not add temperature variable. $(e)"
		end
	elseif itp_make_kind == "NUTRIENTS"
		try
			take_axes = remove_axes === "" ? [:,:,:] : [i == remove_axes ? 1 : Colon() for i = 1:4]
			N_units = N_units_num/N_units_den
			missings_name_parsed = String.(split(missings_name, ","))
			add_field!(gf, infile, N_name, :no3, N_units, "concentration",
				take_axes = take_axes, permutation = permutation, scale_factor_name = scale_factor_name, add_offset_name = add_offset_name, missings_name = missings_name_parsed)
		catch e
			@info "Could not add nutrients variable. $(e)"
		end
	end

	####################
	
	ranges_increasing!(gf)
	sph2xy!(gf)
	
	itp_make = InterpolatedField(gf)

	if itp_make_kind in ["WATER", "WIND", "STOKES"]
		add_derivatives!(itp_make)
	end

	@info "Interpolant generated. A save file dialog has been opened (possibly behind this interface)."

	sleep(0.5)
	
	itp_make_export_path = save_file()
	outfile = itp_make_export_path * ".jld2"

	try
		if itp_make_kind == "WATER"
			jldsave(outfile, WATER_ITP = itp_make)
		elseif itp_make_kind == "WIND"
			jldsave(outfile, WIND_ITP = itp_make)
		elseif itp_make_kind == "STOKES"
			jldsave(outfile, STOKES_ITP = itp_make)
		elseif itp_make_kind == "TEMPERATURE"
			jldsave(outfile, TEMPERATURE_ITP = itp_make)
		elseif itp_make_kind == "NUTRIENTS"
			jldsave(outfile, NUTRIENTS_ITP = itp_make)
		end

		@info "Custom interpolant created at $(outfile)"
		@info "Reset the interpolant file type to clear or start over."
	catch
		@info "Custom interpolant could not be exported."
	end
	
end # if
end # let

# ╔═╡ 8c13852d-d92e-44d2-9e4e-c038c65c2c34
let
	@info "Defining dummy InterpolatedField"
	
	gf = GriddedField(3)
	
	append!(gf.dims_names, [(:x, u"m"), (:y, u"m"), (:t, u"d")])
	gf.dims[:x] = range(0, 1, length = 5)
	gf.dims[:y] = range(0, 1, length = 5)
	gf.dims[:t] = range(0, 1, length = 5)

	append!(gf.fields_names, [(:u, u"m/s")])
	gf.fields[:u] = zeros(5, 5, 5)

	gf

	global DUMMY_ITP = InterpolatedField(gf)
	nothing
end

# ╔═╡ 45d67f51-53d1-4d07-8022-168a44408705
PlutoHooks.@use_memo([water_load]) do
	if water_load
		WATER_PATH = pick_file(filterlist = "jld2")
	
		try
			WATER_ITP.x = load(WATER_PATH, "WATER_ITP")
			@info "Custom water interpolant loaded!"
		catch e
			@info "Water itp could not be loaded. The .jld2 file must contain an `InterpolatedField` variable called `WATER_ITP`."
			WATER_ITP.x = DUMMY_ITP
			nothing
		end
	else
		WATER_PATH = joinpath(Sargassum._ITPS_SCRATCH.x, "WATER_ITP.jld2")
		WATER_ITP.x = load(WATER_PATH, "WATER_ITP")
		nothing
	end

	nothing
end

# ╔═╡ 0afdbfc4-3feb-4e65-a3f2-b6c200aad068
PlutoHooks.@use_memo([wind_load]) do
	if wind_load
		WIND_PATH = pick_file(filterlist = "jld2")
	
		try
			WIND_ITP.x = load(WIND_PATH, "WIND_ITP")
			@info "Custom wind interpolant loaded!"
		catch
			@info "Wind itp could not be loaded. The .jld2 file must contain an `InterpolatedField` variable called `WIND_ITP`."
			WIND_ITP.x = DUMMY_ITP
			nothing
		end
	else
		WIND_PATH = joinpath(Sargassum._ITPS_SCRATCH.x, "WIND_ITP.jld2")
		WIND_ITP.x = load(WIND_PATH, "WIND_ITP")
		nothing
	end

end

# ╔═╡ 7ba608cd-5217-4eb1-a4d8-f0279934ad5c
PlutoHooks.@use_memo([stokes_load]) do
	if stokes_load
		STOKES_PATH = pick_file(filterlist = "jld2")
	
		try
			STOKES_ITP.x = load(STOKES_PATH, "STOKES_ITP")
			@info "Custom Stokes interpolant loaded!"
		catch
			@info "Stokes itp could not be loaded. The .jld2 file must contain an `InterpolatedField` variable called `STOKES_ITP`."
			STOKES_ITP.x = DUMMY_ITP
			nothing
		end
	else
		STOKES_PATH = joinpath(Sargassum._ITPS_SCRATCH.x, "STOKES_ITP.jld2")
		STOKES_ITP.x = load(STOKES_PATH, "STOKES_ITP")
		nothing
	end

end

# ╔═╡ be256376-85f8-4117-950c-71fa134af743
PlutoHooks.@use_memo([temp_load]) do
	if temp_load
		TEMPERATURE_PATH = pick_file(filterlist = "jld2")
	
		try
			TEMPERATURE_ITP.x = load(TEMPERATURE_PATH, "TEMPERATURE_ITP")
			global temp_custom = true
			@info "Custom temperature interpolant loaded!"
		catch
			@info "Temperature itp could not be loaded. The .jld2 file must contain an `InterpolatedField` variable called `TEMPERATURE_ITP`."
			TEMPERATURE_ITP.x = DUMMY_ITP
			nothing
		end
	else
		TEMPERATURE_PATH = joinpath(Sargassum._ITPS_SCRATCH.x, "TEMPERATURE_ITP.jld2")
		TEMPERATURE_ITP.x = load(TEMPERATURE_PATH, "TEMPERATURE_ITP")
		nothing
	end
end

# ╔═╡ 61d348c2-83e7-42c6-9e52-499544bbd7e7
PlutoHooks.@use_memo([nutr_load]) do
	if nutr_load
		NUTRIENTS_PATH = pick_file(filterlist = "jld2")
	
		try
			NUTRIENTS_ITP.x = load(NUTRIENTS_PATH, "NUTRIENTS_ITP")
			@info "Custom nutrients interpolant loaded!"
		catch
			@info "Nutrients itp could not be loaded. The .jld2 file must contain an `InterpolatedField` variable called `NUTRIENTS_ITP`."
			NUTRIENTS_ITP.x = DUMMY_ITP
			nothing
		end
	else
		NUTRIENTS_PATH = joinpath(Sargassum._ITPS_SCRATCH.x, "NUTRIENTS_ITP.jld2")
		NUTRIENTS_ITP.x = load(NUTRIENTS_PATH, "NUTRIENTS_ITP")
		nothing
	end

end

# ╔═╡ 0c7b91e9-3b9b-4f71-a472-fa88df92d4b0
function get_limits_blurb(itp, custom::Bool, title::String)
	if itp.x === DUMMY_ITP
		missing = HTML("""<span style="color:pink"><b>missing</b></span>""")
		
		return md"""
		### $(title)
		
		Interpolant is **$(missing)**.
		
		|             |            |             |           |       |         |
		|-------------|------------|-------------|-----------|-------|---------|
		| Lon min (°) | -          | Lat min (°) | -         | T min | -       | 
		| Lon max (°) | -          | Lat max (°) | -         | T max | -       |
		"""
	end
	
	lonmin, lonmax, latmin, latmax, tmin, tmax = get_limits(itp)

	kind = !custom ? HTML("""<span style="color:yellow"><b>default</b></span>""") : HTML("""<span style="color:red"><b>custom</b></span>""")
	
	return md"""
	### $(title)
	
	Using **$(kind)** interpolant with limits:
	
	|             |            |             |           |       |         |
	|-------------|------------|-------------|-----------|-------|---------|
	| Lon min (°) | $(lonmin)  | Lat min (°) | $(latmin) | T min | $(tmin) | 
	| Lon max (°) | $(lonmax)  | Lat max (°) | $(latmax) | T max | $(tmax) |
	"""
end

# ╔═╡ d85448cb-6093-48d9-9254-cce4e842d809
let
if check_limits
	water_blurb = get_limits_blurb(WATER_ITP, water_load, "Water velocity")
	wind_blurb = get_limits_blurb(WIND_ITP, wind_load, "Wind velocity")
	stokes_blurb = get_limits_blurb(STOKES_ITP, stokes_load, "Stokes drift")

	temp_blurb = get_limits_blurb(TEMPERATURE_ITP, temp_load, "Temperature")

	nutr_blurb = get_limits_blurb(NUTRIENTS_ITP, nutr_load, "Nutrients")

	### FINAL

	final_blurb = md"""
	$(water_blurb)

	$(wind_blurb)

	$(stokes_blurb)

	$(temp_blurb)

	$(nutr_blurb)
	"""

	ad(final_blurb, "tip")
end
end

# ╔═╡ Cell order:
# ╟─7573642c-d0c4-4f44-bd21-c0c7cd0abf2a
# ╟─b503b1ff-18b5-46b9-9809-88b54240a762
# ╟─c3eddd51-43c4-42f4-800a-ae9945df1e86
# ╟─7f2022c7-a510-46a5-9090-84f58693815c
# ╟─d85448cb-6093-48d9-9254-cce4e842d809
# ╟─6e7da02d-a6ac-4065-9b8a-370033450646
# ╟─c6cf756a-1c17-44bc-8655-b2d674888971
# ╟─45d67f51-53d1-4d07-8022-168a44408705
# ╟─0afdbfc4-3feb-4e65-a3f2-b6c200aad068
# ╟─7ba608cd-5217-4eb1-a4d8-f0279934ad5c
# ╟─be256376-85f8-4117-950c-71fa134af743
# ╟─61d348c2-83e7-42c6-9e52-499544bbd7e7
# ╟─cb2ae3f7-ee48-43e3-8a98-e89977440305
# ╟─7430330c-7bc1-4404-997b-9f2ea1967a41
# ╟─13064d2c-b96a-4c93-bcd9-35264ab55cc5
# ╟─c52db42a-97ab-4364-ac58-704baa7aac36
# ╟─52e78695-a940-4a62-820b-71724a947c43
# ╟─8f0df9e4-3cc9-4265-9727-14bd7cf4497f
# ╟─62907762-cad8-483f-9dd1-5907c43b49ab
# ╟─ed4f082b-237c-4b08-b3b9-2f1846b0ecfb
# ╟─76d60013-1856-4970-b2bd-cebea929fbd6
# ╟─c75d9b70-d3bb-41fe-84bf-53c0ab41f406
# ╟─ebc20b02-83d5-4b94-ae76-16a1bd619312
# ╟─a644a9ff-9cf2-4121-a764-ea2e3cbb76d9
# ╟─81769b34-5373-43fe-88ef-82bb3a714ff6
# ╟─75898dc7-beec-4c4d-8580-79ec1df8cc42
# ╟─d2dd84eb-e2cc-4c32-9966-7803549a993d
# ╟─3770ede8-77e4-47e3-bb70-6fd4d486d0b7
# ╟─6bda3ba9-fbba-4ce5-8a23-0c606845b31a
# ╟─72107d04-8ce2-4636-921b-d52d8431be46
# ╟─e0d8925d-cc12-4a72-a383-93f07cb3d495
# ╟─c60bb5f5-82b7-484c-b56b-ded74a1e651f
# ╟─e1fd0825-6b16-4fb6-9358-4252b1bd77e9
# ╟─3b123c70-d3b9-4b3d-8c38-f4d3457f079d
# ╟─9b647b4f-233f-4795-8760-7472eeea422d
# ╟─5bdbce07-0f50-459f-8ea6-6bb670aea47d
# ╟─61ebe90a-60e9-4e77-9a24-a793e4701209
# ╟─dd199ecb-16cf-4e58-8918-64077b6c192c
# ╟─df24d7ca-2143-481d-80fe-b8f31f0a3bb8
# ╟─e537ca5d-86d6-423b-a3b9-d9ba503c4d31
# ╟─8a5827c1-8655-4808-8fe0-ff46fc25f982
# ╟─99b628f1-c072-4d06-a32c-1d0f8d4789bb
# ╟─66c7f34f-378d-4a37-a112-5032c4cf07a4
# ╟─d512eee1-890c-40ce-ab0e-54d1004ad5d2
# ╟─f6b36bcc-5162-4d84-a1a2-9cb3ff0e8ac1
# ╟─ea2ec22b-69ab-40d6-b8ea-704e4e6c3de8
# ╟─10a16ae5-044a-47e2-8964-13b334f5d0a8
# ╟─1b874c8c-08dd-4064-9afc-d62b2e900921
# ╟─8638b7a5-1ee0-47d2-aa6b-54cc9ab996ff
# ╟─65c5d259-943f-432a-8e02-ba77c8650723
# ╟─084700f3-4f35-466f-91e1-f4853c426abf
# ╟─589f251d-a2df-4879-9933-4deb95a8003a
# ╟─7ca9e647-d06e-4815-b30b-eb1a4e5f1577
# ╟─65b2ceb8-40d4-4f97-9541-36e0023c5d6b
# ╟─2c38594d-7d78-49d8-9597-0b723f56e76f
# ╟─8ba55d2d-53fa-4206-872c-0470e76fcf6b
# ╟─8c14a852-3bd4-4dda-b812-6c1378d676d5
# ╟─943f8d1a-335a-4321-8d2b-b29e5ca5845c
# ╟─4430e3f8-ee7d-46ab-a98a-573db7815670
# ╟─2e4142db-6a64-4c57-a227-8d055f458863
# ╟─c979a8ff-c400-419e-9199-886d17bdda6a
# ╟─cac6046f-0d45-4f1a-b062-b8cc53044807
# ╟─7f4daf85-2b36-4450-bf48-a4d77b4d4af3
# ╟─8e250f3e-e5b9-4c76-9eac-39a4a60ded57
# ╟─dc6651a1-4c47-4cd7-a831-f37812e8a8e6
# ╟─7aea397d-a1b3-4e2d-a265-3b528762415c
# ╟─4568d0b9-e6a2-4653-abc5-44e229cc3ded
# ╟─fb9970b9-25a9-4235-a01c-5f4b6b2b2580
# ╟─d355db80-b403-4200-a4b4-a6eb6f13a79e
# ╟─7d0b8d87-d783-467b-8240-deaa2e88963d
# ╟─e25ab537-8be8-46e1-9b8c-e9c1f8a4dc30
# ╟─846659d3-e922-4aed-90ff-0cbab92b1639
# ╟─78a2638f-f10e-443f-835e-0c8454981617
# ╟─76d7cff9-02ad-4841-8c50-dd3e50dcf1a4
# ╟─32f6f7a5-19b7-4c71-9d0a-865d4f6d0506
# ╟─a9741ea1-32b7-477a-be23-a3f74fe8c359
# ╟─b4a1e899-a142-4513-aa1b-3f65bcdd0b74
# ╟─58d3a9da-c4df-4ec3-953e-1946495945bc
# ╟─e75adad7-7416-4962-9308-44e1425a8ff3
# ╟─a7de95ce-62b9-40e6-a7f5-1d833bedff87
# ╟─c29585d8-885c-4b5a-b530-9d34ec8daeb2
# ╟─d31c10fc-1d99-4d49-9a28-111b993d0936
# ╟─4ff1d478-90de-42ad-af3c-7085cec44e41
# ╟─154d4bd2-85c9-41dd-a68e-1f9028c55500
# ╟─5fa34147-a71a-43bb-8f5f-689d830508b3
# ╟─e90936ec-f215-4a03-bd75-da2df6308ed0
# ╟─67c5ed03-7e1b-4c4d-8fa1-837848a37924
# ╟─59ae76ce-1655-4173-a368-125805c75497
# ╟─f862d2fc-e230-457b-969a-77c599380605
# ╟─0c7b91e9-3b9b-4f71-a472-fa88df92d4b0
# ╟─7fd8cc7c-a2e0-4cae-8448-e6a16d1b0b9c
# ╟─cbade461-3782-428c-9f3f-218646adfb4b
# ╟─621934b4-6454-470d-a72b-a522fa723d50
# ╟─8c13852d-d92e-44d2-9e4e-c038c65c2c34
