using Turing
using LazyArrays
using StatsPlots
using StatisticalRethinking;
using DataFrames
using Optim
using StatsBase
using RCall

R"""
data(data.ecpe, package="CDM")
X <- data.ecpe$data[,-1]
Q <- data.ecpe$q.matrix
""";
@rget X;
@rget Q;


function all_patterns(C,N)
    Matrix(transpose(hcat(collect.(reverse.(Iterators.product(fill(C,N)...))[:])...)))
end

function compute_η(A,Q)
    I = size(A)[1]
    J, K = size(Q)
    
    eta = typeof(A)(undef, I,J)
    for i in 1:I
        for j in 1:J 
            eta[i,j] = prod(A[i,:].^Q[j,:])
        end
    end
    return eta
end 

function generate_α(A, K)
    A[sample(begin:end, K), :]
end

@model function DINA(X_Matrix, Q_Matrix)
    I = size(X_Matrix)[1]
    J,K = size(Q_Matrix)
    
    s ~ filldist(Beta(1,1),J)
    g ~ arraydist(Truncated.(Beta(1,1), 0, 1 .- s))
    
    α ~ filldist(Bernoulli(),I,K)
    η = compute_η(α, Q_Matrix)
    
    p = Matrix{Float64}(undef, I,J)
    for i in 1:I
        for j in 1:J
            p[i,j] = g[j] + (1 - s[j] - g[j]) * η[i,j]
        end
    end
    
   X_Matrix ~ arraydist(Bernoulli.(p))
end
dina_model =DINA(Matrix(X), Matrix(Q))

ch1 = sample(dina_model,SMC(), MCMCThreads(),3000,3)

CSV.write("item_params.csv",r)

map_est = optimize(dina_model, MLE(), SimulatedAnnealing())

using CSV

