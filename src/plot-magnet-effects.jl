function plot_magnet_effects(magnets::Vector; h = 1, limit = 1, n_steps = 50)
    xs = range(-limit, limit, length = n_steps)
    ys = range(-limit, limit, length = n_steps)
    zs = zeros(n_steps, n_steps)
    for i in 1:n_steps, j in 1:n_steps
        position = [xs[i], ys[j]]
        zs[j, i] =
            norm(sum(calculate_magnet_effect(position, magnet.position, magnet.polarity, h) for magnet in magnets))
    end
    p = heatmap(xs, ys, zs; aspect_ratio = :equal)
    scatter!(
        p,
        [magnet.position[1] for magnet in magnets],
        [magnet.position[2] for magnet in magnets];
        markershape = :xcross,
        legend = false,
    )
    return p
end
