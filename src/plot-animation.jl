using Luxor
using ShiftedArrays: lag
using DifferentialEquations

function plot_animation(
    pendulums::Vector{<:ODESolution},
    magnets;
    n_frames = 100,
    line_smoothness = 100,
    line_length = 1,
    line_width = 5,
)
    # fontsize(0.01)
    max_timestep = maximum(last(getfield.(pendulums, :t)))
    return (scene, frame_number) -> begin
        t = ((frame_number - 1) / n_frames) * max_timestep
        # text("t = $(round(t))", Point(0, 1); valign = :middle, halign = :centre)
        for (i, pendulum) in enumerate(pendulums)
            time_limits = (max(0, t - line_length), t)
            timestamps = range(time_limits...; length = line_smoothness)
            positions = pendulum(timestamps)
            points = Point.(positions[3, :], positions[4, :])

            # Draw line
            setcolor(get_nth_colour(i))
            for (j, (from_point, to_point)) in enumerate(collect(zip(lag(points), points))[2:(end - 1)])
                setline(line_width * j / (length(points) - 2))
                line(from_point, to_point, :stroke)
            end
        end
        plot_magnets(magnets)
    end
end

plot_animation(pendulums::Vector{<:ODESolution}; kwargs...) = plot_animation(pendulums, []; kwargs...)
plot_animation(pendulum::ODESolution; kwargs...) = plot_animation([pendulum], []; kwargs...)
