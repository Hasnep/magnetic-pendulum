import Literate

# Setup
images_folder = joinpath(pwd(), "build", "images")
rm(images_folder, force = true, recursive = true)
mkpath(images_folder)

# Build markdown document
Literate.markdown(
    joinpath(pwd(), "src", "blogpost.jl"),
    joinpath(pwd(), "build");
    documenter = false,
    execute = true,
    preprocess = s -> replace(s, "# hide\n" => "#hide\n"),
)

# Build to html if --pandoc argument was specified
if "--pandoc" in ARGS
    @info "Building markdown to HTML."
    run(
        Cmd([
            "pandoc",
            "build/blogpost.md",
            "--from=markdown",
            "--to=html",
            "--output=build/blogpost.html",
            "--standalone"
        ]),
    )
end
