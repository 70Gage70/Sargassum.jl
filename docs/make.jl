using Documenter, DocumenterVitepress
using Sargassum
using CairoMakie

# try
#     itps_load(Sargassum.SargassumBOMB._ITPS_SCRATCH.x)
# catch
#     try 
#         itps_default_construct(download = true)
#     catch
#         nothing
#     end
# end

### VITEPRESS
makedocs(;
    sitename = "Sargassum.jl",
    authors = "Gage Bonner",
    modules = [Sargassum],
    checkdocs=:all,
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/70Gage70/Sargassum.jl",
        # md_output_path = ".", # LOCAL ONLY
        # build_vitepress = false, # LOCAL ONLY
        devbranch = "master", 
        devurl = "dev";
    ),
    draft = false,
    source = "src", 
    build = "build",
    warnonly = true,
    # clean = true, # LOCAL ONLY
)

### DOCUMENTER
# makedocs(
#     sitename = "Sargassum.jl",
#     format = Documenter.HTML(),
#     modules = [Sargassum, SargassumBOMB, SargassumColors, SargassumFromAFAI, SargassumInterface],
#     pages = [
#         "Home" => "index.md",
#         "Getting Started" => "getting-started.md",
#         "Packages" => [
#             "SargassumInterface.jl" => [
#                 "Tutorial" => "s-interface.md",
#                 "API" => "s-interface-api.md"],
#             "SargassumBOMB.jl" => [
#                 "Tutorial" => "s-bomb.md",
#                 "API" => "s-bomb-api.md",
#                 "Examples API" => "s-bomb-examples-api.md"],
#             "SargassumFromAFAI.jl" => [
#                 "Tutorial" => "s-afai.md",
#                 "API" => "s-afai-api.md"],
#             "SargassumColors.jl" => [
#                 "Tutorial" => "s-colors.md",
#                 "API" => "s-colors-api.md"],
#         ]
#     ],
#     warnonly = true
# )

deploydocs(;
    repo = "https://github.com/70Gage70/Sargassum.jl",
    target = "build", 
    # versions = nothing,
    branch = "gh-pages",
    devbranch = "master",
    push_preview = true
)
