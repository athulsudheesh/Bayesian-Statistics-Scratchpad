using StatsPlots
using Plots
using StatisticalRethinking
using CSV, DataFrames, DataFramesMeta
# Listing 4.1: Normal by addition 
pos1 = [sum(rand([1,-1],4)) for i in 1:1000]
pos2 = [sum(rand([1,-1],8)) for i in 1:1000]
pos3 = [sum(rand([1,-1],16)) for i in 1:1000]

p1 = density(pos1, title="4 steps")
p2 = density(pos2, title="8 steps")
p3 =density(pos3, title="16 steps")

plot(p1,p2,p3, legend=false,
        layout = @layout([a b c]),size=(800,350),
        xlabel="Position", ylabel = "Density", color=:black)
savefig("random_walks.png")

# Listing 4.3 Normal by Multiplication 
growth = [prod( 1 .+ rand([0,0.1],12)) for i in 1:10000]
density(growth)

# Listing 4.7 
d = CSV.read(sr_datadir("Howell1.csv"), DataFrame)
describe(d)
precis(d)
@df d cornerplot(cols(1:4), grid = false, compact=true,size=(800,800))
savefig("Howell-data.png")

d2 =  @where(d, :age .>= 18)
density(d2.height, xlabel="Height", ylabel="Density", label=false)
vline!([mean(d2.height)], label="Mean")
vline!([median(d2.height)], label="Median")
vline!([mode(d2.height)], label="Mode")

# Listing 4.12-4.13
fig1 = plot(p -> pdf(Normal(178, 20), p), 100:250, leg=false, title="prior mu")
fig2 = plot(p -> pdf(Uniform(0, 50), p), -10:60, leg=false, title="prior sigma")
plot(fig1, fig2, layout=(1, 2), size=(600,400))

# Listing 4.14

sample_μ = rand(Normal(178,20),10000)
sample_σ = rand(Uniform(0,50), 10000)
prior_h = rand.(Normal.(sample_μ,sample_σ))
density(prior_h, xlabel="Height", ylabel="Density", legend=false)