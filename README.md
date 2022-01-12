# Recreating the Magnetic Pendulum Fractal in Julia

## Building

This blogpost was written with Julia 1.7.0 and optionally requires `pandoc` to build to HTML.
To set up the blogpost, run:

```julia
import Pkg
Pkg.activate(".")
Pkg.instantiate()
include(joinpath(pwd(), "build.jl"))
```

To build the blogpost, run:

```julia
build(run_pandoc = false, create_tarball = false)
```

The raw output files will be in the `build` folder, and an optional tarball file will be created in the project's root.
