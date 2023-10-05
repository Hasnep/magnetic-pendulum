using Luxor
using ShiftedArrays: lag
using DifferentialEquations

lerp(a, b, c, d) = (x) -> ((d - c) * (x - a) * (b - a)^(-1)) + c

function plot_animation(
    pendulums::Vector{<:ODESolution},
    magnets;
    line_smoothness = 100,
    line_length = 0.5,
    line_width = 5,
)
    timesteps = last(getfield.(pendulums, :t))
    frame_number_to_timestep(x; scene) =
        lerp(extrema(scene.framerange)..., extrema(timesteps)...)(x)
    return (scene, frame_number) -> begin
        t = frame_number_to_timestep(frame_number; scene)
        for (i, pendulum) in enumerate(pendulums)
            time_limits = (max(0, t - line_length), t)
            timestamps = range(time_limits...; length = line_smoothness)
            positions = pendulum(timestamps)
            points = Point.(positions[3, :], positions[4, :])

            # Draw line
            setcolor(get_nth_colour(i))
            for (j, (from_point, to_point)) in
                enumerate(collect(zip(lag(points), points))[2:(end-1)])
                setline(line_width * j / (length(points) - 2))
                line(from_point, to_point, :stroke)
            end
        end
        plot_magnets(magnets)
    end
end

plot_animation(pendulums::Vector{<:ODESolution}; kwargs...) =
    plot_animation(pendulums, []; kwargs...)
plot_animation(pendulum::ODESolution; kwargs...) = plot_animation([pendulum], []; kwargs...)
