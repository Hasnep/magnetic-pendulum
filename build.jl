import Literate

# Setup
images_folder = joinpath(pwd(), "build", "images")
rm(images_folder, force = true, recursive = true)
mkpath(images_folder)

# Read frontmatter
frontmatter = open(joinpath(pwd(), "frontmatter.yml")) do f
    read(f, String)
end

# Build markdown document
Literate.markdown(
    joinpath(pwd(), "src", "magnetic-pendulum.jl"),
    joinpath(pwd(), "build");
    documenter = false,
    execute = true,
    preprocess = s -> replace(s, "# hide\n" => "#hide\n"),
    postprocess = s -> "---\n$frontmatter\n---\n\n$s",
)

# Build to html if --pandoc argument was specified
if "--pandoc" in ARGS
    @info "Building markdown to HTML."
    run(
        Cmd([
            "pandoc",
            "build/magnetic-pendulum.md",
            "--from=markdown",
            "--to=html",
            "--output=build/magnetic-pendulum.html",
            "--standalone",
        ]),
    )
end
