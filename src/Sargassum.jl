module Sargassum

using Reexport

@reexport using SargassumColors
@reexport using SargassumFromAFAI
@reexport using SargassumBOMB
@reexport using SargassumInterface

"""
    interface(; force_retry::Bool = false, args...)

Start the interface from `SargassumInterface`. 

### Optional Arguments

- `force_retry`: If true, notebook will be redownloaded.
- `args`: Passed directly to `Pluto.run()`
"""
interface(; force_retry::Bool = false, args...) = SargassumInterface.run(;force_retry = force_retry, args...)

export interface

end # module Sargassum
