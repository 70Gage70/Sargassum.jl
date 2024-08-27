import Pkg
Pkg.Registry.add("General")
Pkg.Registry.add(Pkg.RegistrySpec(url = "https://github.com/70Gage70/SargassumRegistry"))
Pkg.activate(temp = true)
Pkg.add("Sargassum")
Pkg.update()
