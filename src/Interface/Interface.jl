export interface

"""
    interface(; reset = false, args...)

Start the interface. 

### Optional Arguments

- `reset`: If true, the interface will be "factory reset" to its default state. This should only be required if the \
interface code itself has been modified. That is, changing parameters using sliders etc. does not require a reset.
- `args`: Passed directly to `Pluto.run()`. 
"""
function interface(; reset::Bool = false, args...)
    nb_orig = joinpath(@__DIR__, "interface-original.jl")
    nb_edit = joinpath(_INTERFACE_SCRATCH.x, "interface-edit.jl")

    if reset
        rm(nb_edit, force = true)
        Pluto.readwrite(nb_orig, nb_edit)
    end

    defaults = (
        notebook = nb_edit,
    )

    Pluto.run(; merge(defaults, args)...)
    return nothing 
end
