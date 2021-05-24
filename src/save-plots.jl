using Logging: NullLogger, with_logger

function save_gif(p, file_name)
    with_logger(NullLogger()) do
        gif(p, joinpath(pwd(), "build", "images", file_name))
    end
end

save_svg(p, file_name) = savefig(p, joinpath(pwd(), "build", "images", file_name))
