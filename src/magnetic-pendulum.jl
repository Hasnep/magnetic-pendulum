using Luxor

include(joinpath(pwd(), "src", "save-plots.jl")); # hide

# Test blogpost, please ignore :)

function f(n)
    b = BitSet(1:n)
    for i in 0:6:n, j in 0:9:n, k in 0:20:n
        delete!(b, i + j + k)
    end
    return maximum(b)
end

save_svg("plot.svg") # hide
x = 1:100
y = f.(x) ./ 100
points = [Point(xy...) for xy in zip(x ./ 100, y)]
setcolor("red")
poly(points, :stroke)
finish() # hide

# ![A plot](images/plot.svg)
