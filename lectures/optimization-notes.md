# Optimization

How do we get a computer to find the max/min of a function.

Remember, you'll be dealing with complicated functions in your research -- so you'll want to be mindful of computation. 

First we'll discuss a popular non-derivative based method. 

### Nelder-Mead Optimization

* non-derivative based method
* works in multiple dimensions

**Algorithm**

* Example: in three dimension 

1. Guess three starting points to form a simplex. 
2. Evaluate and order so that $f(a) < f(b) < f(c)$
3. Reflect: reflect $c$ through $a-b$.
   <!-- * if $f(a) < f(c') < f(b)$ then go to step 1.  -->
4. Expand. If $f(c')<f(a)$, then keep going with the reflection.
5. Contract.  if $f(a) < f(c') < f(b)$ then contract $c'$ to see if it improves. 
6. Shrink. If the contracted point is the worst still, then shrink the original simplex towards $a$ (without replacing $a$).


![Visualization of Nelder Mead Algorithm](neldermead.png)



Define the following functions:

```julia
using Optim  # For optimization routines

# Banana function:
f(x) = -100*(x[2]-x[1]^2)^2-(1-x[1])^2
```

<div align="center">

![Visualization of the Banana Function](banana.png)
</div>

Now call Julia's optimization routine for Nelder-Mead:

```julia
using BenchmarkTools  # For timing

@time result = optimize(x -> -f(x), [1.0, 0.0], NelderMead())
x = Optim.minimizer(result)
```

Note: In Julia, we're using the Optim.jl package which provides similar functionality to MATLAB's optimization toolbox. The interface is slightly different but achieves the same goal.

## Newton Raphson Method

* Use successive quadratic approximations to the objective.
* Hope is that the max of the approximants converges to the max of the objective.
* This is the EXACT same principle as the Newton root-finding routine.
  * Just apply Newton's for root-finding to the gradient.

### Iterative procedure:

* Provide guess x⁽⁰⁾
* Maximize the 2nd order Taylor expansion to f about x⁽⁰⁾:
$$f(x) ≈ f(x^0) + f'(x^0)(x-x^0) + \frac{1}{2}(x-x^0)^\top f''(x^0)(x-x^0)$$
* This yields the iterative rule: $x⁽¹⁾ ← x⁽⁰⁾ - [f''(x⁽⁰⁾)]⁻¹f'(x⁽⁰⁾)$

##### Notes:

* If you solve the first order condition then it turns into a root finding problem!*
* Recall the iterative rule for Newton's Method: $x^{(t+1)} ← x^t - [f'(x^t)]⁻¹f(x^t)$
* This is the same iterative rule for root finding, except "one-level" up.

In theory this method will converge to a _local max_ if f is twice continuously differentiable, and if the initial guess is "sufficiently close to a local max, at which $f''$ is negative definite. In practice the Hessian must be well conditioned, i.e., we do not want to divide by zero.

In practice this method is not used because:

* Must compute both first and second derivatives
* No guarantee that next step increases the function value because $f''$ need not satisfy the Second Order Conditions (negative definiteness)
* Also, like most of the procedures we will talk about, we can only find local minimum. (but this is basically unavoidable)

## Quasi-Newton Methods

In practice, we use a strategy similar to Newton-Raphson, but employ an approximation to the Hessian that we force/require to be negative-definite.

This guarantees that the function can be increased in the direction of the Newton Step.

In practice, we will use solvers that approximate the inverse of the Hessian, and do not require any information about the true Hessian.

We will use the following update rule, analogous to Newton-Raphson:

$$d⁽ᵏ⁾ = -B⁽ᵏ⁾f'(x⁽ᵏ⁾)$$

where $B⁽ᵏ⁾$ is the approximation to the inverse of the Hessian.

There are many Q-N methods -- they differ in how they update the inverse Hessian:

**Steepest Ascent:**

Set $B⁽ᵏ⁾ = -I$

**DFP:**

$B ← B + (ddᵀ)/(dᵀu) - (BuuᵀB)/(uᵀBu)$

where $d = x⁽ᵏ⁺¹⁾ - x⁽ᵏ⁾ and u = f'(x⁽ᵏ⁺¹⁾) - f'(x⁽ᵏ⁾)$

**BFGS:**

$B ← B + (1)/(dᵀu)(wdᵀ + dwᵀ - (wᵀu)/(dᵀu)ddᵀ)$

where $w = d - Bu$

## Examples

Compare Q-N method to Nelder-Mead method above.

Banana function (without supplied derivative):

```julia
# Using BFGS without gradient
result = optimize(x -> -f(x), [1.0, 0.0], BFGS())
x_new = Optim.minimizer(result)
```

Banana function (with supplied derivative):

```julia
# Define gradient for banana function
function banana_grad!(g, x)
    g[1] = 400*x[1]*(x[2]-x[1]^2) - 2*(1-x[1])
    g[2] = -200*(x[2]-x[1]^2)
    return -g  # Negative because we're maximizing
end

# Using BFGS with gradient
result = optimize(x -> -f(x), (g, x) -> banana_grad!(g, x), [1.0, 0.0], BFGS())
x_new = Optim.minimizer(result)
```


## Benchmarking Results

| Function | Method | Gradient Type | Mean Time (s) | Std Time | Mean Iterations | Convergence Rate | Best Minimum |
|----------|---------|---------------|--------------|-----------|-----------------|-----------------|--------------|
| Rosenbrock | NelderMead | None | 0.0015 | 0.0046 | 69.2 | 1.0 | 7.91e-10 |
| Rosenbrock | BFGS | Analytical | 0.0020 | 0.0062 | 24.0 | 1.0 | 2.42e-30 |
| Rosenbrock | BFGS-FD | Numerical | 0.0288 | 0.0287 | 744.2 | 0.3 | 2.81e-12 |
| Rosenbrock | BFGS-AD | AutoDiff | 0.0695 | 0.2195 | 24.1 | 1.0 | 2.42e-30 |
| Rosenbrock | GradientDescent | Analytical | 0.0044 | 0.0065 | 1000.0 | 0.0 | 9.93e-5 |
| Rosenbrock | ConjugateGradient | Analytical | 0.0013 | 0.0039 | 27.5 | 1.0 | 2.13e-25 |
| Himmelblau | NelderMead | None | 0.0009 | 0.0026 | 43.9 | 1.0 | 1.13e-9 |
| Himmelblau | BFGS | Analytical | 0.0013 | 0.0039 | 8.5 | 1.0 | 0.0 |
| Himmelblau | BFGS-FD | Numerical | 0.0121 | 0.0274 | 206.7 | 0.8 | 4.40e-16 |
| Himmelblau | BFGS-AD | AutoDiff | 0.0335 | 0.1059 | 8.5 | 1.0 | 0.0 |
| Himmelblau | GradientDescent | Analytical | 0.0001 | 0.0000 | 15.8 | 1.0 | 4.09e-21 |
| Himmelblau | ConjugateGradient | Analytical | 0.0010 | 0.0030 | 9.1 | 1.0 | 5.59e-27 |


## Maximum Likelihood

*(Special case where we know the form of the Hessian.)* 

**Basic idea of Maximum Likelihood:** 
Choose a distribution function for some data, $y$, that depends on unknown parameters, $θ$.

The log likelihood function is the sum of the logs of the likelihoods of each of the data observations: $l(θ; y) = Σₙ ln(f(yᵢ;θ))$

Define the "score" function as the matrix of derivatives of the $LL$ function evaluated at each observation: $sᵢ(θ;y) = ∂l(θ; yᵢ)/∂θ$

Now consider the $n×k$ (obs x params) score matrix. The expectation of the inner product of the score function is equal to the negative of the expectation of the second derivative of the likelihood function ("information" matrix). This is a positive definite that we can use in place of the Hessian to update the search direction.

$d = -[s(θ;y)ᵀs(θ;y)]⁻¹s(θ;y)ᵀ1ₙ$

Plus, the inverse "Hessian" is an estimate for the covariance of $θ$, so we get our standard errors for free!

## "Global Optimization"

* Simulated Annealing
* Genetic Algorithm
* Pattern Search
* MCMC approaches: Chernozhukov and Hong (2003)

These methods can be very very slow to converge, but are useful in cases where you know your objective function is non-smooth or very ill-behaved.
