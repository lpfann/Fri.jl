module Fri
include("dataset.jl")
using JuMP
using ECOS
const solver = ECOS.Optimizer

export relevance_bounds, generate

function opt_model(X,y)
    n,d = size(X)
    m = Model(with_optimizer(solver,verbose=false))

    @variable(m, w[1:d])
    @variable(m, wprime[1:d])
    @variable(m, slack[1:n]);
    @variable(m, b);

    @constraint(m, w.<= wprime)
    @constraint(m, -w.<= wprime)
    @constraint(m, y.*(X*w .+ b) .>= 1 .- slack)
    @constraint(m, slack .>= 0)

    norm1 = @expression(m,sum(wprime))
    @objective(m, Min, norm1 + sum(slack) );
    m,wprime,slack
end

function relbound(X,y,l1,loss)
    n,d = size(X)
    m = Model(with_optimizer(solver, verbose=false))

    @variable(m, w[1:d])
    @variable(m, wprime[1:d])
    @variable(m, slack[1:n]);
    @variable(m, b);

    @constraint(m, w.<= wprime)
    @constraint(m, -w.<= wprime)
    @constraint(m, y.*(X*w .+ b) .>= 1 .- slack)
    @constraint(m, slack .>= 0)
    @constraint(m, sum(slack)<= loss)

    norm1 = @expression(m,sum(wprime))
    @constraint(m, norm1 <= l1)
    m,w, wprime,slack
end

function minrel(X,y,l1,loss, i)
    m, w, wprime,slack = relbound(X,y,l1,loss)
    #@constraint(m, w[i] <= wprime[i] )
    @objective(m, Min, wprime[i] );
    optimize!(m)
    objective_value(m)
end

function maxrel_signed(X,y,l1,loss, i,sign)
    m, w, wprime,slack = relbound(X,y,l1,loss)
    @constraint(m, wprime[i] <= sign*w[i] )
    @objective(m, Max, wprime[i] );
    m
end

function maxrel(X,y,l1,loss,i)
    pos = maxrel_signed(X,y,l1,loss,i,1)
    neg = maxrel_signed(X,y,l1,loss,i,-1)
    optimize!(pos)
    optimize!(neg)
    solved = pos,neg
    feasible =  [prob for prob in solved if termination_status(prob) !="INFEASIBLE"]
    return maximum(objective_value,feasible)
end

function compute_all_bounds(X,y,l1,loss)
    bounds = Array{Float64,2}(undef,size(X)[2],2)
    for i in 1:size(X)[2]
        bounds[i,1] = minrel(X,y,l1,loss,i)
        bounds[i,2] = maxrel(X,y,l1,loss,i)
    end
    bounds
end

function relevance_bounds(X,y)
    m,w,slack = opt_model(X,y);
    optimize!(m)  
    l1 = sum(value.(w))
    loss = sum(value.(slack))
    bounds = compute_all_bounds(X,y,l1,loss)
    bounds
end

end