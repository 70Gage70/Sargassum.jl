function viz(
    itp::InterpolatedField, 
    field::Symbol;
    limits::Union{NTuple{4, Real}, Nothing} = nothing,
    time::Union{Nothing, Real} = nothing,
    show_land::Bool = true,
    n_points::Integer = 100)

    lims = boundary(itp)
    if !isnothing(limits)
        lims[1:4] .= limits
    end

    xs = range(start = lims[1], stop = lims[2], length = n_points)
    ys = range(start = lims[3], stop = lims[4], length = n_points)

    if length(lims) == 4 # 2D Field
        zs = [itp.fields[field](sph2xy(x, y)...) for x in xs, y in ys]
    elseif length(lims) == 6 # 3D Field
        t = isnothing(time) ? datetime2time(DateTime(lims[5])) : time
        zs = [itp.fields[field](sph2xy(x, y)..., t) for x in xs, y in ys]
    else
        error("Field has too many dimensions.")
    end

    set_theme!(GEO_THEME())
    fig = Figure()
    ax = Axis(fig[1, 1], limits = lims[1:4])

    hm = heatmap!(ax, xs, ys, zs, colormap = EUREKA)    
    show_land && land!(ax)

    idx = findfirst(x -> x[1] == field, itp.fields_names)
    Colorbar(fig[1, 2], hm, label = "$(itp.fields_names[idx])")

    return fig
end

function viz(
    itp::Ref{InterpolatedField}, 
    field::Symbol;
    time::Union{Nothing, Real} = nothing,
    show_land::Bool = true,
    n_points::Integer = 100)

    return viz(itp.x, field; time = time, show_land = show_land, n_points = n_points)
end


function viz!(
    ax::Axis,
    itp::InterpolatedField, 
    field::Symbol;
    time::Union{Nothing, Real} = nothing,
    n_points::Integer = 100)

    lims = boundary(itp)
    
    xs = range(start = lims[1], stop = lims[2], length = n_points)
    ys = range(start = lims[3], stop = lims[4], length = n_points)

    if length(boundary(itp)) == 4 # 2D Field
        zs = [itp.fields[field](sph2xy(x, y)...) for x in xs, y in ys]
    elseif length(boundary(itp)) == 6 # 3D Field
        t = isnothing(time) ? datetime2time(DateTime(lims[5])) : time
        zs = [itp.fields[field](sph2xy(x, y)..., t) for x in xs, y in ys]
    else
        error("Field has too many dimensions.")
    end

    return heatmap!(ax, xs, ys, zs, colormap = EUREKA)    
end

function viz!(
    ax::Axis,
    itp::Ref{InterpolatedField}, 
    field::Symbol;
    time::Union{Nothing, Real} = nothing,
    n_points::Integer = 100)

    return viz!(ax, itp.x, field; time = time, n_points = n_points)
end