using LinearAlgebra

# System of equations
function f!(F, x)
    F[1] = x[1]^2 + x[2]^2 - 1
    F[2] = x[1] - x[2]
    return F
end

# Finite difference approximation for initial Jacobian
function approximate_jacobian(f!, x, F, ε=1e-8)
    n = length(x)
    J = zeros(n, n)
    F_temp = similar(F)
    
    for i in 1:n
        x_temp = copy(x)
        x_temp[i] += ε
        f!(F_temp, x_temp)
        J[:, i] = (F_temp - F) / ε
    end
    return J
end

# Custom Broyden implementation
function broyden_solve(f!, x0; maxiter=100, tol=1e-8)
    x = copy(x0)
    n = length(x0)
    F = zeros(n)
    f!(F, x)
    
    # Initial Jacobian approximation
    J = approximate_jacobian(f!, x, F)
    
    iterations = 0
    while norm(F) > tol && iterations < maxiter
        # Solve linear system J * δx = -F
        δx = -J \ F
        
        # Store old values
        x_old = copy(x)
        F_old = copy(F)
        
        # Update x
        x += δx
        f!(F, x)
        
        # Broyden update formula for Jacobian
        δf = F - F_old
        δx_outer = δx * δx'
        J = J + (δf - J*δx) * δx' / (δx'δx)
        
        iterations += 1
    end
    
    return x, iterations, norm(F)
end

# Initial guess
x0 = [2.0, 1.0]

# Solve using custom Broyden implementation
solution, iterations, final_residual = broyden_solve(f!, x0)

println("\nBroyden solution: ", solution)
println("Broyden iterations: ", iterations)
println("Final residual: ", final_residual)




### example code:

# using LinearAlgebra

# # System of equations
# function f!(F, x)
#     F[1] = x[1]^2 + x[2]^2 - 1
#     F[2] = x[1] - x[2]
# end

# # Initial guess
# x0 = [2.0, 1.0]

# # Set up problem
# using NonlinearSolve
# using SimpleNonlinearSolve
# prob = NonlinearProblem(f!, x0)

# # Solve using Broyden
# sol_broyden = solve(prob, Broyden(), abstol=1e-8)

# println("\nBroyden solution: ", sol_broyden.u)
# println("Broyden iterations: ", sol_broyden.iterations)
