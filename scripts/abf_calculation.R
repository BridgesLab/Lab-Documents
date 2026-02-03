#' Calculate Wakefield's Approximate Bayes Factor (ABF)
#'
#' This function computes the Approximate Bayes Factor (ABF) for a single parameter
#' assuming a normal prior and normal likelihood. It compares the null hypothesis
#' (beta = 0) to the alternative hypothesis (beta != 0).
#'
#' @param beta Numeric. The estimated effect size (beta hat).
#' @param se Numeric. The standard error of the estimated effect size.
#' @param W Numeric. The prior variance of the effect size (must be > 0).
#'
#' @return A numeric value representing the Approximate Bayes Factor (BF10).
#'         Values > 1 favor the alternative hypothesis; values < 1 favor the null.
#'
#' @examples
#' # Calculate ABF for beta=0.12, se=0.04, W=0.16
#' calculate_abf(beta = 0.12, se = 0.04, W = 0.16)
#'
#' @export
calculate_abf <- function(beta, se, W) {
  # Validate inputs
  if (any(se <= 0)) stop("Standard error (se) must be positive.")
  if (any(W < 0)) stop("Prior variance (W) must be non-negative.")

  # Calculate variances
  V <- se^2
  
  # Calculate ABF using the simplified form
  # ABF = sqrt(V / (V + W)) * exp( (beta^2 / 2) * (1/V - 1/(V + W)) )
  
  abf <- sqrt(V / (V + W)) * exp((beta^2 / 2) * (1 / V - 1 / (V + W)))
  
  return(abf)
}

#' Calculate Posterior Probability of Association (PPA)
#'
#' This function converts a Bayes Factor into a posterior probability given a
#' specific prior probability of the alternative hypothesis.
#'
#' @param abf Numeric. The Bayes Factor (BF10).
#' @param prior_prob Numeric. The prior probability that the alternative hypothesis
#'        is true (pi). Must be between 0 and 1.
#'
#' @return A numeric value representing the posterior probability (PPA).
#'
#' @examples
#' # Calculate Posterior for ABF=50 and a prior probability of 5%
#' calculate_posterior(abf = 50, prior_prob = 0.05)
#'
#' @export
calculate_posterior <- function(abf, prior_prob) {
  # Validate inputs
  if (any(prior_prob < 0 | prior_prob > 1)) {
    stop("Prior probability must be between 0 and 1.")
  }
  if (any(abf < 0)) stop("Bayes Factor (abf) must be non-negative.")
  
  # Calculate Posterior Odds: ABF * (prior / (1 - prior))
  prior_odds <- prior_prob / (1 - prior_prob)
  posterior_odds <- abf * prior_odds
  
  # Convert Odds to Probability: Odds / (1 + Odds)
  ppa <- posterior_odds / (1 + posterior_odds)
  
  return(ppa)
}

#' Calculate Directional ABF
#'
#' @param beta Estimated effect size
#' @param se Standard error
#' @param W Prior variance
#' @param direction The alternative hypothesis: "two.sided", "less" (<0), or "greater" (>0)
#'
calculate_abf_directional <- function(beta, se, W, direction = "two.sided") {
  
  # 1. Calculate Standard Two-Sided ABF
  V <- se^2
  abf_two_sided <- sqrt(V / (V + W)) * exp((beta^2 / 2) * (1 / V - 1 / (V + W)))
  
  if (direction == "two.sided") {
    return(abf_two_sided)
  }
  
  # 2. Calculate Posterior Parameters (Shrinkage)
  r <- W / (V + W)               # Shrinkage factor
  mu_post <- r * beta            # Posterior Mean
  var_post <- r * V              # Posterior Variance
  sd_post <- sqrt(var_post)
  
  # 3. Calculate Area in the Direction of Interest (using pnorm)
  # We test the area relative to 0
  if (direction == "less") {
    # Area of posterior below 0
    area <- pnorm(0, mean = mu_post, sd = sd_post)
  } else if (direction == "greater") {
    # Area of posterior above 0
    area <- 1 - pnorm(0, mean = mu_post, sd = sd_post)
  } else {
    stop("Direction must be 'two.sided', 'less', or 'greater'")
  }
  
  # 4. Apply Directional Adjustment
  # BF_dir = 2 * BF_two_sided * Probability_of_direction
  abf_dir <- 2 * abf_two_sided * area
  
  return(abf_dir)
}

# --- Example Usage based on your scenario ---
# You can uncomment the lines below to run the specific example
#
# my_beta  <- 0.12
# my_se    <- 0.04
# my_W     <- 0.16
# my_prior <- 0.05
#
# my_abf <- calculate_abf(my_beta, my_se, my_W)
# print(paste("ABF:", my_abf))
#
# my_ppa <- calculate_posterior(my_abf, my_prior)
# print(paste("Posterior Probability:", my_ppa))