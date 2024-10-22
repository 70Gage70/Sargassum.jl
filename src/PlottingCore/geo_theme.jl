_xformatter(values) = [
    if value > 0 
        L"%$(abs(value)) \, \degree \mathrm{E}" 
    elseif value == 0 
        L"0\degree"
    elseif value < 0
        L"%$(abs(value)) \, \degree \mathrm{W}" 
    end
for value in values]

_yformatter(values) = [
    if value > 0 
        L"%$(abs(value)) \, \degree \mathrm{N}" 
    elseif value == 0 
        L"0\degree"
    elseif value < 0
        L"%$(abs(value)) \, \degree \mathrm{S}" 
    end
for value in values]

"""
    GEO_THEME()

This is a `Makie.Theme` where the `x` and `y` axes are appropriate for degrees N/S and E/W.

Use this theme in your `Makie` plots by including `set_theme!(GEO_THEME())`.
"""
function GEO_THEME()
    t = Theme(
        Axis = (
        xtickformat = _xformatter,
        ytickformat = _yformatter,
        xgridvisible = false, 
        ygridvisible = false
        )
    )

    return merge(t, theme_latexfonts())
end