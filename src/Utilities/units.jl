const UFUL = Unitful.Unitlike

"""
    const UNITS

A dictionary mapping dimension names to the `Unitful.Unitlike` that measures it.
"""
const UNITS = Dict{String, UFUL}(
    "distance" => u"km",
    "speed" => u"km/d",
    "wave_height" => u"m",
    "temperature" => u"°C",
    "concentration" => u"mmol/m^3",
    "degrees" => u"°",
    "time" => u"d",
    "none" => NoUnits
)