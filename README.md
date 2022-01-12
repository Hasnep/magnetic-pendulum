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
# To build to markdown
build(false)
# To also run pandoc to convert to HTML
build(true)
```

The output files will be `build` folder.
