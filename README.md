# Sargassum.jl

[![Documentation Status](https://img.shields.io/badge/docs-stable-blue?style=flat-square)](https://70gage70.github.io/Sargassum.jl/dev/)

`Sargassum.jl` is a package for the [Julia](https://julialang.org/) programming language that bundles all of the following functionality in one convenient location. Together, this represents a fully featured Sargassum analysis toolkit.

- State of the art physics simulation of Sargassum clumps using Maxey-Riley models with nonlinear spring interactions and customizable biological effects.
- Download raw AFAI data and generate Sargassum distribution maps yourself, or use precomputed maps available starting 2017.
- Plot your data quickly; all major objects can be visualized with one line of code!
- An interface that allows the core tools to be used in a zero-code environment with built-in documentation.

`Sargassum.jl` was developed by the [Nonlinear Dynamics Group](https://nonlinear.earth.miami.edu/index.html) at the University of Miami.

# Documentation

[Documentation](https://70gage70.github.io/Sargassum.jl/dev/)

# Acknowledgements and Citation

If `Sargassum.jl` contributes to your research, we would be grateful if you cite our work:

```bibtex
@article{bonnerSargassum24,
    author = {Bonner, Gage and Beron-Vera, F J and Olascoaga, M J},
    title = "{Charting the course of Sargassum: Incorporating nonlinear elastic interactions and life cycles in the Maxey-Riley model}",
    journal = {PNAS Nexus},
    volume = {3},
    number = {10},
    pages = {pgae451},
    year = {2024},
    month = {10},
    issn = {2752-6542},
    doi = {10.1093/pnasnexus/pgae451},
    url = {https://doi.org/10.1093/pnasnexus/pgae451},
    eprint = {https://academic.oup.com/pnasnexus/article-pdf/3/10/pgae451/59961289/pgae451.pdf},
}
```

The `Sargassum.jl` Julia package, authored by Gage Bonner, was developed with the support of the National Science Foundation (NSF) grant OCE2148499 titled 'Collaborative Research: Unraveling Connectivity Constraints and Pathways of Sargassum and the Nature of Their Variability by Building on a Maxey-Riley Framework for Drift Modeling,' awarded to Maria J. Olascoaga (Principal Investigator), along with Francisco J. Beron-Vera and Nathan Putman (co-Principal Investigators).