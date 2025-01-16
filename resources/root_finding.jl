using Plots
using Printf
using LinearAlgebra
using NonlinearSolve

##########################
# Bisection Example
##########################
"""
    bisect(f, a, b; tol=1e-4)

Find root of function f in interval [a,b] using bisection method.
"""
function bisect(f, a, b; tol=1e-4)
    s = sign(f(a))
    x = (a + b) / 2
    d = (b - a) / 2
    xsave = [x]
    
    while d > tol
        d = d / 2
        if s == sign(f(x))
            x = x + d
        else
            x = x - d
        end
        push!(xsave, x)
    end
    
    return x, xsave
end

# Example usage
f(x) = x^3
a, b = -6.0, 12.0
x_root, iterations = bisect(f, a, b)
println("Root found at x = $x_root")

# Visualize the function and iterations
x_plot = range(-4, 4, length=100)
p = plot(x_plot, f.(x_plot), label="f(x) = x³", legend=:topleft)
plot!(p, x_plot, zeros(length(x_plot)), label="y = 0")
scatter!(p, iterations, f.(iterations), label="Iterations")
display(p)


######################################
# Function iteration example
######################################
"""
    fixpoint(g, x0; tol=1e-4, max_iter=100)

Find fixed point of function g starting from x0.
"""
function fixpoint(g, x0; tol=1e-4, max_iter=100)
    
    x = x0
    x_history = [x]
    error = Inf
    iter = 0
    
    while error > tol && iter < max_iter
        x_new = g(x)
        error = abs(x_new - x)
        x = x_new
        push!(x_history, x)
        iter += 1
    end
    
    return x, x_history
end

# Example: Fixed point iteration for g(x) = √x
g(x) = sqrt(x)

# Try from below fixed point
x_fp1, hist1 = fixpoint(g, 0.1)
println("Fixed point from below: $x_fp1")

# Try from above fixed point
x_fp2, hist2 = fixpoint(g, 1.8)
println("Fixed point from above: $x_fp2")

# Visualize fixed point iteration
x_plot = range(0, 2, length=100)
p = plot(x_plot, g.(x_plot), label="g(x) = √x", legend=:topleft)
plot!(p, x_plot, x_plot, label="y = x")
scatter!(p, hist1, hist1, label="Iterations from below")
display(p)


############################
# Newton's Method
############################
"""
    newton(f, df, x0; tol=1e-4, max_iter=20)

Find root of function f with derivative df using Newton's method.
"""
function newton(f, f_prime, x_init; tol=1e-8, max_iter=100)
    x = x_init
    x_path = [x]
    
    for i in 1:max_iter
        fx = f(x)
        if abs(fx) < tol
            return x, x_path
        end
        
        df = f_prime(x)
        if abs(df) < eps()
            error("Derivative too close to zero")
        end
        
        x_new = x - fx/df
        push!(x_path, x_new)
        x = x_new
    end
    error("Maximum iterations reached")
end

# Example
f(x) = -12 + 2x^(-3)
f_prime(x) = -6x^(-4)
x, path = newton(f, f_prime, 0.1)
println("Root: ", x)

# Visualize Newton's method
x_plot = range(0.1, 0.8, length=100)
p = plot(x_plot, f.(x_plot), label="f(x)", legend=:topleft)
plot!(p, x_plot, zeros(length(x_plot)), label="y = 0")
scatter!(p, path, f.(path), label="Newton iterations")
display(p)



##########################
# Secant Method
##########################
"""
    secant(f, x0, x1; tol=1e-4, max_iter=20)

Find root of function f using the secant method.
"""
function secant(f, x0, x1; tol=1e-4, max_iter=20)
    x_prev = x0
    x = x1
    x_history = [x_prev, x]
    error = Inf
    iter = 0
    
    while error > tol && iter < max_iter
        x_new = x - f(x) * (x - x_prev)/(f(x) - f(x_prev))
        error = abs(x_new - x)
        x_prev = x
        x = x_new
        push!(x_history, x)
        iter += 1
    end
    
    return x, x_history
end

# Example using secant method
x_root, hist = secant(f, 0.1, 0.2)
println("Root found using secant method: $x_root")

# Visualize secant method
x_plot = range(0.1, 0.8, length=100)
p = plot(x_plot, f.(x_plot), label="f(x)", legend=:topleft)
plot!(p, x_plot, zeros(length(x_plot)), label="y = 0")
scatter!(p, hist, f.(hist), label="Secant iterations")
display(p)


##############################
# Multi-variate Problems
# (Newton-Raphson v. Broyden)
##############################

# System of equations
function f!(F, x)
    F[1] = x[1]^2 + x[2]^2 - 1
    F[2] = x[1] - x[2]
end

# Initial guess
x0 = [2.0, 1.0]

# Set up problem
prob = NonlinearProblem(f!, x0)

# Solve using Newton-Raphson
sol_newton = solve(prob, NewtonRaphson(), abstol=1e-8)

# Solve using Broyden
sol_broyden = solve(prob, Broyden(), abstol=1e-8)

println("Newton-Raphson solution: ", sol_newton.u)
println("Newton-Raphson iterations: ", sol_newton.iterations)
println("\nBroyden solution: ", sol_broyden.u)
println("Broyden iterations: ", sol_broyden.iterations)