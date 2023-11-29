library(R2jags)
library(CDM)
data(data.fraction1) #Read the fraction subtraction
data and Q-matrix.
Y <- data.matrix(data.fraction1$data); 
Q <- data.matrix(data.fraction1$q.matrix);
gapp <- function(q){
    K <- ncol(q)
    q.entries <- as.list(1:K)
    for(k in 1:K){
        q.entries[[k]] <- sort(unique(c(0,
        q[,k])))}
attr.patt <- as.matrix(expand.grid(q.entries))}
all.patterns <- gapp(Q);

DINA <- function(){
for (n in 1:N){
    for (i in 1:I){
        for (k in 1:K){
            w[n,i,k] <- pow(alpha[n,k], Q[i,k])
        }
        eta[n,i] <- prod(w[n,i,1:K])
        p[n,i] <- pow((1-s[i]), eta[n,j]*pow(g[i],(1-eta[n,i])))
    Y[n,i] ~ dbern(p[n,i])
    }

    for (k in 1:K){
        alpha[n,k] <- all.patterns[c[n],k]
    }
    c[n] ~ dcat(pai[1:C])
}
pai[1:C] ~ ddirch(delta[1:C])
for (i in 1:I){
    s[i] ~ dbeta(1,1)
    g[i] ~ dbeta(1,1) %_% T(, 1-s[i])
}
# the posterior predictive model checking 
for (n in 1:N){
    for (i in 1:I){
        teststat[n,i] <- pow(Y[n,i] - p[n,i],2) /(p[n, i] *(1 - p[n, i]))
        Y_rep[n,i] ~ dbern(p[n,i])

        teststat_rep[n,i] <- pow(Y_rep[n, i] - p[n, i],2)/(p[n, i]* (1 - p[n, i]))
    }}
   teststatsum <- sum(teststat[1:N, 1:I])
    teststatsum_rep <- sum(teststat_rep[1:N, 1:I])
    ppp <- step(teststatsum_rep - teststatsum) 
}
library(R2jags)
N = nrow(Y) #as an exercise, N ¼ 100 can be used to reduce the
time cost
I = nrow(Q)
K = ncol(Q)
C = nrow(all.patterns)
delta = rep(1, C)
jags.data = list("N", "I", "K", "Y", "Q", "C", "all.patterns","delta" )
pre.parameters <- c("s", "g")
jags.inits <- NULL
pre.sim <- jags(data = jags.data, inits = jags.inits,
parameters.to.save = pre.parameters, model.file = DINA, n.chains = 2, n.iter = 1000)


DINA <- function(){
  for (n in 1:N){
    for (i in 1:I){
        for (k in 1:K)
        {w[n,i,k] <- pow(alpha[n,k], Q[i,k])}
        eta[n,i] <- prod(w[n,i,1:K])
        p[n,i] <- g[i] + (1 - s[i] - g[i]) * eta[n,i]
        Y[n,i] ~ dbern(p[n,i])
    }
    for (k in 1:K){alpha[n,k] <-all.patterns[c[n],k]}
    c[n] ~ dcat(pai[1:C])
  }
  pai[1:C] ~ ddirch(delta[1:C])
  for (i in 1:I){
    s[i] ~ dbeta(1, 1)
    g[i] ~ dbeta(1, 1) %_% T(, 1-s[i])
  }
  }

