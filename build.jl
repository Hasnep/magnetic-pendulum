import Literate

function build(run_pandoc = false)
    # Setup
    build_folder = joinpath(pwd(), "build")
    # rm(build_folder, force = true, recursive = true)
    mkpath(build_folder)

    # Read frontmatter
    frontmatter = open(joinpath(pwd(), "frontmatter.yml")) do f
        read(f, String)
    end

    # Build markdown document
    Literate.markdown(
        joinpath(pwd(), "src", "magnetic-pendulum-fractal.jl"),
        build_folder;
        documenter = false,
        execute = true,
        # Fix auto-formatted hide comments
        preprocess = s -> replace(s, "# hide\n" => "#hide\n"),
        # Insert frontmatter
        postprocess = s -> "---\n$frontmatter\n---\n\n$s",
    )

    # Build to html using pandoc
    if run_pandoc
        @info "Building markdown to HTML."
        run(
            Cmd([
                "pandoc",
                "build/magnetic-pendulum-fractal.md",
                "--from=markdown",
                "--to=html",
                "--standalone",
                "--output=build/magnetic-pendulum-fractal.html",
            ]),
        )
    end
end

if !isinteractive()
    build(false)
end
