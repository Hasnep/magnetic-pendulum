using Luxor

function plot_path(pendulums::Vector{<:ODESolution}, magnets::Vector; line_smoothness = 1000)
    for (i, pendulum) in enumerate(pendulums)
        timestamps = range(0, last(pendulum.t); length = line_smoothness)
        positions = pendulum(timestamps)
        points = Point.(positions[3, :], positions[4, :])
        setcolor(get_nth_colour(i))
        poly(points, :stroke)
    end

    plot_magnets(magnets)
end

plot_path(pendulums::Vector{<:ODESolution}; kwargs...) = plot_path(pendulums, []; kwargs...)
plot_path(pendulum::ODESolution; kwargs...) = plot_path([pendulum], []; kwargs...)
