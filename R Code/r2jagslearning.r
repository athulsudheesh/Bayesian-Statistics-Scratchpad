library(R2jags)
library(rjags)
n.sim <- 100
set.seed(123)
x1 <- rnorm(n.sim, mean = 5, sd = 2)
x2 <- rbinom(n.sim, size = 1, prob = 0.3)
e <- rnorm(n.sim, mean = 0, sd = 1)
b1 <- 1.2
b2 <- -3.1
a <- 1.5
y <- a + b1 * x1 + b2 * x2 + e
N <- nrow(sim.dat)
bayes.mod <- function() {
    for (i in 1:N) {
        y[i] ~ dnorm(mu[i], tau)
        mu[i] <- alpha + beta1 * x1[i] + beta2 * x2[i]
    }
    alpha ~ dnorm(0, .01)
    beta1 ~ dunif(-100, 100)
    beta2 ~ dunif(-100, 100)
    tau ~ dgamma(.01, .01)
}

sim.dat <- data.frame(y, x1, x2)

sim.dat.jags <- list("y", "x1", "x2", "N")
bayes.mod.params <- c("alpha", "beta1", "beta2")
bayes.mod.inits <- function() {
    list("alpha" = rnorm(1), "beta1" = rnorm(1), "beta2" = rnorm(1))
}

bayes.mod.fit <- jags(data = sim.dat.jags, inits = bayes.mod.inits,
   parameters.to.save = bayes.mod.params, n.chains = 3, n.iter = 2000,
   n.burnin = 1000, model.file = bayes.mod)

rowSums(frac20$Q)

mcmc_model <- as.mcmc(bayes.mod.fit)
mean_mcmc <- (mcmc_model[[1]] + mcmc_model[[2]] + mcmc_model[[3]])/3

mean_mcmc[sample(nrow(mean_mcmc), size = 10),]
jags.samples(mcmc_model,c("alpha"), n.iter = 10, force.list=TRUE)
mcmc_model
library(runjags)
read.jagsfile(bayes.mod)
run.jags(bayes.mod.fit, sample=100)
