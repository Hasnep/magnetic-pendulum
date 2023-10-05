IS_INTERACTIVE = true; # hide
project_root = abspath(joinpath(pwd(), IS_INTERACTIVE ? "." : "..")); # hide
include(joinpath(project_root, "src", "colour-scheme.jl")); # hide
include(joinpath(project_root, "src", "plot-animation.jl")); # hide
include(joinpath(project_root, "src", "plot-basin.jl")); # hide
include(joinpath(project_root, "src", "plot-magnet-effects.jl")); # hide
include(joinpath(project_root, "src", "plot-magnets.jl")); # hide
include(joinpath(project_root, "src", "plot-path.jl")); # hide
include(joinpath(project_root, "src", "save-plots.jl")); # hide

# I saw a YouTube video titled [The relationship between chaos, fractal and physics](https://www.youtube.com/watch?v=C5Jkgvw-Z6E) which explained an experiment involving a metal pendulum swinging freely over some magnets.
# In the video they used a simulation to study the basin of attraction.
# I will try to recreate some of the animations in the video using the DifferentialEquations package in Julia.

# First, let's define the equations of motion that the pendulum will experience: gravity, friction and magnetism.
# For gravity, if we define the position where pendulum is hanging vertically down to be the origin, then for a long enough pendulum the effect of gravity will be proportional to the distance form the origin and the mass of the pendulum, i.e. $F_\text{gravity} \propto \vec{s}.$
# N2L says that $F \propto a$, so $a_\text{gravity} \propto \vec{s}$.
# Let's write this as $a \propto s$ so $a = -g \vec{s}$ where $g > 0$ is some gravitational constant of proportionality that factors in mass.
# The negative means this will pull the pendulum back to the centre.
# As a Julia function this would be:

acceleration_gravity(s, g) = -g .* s

# We broadcast the multiplication using `.*` because `s` is a vector.

# Let's see this in action

# Pull back the magnet

s₀ = [5.0, 5.0]

# Stationary start

v₀ = [0.0, 0.0]

# Set the time range to three seconds

t_range = [0.0, 3.0]

# Set the gravitational constant to any number, (I just picked this one at random by measuring the acceleration of an apple falling to the ground in metres per second per second.)

g = 9.81

# Set up the differential equation how DiffEq.jl wants it

using DifferentialEquations: SecondOrderODEProblem, solve
ode_gravity = (v, s, p, t) -> acceleration_gravity(s, p[1])
ode_problem_gravity = SecondOrderODEProblem(ode_gravity, v₀, s₀, t_range, [g])

# Solve

sol_gravity = solve(ode_problem_gravity);

# We can call the solution to get the state at that timestep:

sol_gravity(0.0)

# That's the initial conditions, v₀ and s₀.

sol_gravity(2.0)

# At timestep 2, the pendulum is going towards the the opposite corner and has a velocity pointing to the bottom left.

# Instead of looking at the numbers let's  plot the solution, see [this blogpost's repo](https://github.com/hasnep/magnet-pendulum/) for the plotting code.

save_video("gravity.gif", plot_animation(sol_gravity); time_extrema = t_range); # hide

# ![Gravity](gravity.gif)

# The pendulum is swinging towards the centre, but it swings back to the same place without losing any energy.
# Let's add damping.
# Damping is proportional to the velocity of the pendulum,
# $$F_text{damping} \propto v$$
# So applying N2L again and combining constants of proportionality,
# $$a_\text{damping} \propto v$$
# in code is

acceleration_damping(v, d) = -d .* v

# Constant of damping 

d = 0.5

# Set up another differential equation how DiffEq.jl wants it

ode_damping = (v, s, p, t) -> acceleration_gravity(s, p[1]) .+ acceleration_damping(v, p[2])
ode_problem_damping = SecondOrderODEProblem(ode_damping, v₀, s₀, t_range, [g, d])

# Solve

sol_damping = solve(ode_problem_damping);

# Plot the solution

save_video("damping.gif", plot_animation(sol_damping); time_extrema = t_range); # hide

# ![Damping](damping.gif)

# The pendulum comes to a rest at the origin, which matches a pendulum in real life, so that's good.

# For fun, here's the same thing with loads of pendulums starting at random positions and with random initial velocities.

using Distributions: MvNormal
sols =
    solve.([
        SecondOrderODEProblem(
            ode_damping,
            [0.0, 0.0],
            rand(MvNormal(2, 1)),
            t_range,
            [g, d],
        ) for _ = 1:100
    ]);

save_video("pendulums.gif", plot_animation(sols); time_extrema = t_range); # hide

# ![Pendulums](pendulums.gif)

# All of the pendulums have the same period, which matches real life pendulums, where the period relates to the length of the pendulum

problems_pushed = [
    SecondOrderODEProblem(
        ode_damping,
        rand(MvNormal(2, 1)),
        rand(MvNormal(2, 1)),
        t_range,
        [g, d],
    ) for _ = 1:100
]
sols_pushed = solve.(problems_pushed);

save_video("pendulums-pushed.gif", plot_animation(sols_pushed), time_extrema = t_range); # hide

# ![Pushed pendulums](pendulums-pushed.gif)

# ## Adding magnets

# Now lets add the thing that will make this interesting: the magnets.
# A magnet has a position and a polarity.

struct Magnet
    position::Vector{Float64}
    polarity::Float64
end

# The effect of a magnet at position $x$ on a pendulum at position $s$ is $$p \frac{x - s}{(|x - s|^2 + h^2)^5/2}$$

using LinearAlgebra: norm

function calculate_magnet_effect(s, x, p, h)
    numerator = x .- s
    denominator = sqrt(norm(x .- s)^2 + h^2)^5
    return p * numerator / denominator
end

function magnet_boi(v, s, parameters, t)
    d, h, g, magnet_polarities, magnet_positions = parameters
    magnet_effects::Vector{Vector{Real}} = [
        calculate_magnet_effect(s, x, p, h) for
        (p, x) in zip(magnet_polarities, magnet_positions)
    ]
    return acceleration_damping(v, d) .+ acceleration_gravity(s, g) .+ sum(magnet_effects)
end

# Try plotting loads of pendulums
d = 0.05
g = 0.05
h = 0.5
p = 5.0
magnet_distance = 3.0
t_range = [0.0, 20.0]
magnets = vec([
    Magnet(magnet_distance .* [sin(θ), cos(θ)], p) for
    θ in π .* range(0, 2, length = 4)[1:(end-1)]
])
probs_magnets = [
    SecondOrderODEProblem(
        magnet_boi,
        [0.0, 0.0],
        rand(MvNormal(2, 1)),
        t_range,
        [d, h, g, getfield.(magnets, :polarity), getfield.(magnets, :position)],
    ) for _ = 1:50
]
sols_magnets = solve.(probs_magnets);

# Plot the positions
save_video(
    "pendulums-magnets.gif",
    plot_animation(sols_magnets, magnets),
    time_extrema = t_range,
); # hide

# ![Pendulums with magnets](pendulums-magnets.gif)

# All of the pendulums end up close to one of the magnets, but can we predict which magnet the pendulum will finish closest to?
# If we plot the paths of three pendulums that start close to each other we can see that they each end over a different magnet.
# This concept is part of chaos theory.

probs_guess = [
    SecondOrderODEProblem(
        magnet_boi,
        [0.0, 0.0],
        s₀,
        [0.0, 10.0],
        [d, h, g, getfield.(magnets, :polarity), getfield.(magnets, :position)],
    ) for s₀ in [[1.0, -1.5], [1.0, -1.0], [1.5, -0.7]]
]
sols_guess = solve.(probs_guess);

save_svg("pendulums-path-guess.svg", axes_limit = 3.5); # hide
plot_path(sols_guess, magnets); # hide
finish(); # hide

# ![Pendulums with magnets](pendulums-path-guess.svg)

save_svg("magnet-effects.svg", axes_limit = 3.5); # hide
plot_magnet_effects(magnets; h = h, n_steps = 100, limit = 2); # hide
finish(); # hide

# ![Magnet effects](magnet-effects.svg)

# Lets plot the basin of attraction

g = 1.0
d = 0.05
h = 0.5
p = 1.0

function get_closest_magnet(xy)
    prob = SecondOrderODEProblem(
        magnet_boi,
        [0.0, 0.0],
        [xy...],
        [0.0, 5.0],
        [d, h, g, getfield.(magnets, :polarity), getfield.(magnets, :position)],
    )
    sol = solve(prob)
    end_position = sol[3:4, end]
    return findmin([norm(m.position .- end_position) for m in magnets])[2]
end

## basin_of_attraction = plot_basin(get_closest_magnet, magnets; limit=2.5, n_steps=250)

## save_svg(basin_of_attraction, "basin-of-attraction.svg") # hide
