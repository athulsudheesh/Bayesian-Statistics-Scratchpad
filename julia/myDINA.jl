using Turing
using LazyArrays
using StatsPlots
using Distributions
using CDMrdata
data = Matrix(load_data("fraction.subtraction.data"))
q_mat = Matrix(load_data("fraction.subtraction.qmatrix"))

@model function DINA(x,q)
    N,J = size(x)
    _,K = size(q)
    Pi = Matrix{Float64}(undef, 2,J)
    λ = Matrix{Vector{Float64}}(undef, N,K)
    α = Matrix{Int}(undef, N,K)
    η = Matrix{Int64}(undef, N,J)
    for  j in 1:J
        Pi[1,j] ~ Beta(5,20)
        Pi[2,j] ~ Beta(20,5)
    end
    for i in 1:N
        for k in 1:K
            λ[i,k] ~ Dirichlet([1,1])
            α[i,k] ~ Categorical(λ[i,k])
        end
    end

    for i in 1:N
        for j in 1:J
            # η[i,j] will be 0/1, so to make it indexable
            # adding 1 to it
            # similarly categories for α[i,:] will be 1/2
            # but we need them as boolean (0/1) so - 1
            η[i,j] = prod((α[i,:] .- 1).^q[j,:]) + 1
            x[i,j] ~ Bernoulli(Pi[η[i,j],j]) 
        end
    end
end



# subsetting the data for faster debugging 
x = data
q = q_mat
ch = sample(DINA_faster(x,q),IS(),
        MCMCThreads(),1000,2, progress= true)
using DataFrames

chd = DataFrame(summarize(ch))
chd[2:2:20,:]
x = data[1:30,1:5]
q = q_mat[1:5,1:2]
N,J = size(x)
_,K = size(q)
Pi = Matrix{Float64}(undef, 2,J)
λ = Matrix{Vector{Float64}}(undef, N,K)
α = Matrix{Int}(undef, N,K)
η = Matrix{Int64}(undef, N,J)
for  j in 1:J
    Pi[1,j] = rand(Beta(5,20))
    Pi[2,j] = rand(Beta(20,5))
end

for i in 1:N
    for k in 1:K
        λ[i,k] = rand(Dirichlet([1,1]))
        α[i,k] = rand(Categorical(λ[i,k]))
    end
end

for i in 1:N
    for j in 1:J
        η[i,j] = prod((α[i,:] .- 1).^q[j,:])
        x[i,j] = rand(Bernoulli(Pi[η[i,j]+1,j])) 
    end
end

rand.(Bernoulli.(Pi[η.+1,]))

@model function DINA_faster(x,q)
    N,J = size(x)
    _,K = size(q)
    Pi = Matrix{Float64}(undef, 2,J)
    λ = Matrix{Vector{Float64}}(undef, N,K)
    α = Matrix{Int}(undef, N,K)
    η = Matrix{Int64}(undef, N,J)

    for  j in 1:J
        Pi[1,j] ~ Beta(5,20)
        Pi[2,j] ~ Beta(20,5)
    end
    for i in 1:N
        for k in 1:K
            λ[i,k] ~ Dirichlet([1,1])
        end
    end
    α ~ arraydist(LazyArray(@~ Categorical.(λ)))  
    for i in 1:N
        for j in 1:J
            η[i,j] = prod((α[i,:] .- 1).^q[j,:])
        end
    end
    x ~ arraydist(LazyArray(@~ Bernoulli.(Pi[η.+1,])))
end

≈