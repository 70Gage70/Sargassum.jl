eureka =[
    256 256 255;
    153 204 255;
    255 255 102;
    204 102   0;
    102   0   0]/256


"""
    const EUREKA

A `ColorSchemes.ColorScheme` ranging from white, to blue, to yellow, to orange, to rust.
"""
const EUREKA = [RGB{Float64}(eureka[i,:]...) for i = 1:size(eureka, 1)] |> ColorScheme