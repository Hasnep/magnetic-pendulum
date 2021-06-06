using Luxor

function save_svg(file_name)
    scale_by = 200
    axes_limit = 2
    drawing_size = scale_by * axes_limit
    Drawing(drawing_size, drawing_size, joinpath(pwd(), "build", "images", file_name))
    origin()
    scale(scale_by)

    # Draw axes
    setline(1)
    setcolor("black")
    line(Point(-axes_limit, 0), Point(axes_limit, 0), :stroke)
    line(Point(0, -axes_limit), Point(0, axes_limit), :stroke)
end
