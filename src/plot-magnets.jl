using Luxor

function plot_magnets(magnets)
    for magnet in magnets
        setcolor("white")
        # star(magnet.position..., 0.075, 5, 1/3,  π/8, :fill)
        circle(magnet.position..., 0.02, :fill)
    end
end
