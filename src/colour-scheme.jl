function get_nth_colour(n; colour_scheme = ColorSchemes.tol_bright)
    return colour_scheme[mod(n, length(colour_scheme)) + 1]
end
