using Plots 

# Function to create animation of fixed point iteration
function create_fixpoint_movie(g, x_init, filename; 
                             xtol=0.001, max_iter=20, 
                             xrange=(0,2), dx=0.1)
    
    # Set up the video encoding
    anim = Animation()
    
    # Create x values for plotting
    xvalues = range(xrange[1], xrange[2], step=dx)
    
    # Initialize iteration variables
    x_history = [x_init]
    error = Inf
    niter = 0
    
    # Main iteration loop
    while error > xtol && niter < max_iter
        niter += 1
        
        # Compute new value
        x_new = g(x_history[end])
        error = (x_new - x_history[end])^2
        push!(x_history, x_new)
        
        # Create new frame
        p = plot(xvalues, g.(xvalues), 
                label="g(x)", 
                linewidth=2, 
                legend=:topleft)
        
        # Add y=x line
        plot!(p, xvalues, xvalues, 
              label="y=x", 
              linewidth=2)
        
        # Add iteration points
        scatter!(p, x_history, x_history, 
                label="Iterations", 
                marker=:star,
                markersize=8)
        
        # Set consistent axis limits
        xlims!(xrange)
        ylims!(xrange)
        
        # Add to animation
        frame(anim)
    end
    
    # Save the animation
    gif(anim, filename, fps=1)
end

# Example usage
# Define the function g(x) = √x
g(x) = sqrt(x)

# Create the movie starting from x=0.1
create_fixpoint_movie(g, 0.1, "fixpoint_iteration.gif")