# Bayesian Logistic Regression on Canine Training Data

Imagine you are working at a **canine training center**. You have 30 dogs, each undergoing 25 training trials to learn a specific task (e.g., sniffing out contraband, performing agility runs, etc.). In each trial, the dog’s performance is recorded as a binary outcome: **1 if the dog succeeds, 0 if it fails**.

You suspect that:
- **Previous successes** might increase the chance of success in the next trials (positive reinforcement).
- **Previous failures** might either motivate the dog to improve or discourage it, depending on the training methods.

To quantify how past successes and failures impact the probability of success in a future trial, you run a **Bayesian logistic regression** model. The parameters:
- **$\alpha$** represents the contribution to log-odds from the number of previous successes.
- **$\beta$** represents the contribution to log-odds from the number of previous failures.

Using the Metropolis-Hastings algorithm, you sample from the posterior distribution of \(\alpha\) and \(\beta\). You can then use these estimates for better-informed adjustments to your training protocols. For instance, if \(\alpha\) is strongly positive, you can place more emphasis on building on successes. If \(\beta\) is highly negative, it might indicate that dogs become discouraged after repeated failures, suggesting a need to modify the training approach.

## Overview
This repository contains two R scripts that demonstrate a **Bayesian Logistic Regression** approach using **Metropolis-Hastings** sampling. The main objective is to analyze whether past successes and failures in a sequence of training trials affect future success probabilities.

## Professional Problem
In a canine training center, each dog undergoes a sequence of binary-outcome trials (success/failure). We hypothesize that the dog's success odds may depend on both the number of previous successes and previous failures. Understanding these dynamics helps refine training interventions.

## Scrpts and Roles
1. **bayesian_logistic_data**  
   - **Role**: Loads and structures the binary outcome data (30 dogs, each with 25 trials).  
   - Defines the custom log-likelihood function (`LogLikelihood`) for the Bayesian logistic model.

2. **bayesian_logistic_mh**  
   - **Role**: Implements the Metropolis-Hastings algorithm to sample from the posterior distributions of the logistic regression parameters:  
     - **alpha**: Effect of past successes on current success log-odds  
     - **beta**: Effect of past failures on current success log-odds  
   - Includes various diagnostic plots (trace plots, densities, autocorrelation) and calculates credible intervals for the parameters.


## Results
- **Posterior Means**  
  - The scripts print the estimated mean values for **alpha** and **beta**. These provide an average effect of previous successes/failures on the log-odds of success.
- **Trace Plots**  
  - Show how the Markov Chain progresses over iterations, helping assess convergence.  
- **Density Plots**  
  - Show the posterior distribution of each parameter, giving insight into the most probable values.  
- **Autocorrelation Function (ACF)**  
  - Helps diagnose if the chain exhibits strong autocorrelation, indicating the need for a larger number of iterations or thinning.

## Interpretation
- A **positive alpha** indicates that more prior successes lead to higher chances of success in subsequent trials (positive reinforcement).  
- A **negative beta** might mean that prior failures discourage the dog, reducing its probability of success in future trials.

