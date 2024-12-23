# Bayesian Two-Component Normal Mixture

Imagine you manage a **manufacturing process** where the final measured feature (e.g., weight, height, or thickness) can come from **two distinct production lines**. You suspect each production line has its own mean value and variance, but you're unsure which item came from which line.

These scripts implement:
- **Metropolis-Hastings (MH)**: A generic MCMC method that proposes new parameters and accepts/rejects them based on a ratio of likelihoods.  
- **Gibbs Sampling**: A special MCMC method that sequentially updates each parameter from its conditional distribution.

By running these algorithms, you can infer:

1. **$\lambda_1, \lambda_2$**: The mean of each production line (or “component”).  
2. **$\sigma^2$**: The variance common to both lines (in this example).  
3. **$p_1$**: The probability of an item belonging to the first production line.

This helps you **quantify** the proportion of products from each line and **identify** differences in mean. Armed with this knowledge, you can **optimize** the lines, detect if one line is producing out-of-spec items, or determine if mixing lines is beneficial.

---

## Overview

This repository demonstrates how to **estimate the parameters** of a two-component normal mixture model using two different Bayesian MCMC approaches:

1. **Metropolis-Hastings (MH)**
2. **Gibbs Sampling**

Each script handles:
- Parameter initialization
- MCMC iterations
- Diagnostic plotting
- Summary statistics

Consider a manufacturing process with **two production lines**, each with a different average output measurement. You collect samples without labeling which line they came from. The goal is to **cluster** items into their respective lines and estimate each line’s mean and the mixture proportion.

---

## Files

1. **`bimodal_mixture_mh`**  
   - Implements a Metropolis-Hastings sampler.  
   - Demonstrates proposing new parameter values and deciding on acceptance/rejection based on log-likelihood ratios.

2. **`bimodal_mixture_gibbs`**  
   - Implements a Gibbs sampler, which updates each parameter (or group allocation) from its conditional distribution.  
   - Often more efficient for models with convenient conditional distributions.

---

## Interpreting Results

- **$\lambda_1, \lambda_2$**: Means of each normal component.  
- **$\sigma^2$**: Common variance (assuming both lines share the same variance in this example).  
- **$p_1$**: Proportion of items belonging to the first line.

The scripts produce:
- **Trace plots**: Show the chain’s evolution, indicating if convergence has been reached.  
- **Posterior histograms**: Visualize the distribution of each parameter.  
- **ACF (Autocorrelation)**: Reveals if the chain needs more thinning or a longer run.

---

## Customization

- Change the prior assumptions or the model structure (e.g., separate variances for each component).  
- Adjust bin widths in histograms for better visual clarity.  
- Incorporate a more formal prior distribution for the variance, if needed (e.g., an Inverse-Gamma prior in a fully conjugate approach).


