using Optim
using BenchmarkTools
using ForwardDiff
using Statistics
using DataFrames
using Plots

"""
Compute gradient using finite differences.

Parameters:
- f: function to differentiate
- x: point at which to compute gradient
- h: step size (default: 1e-8)
- method: "forward" or "central" (default: "forward")

Returns:
- gradient vector at point x
"""
function finite_diff_gradient(f, x::Vector{T}, 
                            h::T=1e-8, 
                            method::String="forward") where T<:Real
    n = length(x)
    grad = zeros(T, n)
    x_temp = copy(x)
    
    for i in 1:n
        if method == "forward"
            # Forward difference
            x_temp[i] = x[i] + h
            grad[i] = (f(x_temp) - f(x)) / h
        else
            # Central difference
            x_temp[i] = x[i] + h
            forward = f(x_temp)
            x_temp[i] = x[i] - h
            backward = f(x_temp)
            grad[i] = (forward - backward) / (2h)
        end
        x_temp[i] = x[i]  # Reset
    end
    
    return grad
end

"""
Run multiple trials of optimization with different starting points
"""
function benchmark_from_multiple_starts(f, g!, method, starts; max_time=5.0)
    results = []
    
    for x0 in starts
        # Set up optimization parameters
        opts = Optim.Options(
            iterations=1000,
            time_limit=max_time,
            show_trace=false
        )
        
        # Time the optimization
        if method isa NelderMead
            time = @elapsed result = optimize(f, x0, method, opts)
        else
            time = @elapsed result = optimize(f, g!, x0, method, opts)
        end
        
        push!(results, (
            time=time,
            iterations=Optim.iterations(result),
            minimum=Optim.minimum(result),
            converged=Optim.converged(result),
            x_final=Optim.minimizer(result)
        ))
    end
    
    return results
end

"""
Generate statistics from benchmark results
"""
function analyze_results(results)
    times = [r.time for r in results]
    iterations = [r.iterations for r in results]
    minima = [r.minimum for r in results]
    converged = [r.converged for r in results]
    
    return (
        mean_time=mean(times),
        std_time=std(times),
        mean_iterations=mean(iterations),
        std_iterations=std(iterations),
        best_minimum=minimum(minima),
        worst_minimum=maximum(minima),
        convergence_rate=mean(converged),
        n_trials=length(results)
    )
end

"""
Create a visualization of optimization paths
"""
function plot_optimization_paths(f, bounds, results; resolution=100, func_name="", method_name="")
    x = range(bounds[1][1], bounds[1][2], length=resolution)
    y = range(bounds[2][1], bounds[2][2], length=resolution)
    z = [f([i, j]) for i in x, j in y]
    
    # Create main title with function and method information
    n_starts = length(results)
    main_title = "Optimization of $(func_name) Function\n" *
                 "Method: $(method_name)\n" *
                 "Number of Different Starting Points: $(n_starts)"
    
    # Create plot with enhanced information
    p = contour(x, y, z, 
                fill=true, 
                title=main_title,
                xlabel="x₁",
                ylabel="x₂",
                colorbar_title="Function Value",
                titlefont=font(10),
                margin=10Plots.mm)
    
    # Plot final points from all trials
    final_points = [r.x_final for r in results]
    xs = [p[1] for p in final_points]
    ys = [p[2] for p in final_points]
    scatter!(p, xs, ys, 
             label="Final Points",
             color=:red,
             markersize=4,
             markershape=:circle)
    
    # Add convergence information
    n_converged = sum([r.converged for r in results])
    convergence_rate = round(100 * n_converged / n_starts, digits=1)
    annotate!(p, bounds[1][1], bounds[2][2], 
             text("Convergence Rate: $(convergence_rate)%", :left, 8))
    
    return p
end

# Test functions
# Rosenbrock (Banana) function
banana(x) = 100 * (x[2] - x[1]^2)^2 + (1 - x[1])^2

function banana_gradient!(g, x)
    g[1] = -400 * x[1] * (x[2] - x[1]^2) - 2 * (1 - x[1])
    g[2] = 200 * (x[2] - x[1]^2)
end

# Himmelblau function
himmelblau(x) = (x[1]^2 + x[2] - 11)^2 + (x[1] + x[2]^2 - 7)^2

# Let's make a simpler version to verify step by step
function himmelblau_value(x, y)
    term1 = (x^2 + y - 11)^2
    term2 = (x + y^2 - 7)^2
    return term1 + term2
end

# Himmelblau gradient, implemented as directly as possible
function himmelblau_gradient!(g, x)
    # First term derivatives: (x^2 + y - 11)^2
    term1 = x[1]^2 + x[2] - 11
    dx1 = 2 * term1 * (2*x[1])  # chain rule for x
    dy1 = 2 * term1 * (1)       # chain rule for y
    
    # Second term derivatives: (x + y^2 - 7)^2
    term2 = x[1] + x[2]^2 - 7
    dx2 = 2 * term2 * (1)       # chain rule for x
    dy2 = 2 * term2 * (2*x[2])  # chain rule for y
    
    g[1] = dx1 + dx2
    g[2] = dy1 + dy2
end


# Run benchmarks
function run_full_benchmark()
    # Test functions to benchmark
    functions = [
        (f=banana, g=banana_gradient!, name="Rosenbrock"),
        (f=himmelblau, g=himmelblau_gradient!, name="Himmelblau")
    ]
    
    # Define optimization methods and their gradient approaches
    method_configs = [
        (method=NelderMead(), name="NelderMead", grad_type="None"),
        (method=BFGS(), name="BFGS", grad_type="Analytical"),
        (method=BFGS(), name="BFGS-FD", grad_type="Numerical"),
        (method=BFGS(), name="BFGS-AD", grad_type="AutoDiff"),
        (method=GradientDescent(), name="GradientDescent", grad_type="Analytical"),
        (method=ConjugateGradient(), name="ConjugateGradient", grad_type="Analytical")
    ]
    
    # Generate random starting points
    n_trials = 10
    starts = [2 .* randn(2) for _ in 1:n_trials]
    
    # Store results
    all_results = DataFrame(
        function_name=String[],
        method_name=String[],
        gradient_type=String[],
        mean_time=Float64[],
        std_time=Float64[],
        mean_iterations=Float64[],
        convergence_rate=Float64[],
        best_minimum=Float64[]
    )
    
    for f in functions
        bounds = ((-4.0, 4.0), (-4.0, 4.0))  # Search bounds
        
        for config in method_configs
            # Select appropriate gradient function based on type
            gradient_func = if config.grad_type == "None"
                nothing
            elseif config.grad_type == "Numerical"
                # Simple forward differences
                (g, x) -> begin
                    grad = finite_diff_gradient(f.f, x)
                    g .= grad
                end
            elseif config.grad_type == "AutoDiff"
                (g, x) -> ForwardDiff.gradient!(g, f.f, x)
            else  # Analytical
                f.g
            end
            
            # Run optimization
            results = benchmark_from_multiple_starts(
                f.f, gradient_func, config.method, starts
            )
            stats = analyze_results(results)
            
            push!(all_results, (
                f.name,
                config.name,
                config.grad_type,
                stats.mean_time,
                stats.std_time,
                stats.mean_iterations,
                stats.convergence_rate,
                stats.best_minimum
            ))
            
            # Generate visualization
            p = plot_optimization_paths(f.f, bounds, results,
                                     func_name=f.name,
                                     method_name="$(config.name)\n($(config.grad_type) Gradients)")
            display(p)
            savefig(p, "$(f.name)_$(config.name)_$(config.grad_type)_paths.png")
        end
    end
    
    return all_results
end

# Run the full benchmark and display results
results = run_full_benchmark()
println("\nBenchmark Results:")
println(results)