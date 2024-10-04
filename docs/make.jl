using Documenter, DocumenterVitepress
using Sargassum
using CairoMakie

### VITEPRESS
# makedocs(
#     sitename = "Sargassum.jl",
#     format = MarkdownVitepress(
#         md_output_path = ".", # LOCAL ONLY
#         build_vitepress = false, # LOCAL ONLY
#         repo = "github.com/70Gage70/Sargassum.jl.git",
#     ),
#     modules = [Sargassum],
#     clean = false, # LOCAL ONLY
#     warnonly = true
# )

### DOCUMENTER
makedocs(
    sitename = "Sargassum.jl",
    format = Documenter.HTML(),
    modules = [Sargassum, SargassumBOMB, SargassumColors, SargassumFromAFAI, SargassumInterface],
    pages = [
        "Home" => "index.md",
        "Getting Started" => "getting-started.md",
        "Packages" => [
            "SargassumInterface.jl" => [
                "Tutorial" => "s-interface.md",
                "API" => "s-interface-api.md"],
            "SargassumBOMB.jl" => [
                "Tutorial" => "s-bomb.md",
                "API" => "s-bomb-api.md",
                "Examples API" => "s-bomb-examples-api.md"],
            "SargassumFromAFAI.jl" => [
                "Tutorial" => "s-afai.md",
                "API" => "s-afai-api.md"],
            "SargassumColors.jl" => [
                "Tutorial" => "s-colors.md",
                "API" => "s-colors-api.md"],
        ]
    ],
    warnonly = true
)

deploydocs(;
    repo = "github.com/70Gage70/Sargassum.jl.git",
    target = "build", 
    versions = nothing
)

