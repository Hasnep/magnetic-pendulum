function plot_animation(
    pendula::Vector{<:ODESolution},
    magnets::Vector;
    n_frames = 100,
    line_length = 1,
    line_width = 2,
    line_smoothness = 10,
    limit = 2,
)
    max_time = maximum(last(getfield.(pendula, :t)))
    return @animate for t in range(0, max_time; length = n_frames)
        p = plot(xlims = (-limit, limit), ylims = (-limit, limit), legend = false, aspect_ratio = :equal)
        for pendulum in pendula
            timestamps = range(max(0, t - line_length), t; length = line_smoothness)
            positions = pendulum(timestamps)
            plot!(p, positions[3, :], positions[4, :]; linewidth = range(0, line_width, length = line_smoothness))
        end
        scatter!(
            p,
            [magnet.position[1] for magnet in magnets],
            [magnet.position[2] for magnet in magnets];
            markershape = :xcross,
        )
        title!(p, "t=$(round(t; digits = 2))")
    end
end

plot_animation(pendula::Vector{ODESolution}; kwargs...) = plot_animation(pendula, []; kwargs...)
plot_animation(pendulum::ODESolution; kwargs...) = plot_animation([pendulum], []; kwargs...)
