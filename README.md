# ECON753: Topics in Empirical Methods

**Instructor:** Charlie Murry  
**Contact:** ctmurry@umich.edu  
**Meeting Times:** M,W 1 - 2:30PM  
**Office Hours:** Tuesday, 230PM - 4PM  
**Course Website:** [https://github.com/charliemurry/micromethods/](https://github.com/charliemurry/micromethods/)  




This is a PhD level course in practical computational economics, targeted at students conducting applied research.

The course is based on some combination of 
- [Microeconometrics by Cameron and Trivedi](https://www.amazon.com/Microeconometrics-Methods-Applications-Colin-Cameron/dp/0521848059)
- [Elements of Statistical Learning by Hastie, Tibshirani, and Friedman](https://statweb.stanford.edu/~tibs/ElemStatLearn/)
- Other lectures borrowed/stolen from various sources
    - Bruce Hansen's [online text](https://www.ssc.wisc.edu/~bhansen/econometrics/)
    - Chris Conlon's  [micro-metrics](https://github.com/chrisconlon/micro-metrics) repo
    - Similar courses at Penn State (Paul Grieco and Mark Roberts) and Boston College (Rich Sweeney)
- [Numerical Methods in Economics by Ken Judd](https://www.amazon.com/Numerical-Methods-Economics-MIT-Press/dp/0262100711/)




## Grading

The only way to really internalize this stuff is to implement it yourself. Thus, a significant portion of the grade will be regular problem sets. The remainder of the grade will be a computational project.

#### Problem sets

- 3-4 problem sets
- 50% of grade
- all problem sets must be submitted through CANVAS
- you are allowed to work in groups of up to four, but each student must code up and submit their own problem set.

#### Final Project

50% of grade

Each student is expected to pick an empirical paper that estimates a theoretically derived model. Groups of two are permissible if the students desire. A theoretical model with only the core elements, maybe with a small twist, should be proposed and an empirical analog should be derived. The next step is to simulate a dataset with parameters from the proposed model. The final step is to write up the estimator and test it on the simulated dataset in a Monte Carlo exercise.  I hope this requirement will be useful for your future research. Feel encouraged to pick a model that is aligned with your
research interests.

The final write-up of the project should be about three pages, and no more than five pages. One to two pages are for the theoretical and empirical models, one page is for the estimator, and a page or two is for describing the results of the exercise. In addition, each student is expected to turn in code that can be run using a main script. You can use your language of choice, but keep in mind that my knowledge is limited to MATLAB or Julia.

There are important dates associated with the project. 

1. Submit a list of at least two potential projects. [date tbd]

2. Submit a draft of a write-up of the model and starting work on the code to simulate the model. [date tbd]

3. Submit the final project. [date tbd, end of semester]




## Topics to be covered in the course

1. Computation
- Root finding
- Optimization
- Differentiation
- Integration

2. Binary and Multivariate Discrete Choice
- probit
- logit
- multi-nomial logit
- BLP (1995) and Grieco, Murry, Sagl, and Pinkse (2024)

3. Bayesian Methods
- Gibbs Sampling
- Data augmentation
- Metropolis-Hastings

4. Dynamic Discrete Choice
- Rust (1987)
- Pakes (1985)
- Modern techniques using CCPs

5. Nonparametrics and Identification
- Density estimatation, k-NN, Kernels, Nadaraya-Watson
- Bootstrap and cross-validation.

6. Model Selection and Penalized Regression (if time allows)
- Ridge, Lasso, LAR, BIC, AIC