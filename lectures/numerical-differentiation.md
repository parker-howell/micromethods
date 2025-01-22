# Numerical Differentiation Methods

## Basic Numerical Methods

### Forward Difference
The forward difference method approximates the derivative using:

```
f'(x) ≈ [f(x + h) - f(x)] / h
```

This method looks "forward" one step to estimate the slope. While simple to implement, it has relatively large truncation errors of order O(h).

### Backward Difference
Similar to forward difference, but looking "backward":

```
f'(x) ≈ [f(x) - f(x - h)] / h
```

This method has similar error characteristics to forward difference.

### Central Difference
The central difference method uses points on both sides of x:

```
f'(x) ≈ [f(x + h) - f(x - h)] / (2h)
```

This is generally more accurate than forward or backward differences, with truncation errors of order O(h²).

### Higher-Order Methods
For even better accuracy, we can use more points. For example, the five-point method:

```
f'(x) ≈ [-f(x+2h) + 8f(x+h) - 8f(x-h) + f(x-2h)] / (12h)
```

This achieves O(h⁴) accuracy at the cost of requiring more function evaluations.

### Practical Considerations
The choice of step size h is crucial. Too large, and the approximation is poor. Too small, and rounding errors become significant. A common approach is to choose h ≈ √ε where ε is the machine epsilon of the floating-point system.

## Automatic Differentiation (AD)
Unlike finite difference methods, automatic differentiation computes exact derivatives by systematically applying the chain rule to elementary operations and functions.

### Forward Mode
Forward mode AD propagates derivatives forward through a computation graph alongside regular values. For each intermediate value v, we track its derivative with respect to the input (called the dual number). If we represent this as a pair (v, v'), the chain rule gives us rules for operations:

```
Addition: (a, a') + (b, b') = (a + b, a' + b')
Multiplication: (a, a') * (b, b') = (a*b, a'*b + a*b')
```

This mode is efficient for functions with few inputs and many outputs.

### Reverse Mode
Reverse mode AD (also called backpropagation in machine learning) works backwards from outputs to inputs. It first computes the forward pass storing intermediate values, then propagates derivatives backward. This mode is more efficient for functions with many inputs and few outputs, making it popular in neural networks.

### Concrete Example: Computing d/dx[x * sin(x)]
Let's walk through how forward mode AD computes this derivative:

1. Define computation graph:
   ```
   v₁ = x            // Input
   v₂ = sin(x)       // Sine operation
   v₃ = v₁ * v₂      // Multiplication (final output)
   ```

2. Track values and derivatives:
   ```
   v₁ = (x, 1)       // The derivative of x with respect to x is 1
   v₂ = (sin(x), cos(x))  // The derivative of sin(x) is cos(x)
   v₃ = (x * sin(x), 1 * sin(x) + x * cos(x))
   ```

At x = π:
```
v₁ = (π, 1)
v₂ = (0, -1)        // sin(π) = 0, cos(π) = -1
v₃ = (0, -π)        // Exact result!
```

### Pitfalls and Limitations of AD

1. Memory Usage
   - Reverse mode requires storing all intermediate values
   - Can be problematic for deep computation graphs
   - Particularly challenging in deep learning with large models

2. Non-Differentiable Operations
   - Control flow (if statements, loops)
   - Integer operations
   - Discrete operations (floor, ceil, round)
   - Requires special handling or may produce incorrect results

3. Implementation Complexity
   - Handling higher-order derivatives
   - Dealing with undefined derivatives
   - Supporting custom operations
   - Corner cases in mathematical operations

4. Performance Overhead
   - Memory allocations
   - Additional function calls
   - Graph building and manipulation
   - Can be significant for simple functions

Despite these limitations, AD remains the method of choice for many applications, particularly in machine learning, due to its exactness and scalability to large problems.