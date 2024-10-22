"""
    land!(axis; resolution, grid, landcolor, args...)

Add a land heatmap to `axis::Makie.Axis`. This will be placed on top of any graphics that 
are already on the axis. The land is gray by default. Returns `Makie.poly!`.

The land data is provided by `NaturalEarth.jl`.

### Optional Arguments

- `resolution`: The parameter resolution should be either "l", "m" or "h" (standing \
for low, medium and high resolution). This controls which features are \
visible, with smaller landmass "switching on" at higher resolutions. Default `"m"`.
- `landcolor`: The color of the landmass. Default `RGBf(0.5, 0.5, 0.5)`.
- `args...`: All keyword arguments are passed directly to `Makie.heatmap!`.
"""
function land!(
    axis::Axis;
    resolution::String = "m",
    landcolor = RGBf(0.5, 0.5, 0.5),
    args...)

    @argcheck resolution in ["l", "m", "h"]

    if resolution == "l"
        data = naturalearth("land", 110)
    elseif resolution == "m"
        data = naturalearth("land", 50)
    elseif resolution == "h"
        data = naturalearth("land", 10)
    end

    defaults = (color = landcolor,)
    mp = to_multipoly(data.geometry)
    
    return poly!(axis, mp; merge(defaults, args)...)
end