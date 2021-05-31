function plot_basin(f, magnets::Vector; limit = 2, n_steps = 100)
    xs = range(-limit, limit, length = n_steps) .|> Float64
    ys = range(-limit, limit, length = n_steps) .|> Float64
    zs = map(f, Iterators.product(xs, ys))
    p = plot(xlims = (-limit, limit), ylims = (-limit, limit), legend = false, aspect_ratio = :equal)
    heatmap!(p, xs, ys, zs)
    scatter!(
        p,
        [magnet.position[1] for magnet in magnets],
        [magnet.position[2] for magnet in magnets];
        markershape = :xcross,
    )
    return p
end
