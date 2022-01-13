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
    for gridline in (-axes_limit):(axes_limit)
        setopacity(gridline == 0 ? 1 : 0.25)
        line(Point(-axes_limit, gridline), Point(axes_limit, gridline), :stroke)
        line(Point(gridline, -axes_limit), Point(gridline, axes_limit), :stroke)
    end
end

function save_svg(file_name::String; axes_limit::Real = 10, drawing_size::Integer = 500)
    Drawing(drawing_size, drawing_size, joinpath(pwd(), "build", file_name))
    setup_canvas(axes_limit, drawing_size)
end

function save_video(file_name::String, frame_function; axes_limit::Real = 10, drawing_size::Integer = 500)
    movie = Movie(drawing_size, drawing_size, file_name)
    setup_scene = Scene(movie, (scene, frame_number) -> setup_canvas(axes_limit, drawing_size))
    frame_number_scene = Scene(
        movie,
        (scene, frame_number) -> begin
            fontsize(1)
            text("f = $frame_number", Point(0, 0.9 * axes_limit); valign = :top, halign = :centre)
        end,
    )
    animate(
        movie,
        [
            setup_scene,
            # frame_number_scene,
            Scene(movie, frame_function),
        ];
        creategif = true,
        pathname = joinpath(pwd(), "build", file_name),
        framerate = 60,
    )
end
