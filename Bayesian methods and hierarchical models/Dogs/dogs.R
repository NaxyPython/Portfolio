###############################################################################
# Script: bayesian_logistic_data
# Description: Load binary outcome data and define the log-likelihood function 
# for a Bayesian logistic regression using Metropolis-Hastings.
###############################################################################

# Number of dogs (subjects) and trials
Ndogs <- 30
Ntrials <- 25

# Binary outcome matrix (30 x 25): 1 = success, 0 = failure
Y <-
  structure(c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
              0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
              0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
              0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
              0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 
              0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 
              0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 
              1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 
              1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 
              1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 
              0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 
              0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 
              1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 
              0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 
              0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
              0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 
              0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 
              1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 
              1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),.Dim = c(Ndogs, Ntrials)
)

# Log-likelihood function for our logistic model
LogLikelihood <- function(alpha, beta, Y) {
  logLikeValue <- 0
  for (i in 1:Ndogs) {
    for (j in 2:Ntrials) {
      # Number of successes in previous trials for dog i
      successes_so_far <- sum(Y[i, 1:(j - 1)])
      # We assume alpha * (number of previous successes) + beta * (previous failures)
      # as the linear predictor in the logit scale
      logit_p <- alpha * successes_so_far + beta * ( (j - 1) - successes_so_far )
      p <- plogis(logit_p)  # logistic transform
      # Accumulate log-likelihood
      logLikeValue <- logLikeValue + Y[i, j] * log(p) + (1 - Y[i, j]) * log(1 - p)
    }
  }
  return(logLikeValue)
}

###############################################################################
# Script: bayesian_logistic_mh
# Description: Metropolis-Hastings sampler for a Bayesian logistic model 
# using the data and log-likelihood from bayesian_logistic_data
###############################################################################

# Make sure to source the data script if not already loaded:
# source("bayesian_logistic_data.R")

# Initial parameter guesses
alpha <- -1
beta  <- -1

# Number of MCMC iterations
n_iterations <- 10000

# Vectors to store MCMC chains
chain_alpha <- numeric(n_iterations)
chain_beta  <- numeric(n_iterations)

# Metropolis-Hastings algorithm
set.seed(123)  # For reproducibility

for (i in 1:n_iterations) {
  # Propose new parameters from a normal distribution
  proposal_alpha <- rnorm(1, mean = alpha, sd = 0.05)
  proposal_beta  <- rnorm(1, mean = beta,  sd = 0.05)
  
  # Calculate log acceptance ratio
  log_accept_ratio <- LogLikelihood(proposal_alpha, proposal_beta, Y) - 
    LogLikelihood(alpha, beta, Y)
  
  # If log_accept_ratio is not finite, treat as -Inf (reject)
  if (is.nan(log_accept_ratio) || is.na(log_accept_ratio)) {
    log_accept_ratio <- -Inf
  }
  
  # Accept or reject
  if (log(runif(1)) < log_accept_ratio) {
    alpha <- proposal_alpha
    beta  <- proposal_beta
  }
  
  # Store current parameter values
  chain_alpha[i] <- alpha
  chain_beta[i]  <- beta
}

# -------------------- RESULTS AND VISUALIZATIONS -----------------------------

# Basic density plots
plot(density(chain_alpha), main="Density of Alpha", xlab="Alpha", ylab="Density")
abline(v=mean(chain_alpha), col="red")

plot(density(chain_beta), main="Density of Beta", xlab="Beta", ylab="Density")
abline(v=mean(chain_beta), col="red")

# Using ggplot2 for improved density plots
library(ggplot2)

# Density for Alpha
ggplot(data.frame(Alpha = chain_alpha), aes(x = Alpha)) +
  geom_density(fill = "blue", alpha = 0.5) +
  geom_vline(xintercept = mean(chain_alpha), color = "red", linetype = "dashed", linewidth=1) +
  labs(title = "Density of Alpha", x = "Alpha", y = "Density") +
  theme_minimal()

# Density for Beta
ggplot(data.frame(Beta = chain_beta), aes(x = Beta)) +
  geom_density(fill = "green", alpha = 0.5) +
  geom_vline(xintercept = mean(chain_beta), color = "red", linetype = "dashed", linewidth=1) +
  labs(title = "Density of Beta", x = "Beta", y = "Density") +
  theme_minimal()

# Trace plots
plot(chain_alpha, type = "l", main = "Trace of Alpha", xlab = "Iteration", ylab = "Alpha")
abline(h=mean(chain_alpha), col="red")

plot(chain_beta, type = "l", main = "Trace of Beta", xlab = "Iteration", ylab = "Beta")
abline(h=mean(chain_beta), col="red")

# Trace plots with ggplot2
ggplot(data.frame(Iteration = 1:n_iterations, Alpha = chain_alpha), aes(x = Iteration, y = Alpha)) +
  geom_line(color="blue") +
  geom_hline(yintercept = mean(chain_alpha), color="red", linetype="dashed", size=1) +
  labs(title = "Markov Chain for Alpha", x = "Iteration", y = "Alpha") +
  theme_minimal()

ggplot(data.frame(Iteration = 1:n_iterations, Beta = chain_beta), aes(x = Iteration, y = Beta)) +
  geom_line(color="green") +
  geom_hline(yintercept = mean(chain_beta), color="red", linetype="dashed", size=1) +
  labs(title = "Markov Chain for Beta", x = "Iteration", y = "Beta") +
  theme_minimal()

# Autocorrelation
acf(chain_alpha, main="ACF for Alpha")
acf(chain_beta, main="ACF for Beta")

library(ggfortify)
autoplot(acf(chain_alpha, plot=FALSE), main="Autocorrelation for Alpha")
autoplot(acf(chain_beta, plot=FALSE), main="Autocorrelation for Beta")

# Posterior summaries
alpha_mean <- mean(chain_alpha)
beta_mean  <- mean(chain_beta)
cat("Estimated mean for alpha:", alpha_mean, "\n")
cat("Estimated mean for beta :", beta_mean,  "\n")

# 95% Credible Intervals
alpha_ci <- quantile(chain_alpha, probs = c(0.025, 0.975))
beta_ci  <- quantile(chain_beta,  probs = c(0.025, 0.975))

cat("95% Credible Interval for alpha:", alpha_ci, "\n")
cat("95% Credible Interval for beta :", beta_ci,  "\n")
