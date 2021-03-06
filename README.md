# Fri.jl

This repository contains a simple [Julia](https://julialang.org) implementation of the feature relevance bounds method. 

It exists a much more complete python version [here](https://github.com/lpfann/fri).
This is mostly a proof of concept and is missing features such as cross validation for hyper parameteres, regression and ordinal regression models and advanced statistics for feature classification.

# Quickstart
A runnable example is included in the example notebook.
```julia
include("src/Fri.jl")
```

    ┌ Info: Precompiling JuMP [4076af6c-e467-56ae-b986-b466b2749572]
    └ @ Base loading.jl:1273
    ┌ Info: Precompiling ECOS [e2685f51-7e38-5353-a97d-a921fd2c8199]
    └ @ Base loading.jl:1273
    Main.Fri



We generate dataset with 200 samples, 5 strongly relevant features, 4 weakly relevant features and 10 noise features (irrelevant).


```julia
X,y = Main.Fri.dataset.generate(200,d_rel=5,d_irrel=10,d_weak=4);
```


```julia
relev_bounds = Main.Fri.relevance_bounds(X,y)
```




    17×2 Array{Float64,2}:
      2.55727      2.55727  
      2.01039      2.01039  
      2.32116      2.32116  
      2.09897      2.09897  
      2.35608      2.35608  
     -3.85029e-12  2.22748  
     -3.8504e-12   2.22748  
      0.0948441    0.0948441
      0.100589     0.100589 
      0.156153     0.156153 
      0.0760626    0.0760626
      0.11897      0.11897  
      0.19504      0.19504  
      0.09535      0.09535  
      0.0669823    0.0669823
      0.22617      0.22617  
      0.0860516    0.0860516



## Minimal relevance for feature 1


```julia
relev_bounds[1,1]
```




    2.5572730462733446



## Maximal relevance for feature 1


```julia
relev_bounds[1,2]
```




    2.557273051045558

