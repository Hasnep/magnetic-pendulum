# # Recreating the Magnetic Pendulum Fractal in Julia

# Test blogpost, please ignore :)

function f(n)
    b = BitSet(1:n)
    for i in 0:6:n, j in 0:9:n, k in 0:20:n
        delete!(b, i + j + k)
    end
    return maximum(b)
end
 
println(f(100))
