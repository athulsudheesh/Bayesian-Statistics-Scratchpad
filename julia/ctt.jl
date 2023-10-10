using Turing
using LazyArrays
using StatsPlots
# Bayesian Psychometric Modeling
# Section 8.1.3.2, p.g. 162
@model function ctt(x)
    mu_T = 80
    # The definition for σ_T and σ_E are different compared to the example in the textbook
    # because in rjags dnorm accepts the mean and the precision (and not the sd directly)
    σ_T = 6
    σ_E = 4
    T ~ filldist(Normal(mu_T, σ_T), length(x))
    for i in 1:length(x)
    x[i] ~ Normal(T[i], σ_E)
    end
    return x
end

ctt_model = ctt([70, 80, 96])
c1 = sample(ctt_model, NUTS(), MCMCThreads(),100,2, discard_initial=500)

plot(c1)

using DataFrames
#arraydist(LazyArray(@~ Normal.(T,tau_E)))    T[i] ~ Normal(mu_T, tau_T)
missing_data = Vector{Missing}(missing, 3)
model_predict = ctt(missing_data)
posterior_check = predict(model_predict, c1)
describe(DataFrame(summarystats(posterior_check)))

autocorplot(c1)
# using ArviZ, ArviZPythonPlots
# begin 
#     plot_posterior(c1)
#     gcf()
# end

# ==========
# Section 8.2.3.2, p.g. 170
@model function ctt2(x)
    mu_T = 80
    # The definition for σ_T and σ_E are different compared to the example in the textbook
    # because in rjags dnorm accepts the mean and the precision (and not the sd directly)
    m, n = size(x)
    σ_T = 6
    σ_E = 4
    T ~ filldist(Normal(mu_T, σ_T), m,n)
    for i in 1:m
        for j in 1:n
            x[i,j] ~ Normal(T[i,j], σ_E)
        end
    end
    return x
end

obs = [ 80 77 80 73 73;
        83 79 78 78 77;
        85 77 88 81 80;
        76 76 76 78 67;
        70 69 73 71 77;
        87 89 92 91 87;
        76 75 79 80 75;
        86 75 80 80 82;
        84 79 79 77 82;
        96 85 91 87 90]
c2 = sample(ctt2(obs), NUTS(), MCMCThreads(),1000,2, discard_initial=500)
reshape(summarystats(c2)[:,2],10,5) # scores of each student for every test
mean(reshape(summarystats(c2)[:,2],10,5),dims=2) # mean score for a student 




# Section 8.3.3.3, p.g. 180
@model function ctt3(x)
    mu_T ~ Normal(80,10)
    # The definition for σ_T and σ_E are different compared to the example in the textbook
    # because in rjags dnorm accepts the mean and the precision (and not the sd directly)
    m, n = size(x)
    σ_T ~ InverseGamma(1,6)
    σ_E ~ InverseGamma(1,4)
    T ~ filldist(Normal(mu_T, σ_T), m,n)

    x ~ arraydist(LazyArray(@~ Normal.(T, σ_E)))
    return x
end
c3 = sample(ctt3(obs), NUTS(), MCMCThreads(),1000,2, discard_initial=500)
sum3 = summarystats(c3)
missing_data = Matrix{Missing}(missing, 10,5)
model_predict = ctt3(missing_data)

mean(reshape(summarystats(c3)[4:end,2],10,5),dims=2)

