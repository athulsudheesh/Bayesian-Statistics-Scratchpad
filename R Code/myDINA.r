library(R2jags)
library(CDM)
data(data.fraction1)
x <- data.matrix(data.fraction1$data)
q <- data.matrix(data.fraction1$q.matrix)
N <- nrow(x)
K <- ncol(q)
J <- nrow(q)

din.model <- function() {
    for (i in 1:N) {
        for (j in 1:J) {
            x[i, j] ~ dbern(pi[eta[i, j], j])
        }
    }

    for (i in 1:N) {
        for (j in 1:J) {
            for (k in 1:K) {
                w[i, j, k] <- pow(alpha[i, k], q[j, k])
            }
            eta[i, j] <- prod(w[i, j, ]) + 1
        }
    }
    for (i in 1:N) {
        for (k in 1:K) {
            alpha[i, k] ~ dcat(lambda[k, ])
        }
    }

    for (k in 1:K) {
        lambda[k, 1:2] ~ ddirch(c(1, 1))
    }

    for (j in 1:J) {
        pi[1, j] ~ dbeta(5, 20)
        pi[2, j] ~ dbeta(20, 5)
    }
}

model_inits <- NULL
sim.dat <- data.frame(x)
sim.dat.jags <- list("x", "q", "N", "J", "K")
pre.parameters <- c("pi", "alpha", "lambda")

dina_fit <- jags(
    data = sim.dat.jags, parameters.to.save = pre.parameters, model.file = din.model,
    n.chains = 2, n.iter = 1000, inits = model_inits
)

model_inits <- NULL
pre.sim <- jags(
    data = jags.data, inits = jags.inits,
    parameters.to.save = pre.parameters, model.file = DINA, n.chains = 2, n.iter = 1000
)

pik <- NULL
for (j in 1:J) {
    pik[j, 1] ~ rbeta(5, 20)
    pik[j, 2] ~ rbeta(20, 5)
}
