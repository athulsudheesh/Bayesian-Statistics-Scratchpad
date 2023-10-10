library(R2jags)

ctt <- function() {
    for (i in 1:n) {
        T[i] ~ dnorm(mu.T, tau.T)
        x[i] ~ dnorm(T[i], tau.E)
    }

    tau.T <- 1/sigma.squared.T
    tau.E <- 1/sigma.squared.E

    sigma.squared.E <- 16 
    sigma.squared.T <- 36
    mu.T <- 80
}

x = c(70,80,96)
dat <- data.frame(x)
n <- nrow(dat)
dat.jags <- list("n","x")
ctt.params <- c("T")
ctt.inits <- NULL

ctt.fit <- jags(data = dat.jags, inits = ctt.inits, parameters.to.save = ctt.params,
n.chains = 3, n.iter = 1000, n.burnin = 100, model.file = ctt)

library(bayesplot)
library(coda)

ctt_mcmc <- as.mcmc(ctt.fit)
View(autocorr.plot(ctt_mcmc)) 
