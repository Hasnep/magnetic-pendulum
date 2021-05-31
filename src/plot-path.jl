function plot_path(
    pendulums::Vector{<:ODESolution},
    magnets::Vector;
    line_width = 2,
    line_smoothness = 100,
    limit = 2,
    line_alpha = 0.5,
)
    p = plot(xlims = (-limit, limit), ylims = (-limit, limit), legend = false, aspect_ratio = :equal)
    for pendulum in pendulums
        timestamps = range(0, last(pendulum.t); length = line_smoothness)
        positions = pendulum(timestamps)
        plot!(p, positions[3, :], positions[4, :]; linewidth = line_width, linealpha = line_alpha)
    end
    scatter!(
        p,
        [magnet.position[1] for magnet in magnets],
        [magnet.position[2] for magnet in magnets];
        markershape = :xcross,
    )
    return p
end

plot_path(pendulums::Vector{ODESolution}; kwargs...) = plot_path(pendulums, []; kwargs...)
plot_path(pendulum::ODESolution; kwargs...) = plot_path([pendulum], []; kwargs...)
