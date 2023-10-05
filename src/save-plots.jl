using Luxor

function setup_canvas(axes_limit::Real, drawing_size::Integer)
    origin()
    scale_by = drawing_size / axes_limit
    scale(scale_by, -scale_by)

    # Background
    background("black")
    setcolor("white")

    # Draw axes and gridlines
    setline(1)
    for gridline = (-axes_limit):(axes_limit)
        setopacity(gridline == 0 ? 1 : 0.25)
        line(Point(-axes_limit, gridline), Point(axes_limit, gridline), :stroke)
        line(Point(gridline, -axes_limit), Point(gridline, axes_limit), :stroke)
    end
end

function save_svg(file_name; axes_limit = 10, drawing_size = 500)
    Drawing(drawing_size, drawing_size, joinpath(pwd(), file_name))
    setup_canvas(axes_limit, drawing_size)
end

function save_video(
    file_name,
    frame_function;
    time_extrema,
    axes_limit = 10,
    drawing_size = 500,
    framerate = 24,
)
    frame_extrema = Int.(framerate .* time_extrema)
    frame_range = range(start = frame_extrema[1], step = 1, stop = frame_extrema[2])
    movie = Movie(drawing_size, drawing_size, file_name, frame_range)
    setup_scene =
        Scene(movie, (scene, frame_number) -> setup_canvas(axes_limit, drawing_size))
    # timestamp_scene = Scene(
    #     movie,
    #     (scene, frame_number) -> begin
    #         origin()
    #         scale_by = drawing_size / axes_limit
    #         scale(scale_by, scale_by)
    #         fontsize(1)
    #         timestamp = frame_number * time_extrema
    #         Luxor.text(
    #             "f = $frame_number, t = $timestamp",
    #             Point(0, 0.9);
    #             valign=:top,
    #             halign=:centre
    #         )
    #     end
    # )
    animation_scene = Scene(movie, frame_function)
    Luxor.animate(
        movie,
        [
            setup_scene,
            #  timestamp_scene,
            animation_scene,
        ];
        creategif = true,
        pathname = joinpath(pwd(), file_name),
        framerate = framerate,
    )
end
