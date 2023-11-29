X <- read.csv("x.csv")
AF <- read.csv("af.csv")
N <- nrow(X)
J <- ncol(X)
#X <- X[1:40, 1:10]
#AF_n <- AF_n[1:40]
contextIRT <- function() {
    for (i in 1:N) {
        OA[i] ~ dcat(lambda_OA)
        for (j in 1:J) {
            eff_theta[i, j] <- (min(OA[i] * m[1], AF[i] * m[2]) - b[j]) - 1

            pi[i, j] <- 1 / (1 + exp(-eff_theta[i, j]))
            x[i, j] ~ dbern(pi[i, j])
        }
    }
    for (j in 1:J) {
        b[j] ~ dnorm(1,0.01)
    }
    for (i in 1:2) {
        m[i] ~ dnorm(1, 0.1);T(0, )
    }
    lambda_OA ~ ddirch(c(2, 4))
}
AF_n <- AF$af
dat <- list(x = X, AF = AF_n, N = N, J = J)
dat_prior <- list(x = X, AF = AF_n, N = 0, J = J)
params <- c("m", "b", "OA", "lambda_OA")
ini <- NULL
library(R2jags)
bnfit <- jags(
    data = dat, model.file = contextIRT, parameters.to.save = params, inits = ini,
    n.chains = 3, n.iter = 5000, n.burnin = 1000,
)

bnfit

(((bnfit$BUGSoutput$summary[109:110, 2]^-2) - (prior_bn$BUGSoutput$summary[18:19, 2]^-2)) / ((bnfit$BUGSoutput$summary[109:110, 2]^-2))) * 100

prior_bn <- jags(
    data = dat_prior, model.file = contextIRT, parameters.to.save = params, inits = ini,
    n.chains = 3, n.iter = 5000, n.burnin = 1000, DIC = FALSE
)

bnfit$BUGSoutput$summary[, 2]^-2
plot(bnfit)
library(bayesplot)
library(mcmcplots)
denplot(as.mcmc(bnfit), c("b"))
library(coda)
bn_mc <- as.mcmc(bnfit)
plot(bn_mc)
bn_mc
autocorr.plot(bn_mc)
library(bayesplot)
library(CalvinBayes)
diag_mcmc(bn_mc, par= "m[1]")
