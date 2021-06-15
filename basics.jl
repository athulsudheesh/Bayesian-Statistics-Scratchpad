using Turing
using Distributions
using StatisticalRethinking
using StatsPlots
# A Bayesian Model to estimate the proportion of Water to Land 
# Suppose this is our data: W L W W L W L W 
dbinomial = Binomial(9,0.5) # 9 samples with success probability p =0.5

# What is the likelihood of 6 W's in 9 toeses
pdf(dbinomial,6)

# With Quadratic Approximation 
@model globethrowing(w,l) = begin 
    p ~ Uniform(0,1)    # Uniform Prior
    W ~ Binomial(w+l,p) # Binomial likelihood
end 

w = 6
l = 3
m = globethrowing(w,l)

#r = quap(m)
################################
pgrid = range(0, stop=1, length=10000)
prob_p = fill(1,10000)
prob_data = pdf.(Binomial.(9, pgrid),6)
posterior = prob_data .* prob_p
posterior = posterior / sum(posterior)
samples = sample(pgrid, Weights(posterior), length(pgrid))

p1 = density(samples, legend = false, 
        xlabel = " Proportion Water", 
        ylabel = " Density", 
        grid = false, color=:red,
        title = " Sample from posterior", framestyle=:box)

p2 = scatter(samples, legend = false, 
        markerstrokewidth=0, alpha=0.25, 
        xlabel = "Proportion Water", 
        ylabel = "Sample Number", grid=false, 
        title = " Density of the Sample", framestyle=:box)
plot(p1,p2, size=(600,300))
savefig("posterior.png")