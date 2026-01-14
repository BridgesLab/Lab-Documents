#' Bayesian one-sample t-test with Jeffreys prior
#'
#' Performs a Bayesian one-sample t-test assuming unknown mean and variance
#' with a Jeffreys prior. Returns posterior probability statements and
#' a Student-t posterior for the mean.
#'
#' @param x Numeric vector of observations
#' @param mu0 Null/reference value for the mean
#' @param alternative Character string specifying the alternative hypothesis.
#'   One of "greater", "less", or "two.sided"
#' @param compute_bf Logical; compute Bayes factor for point null mu = mu0
#'
#' @return An object of class \code{htest} with Bayesian extensions
#'
#' @details
#' The posterior distribution of the mean is:
#' \deqn{
#' \mu \mid x \sim t_{n-1}(\bar{x}, s / \sqrt{n})
#' }
#' where \eqn{s^2} is the sample variance.
#'
#' @examples
#' x <- rnorm(20, mean = 0.5)
#' res <- bayes_ttest_jeffreys_one_sample(x, mu0 = 0)
#' res$posterior_probability
#'
bayes_ttest_jeffreys_one_sample <- function(
    x,
    mu0 = 0,
    alternative = c("greater", "less", "two.sided"),
    compute_bf = TRUE
) {
  
  alternative <- match.arg(alternative)
  stopifnot(is.numeric(x))
  
  n <- length(x)
  xbar <- mean(x)
  s <- sd(x)
  
  df <- n - 1
  scale <- s / sqrt(n)
  
  ## Posterior probabilities
  if (alternative == "greater") {
    post_prob <- 1 - pt((mu0 - xbar)/scale, df)
  } else if (alternative == "less") {
    post_prob <- pt((mu0 - xbar)/scale, df)
  } else {
    post_prob <- 2 * min(
      pt((mu0 - xbar)/scale, df),
      1 - pt((mu0 - xbar)/scale, df)
    )
  }
  
  ## Bayes factor for point null mu = mu0
  bf10 <- if (compute_bf) {
    dt((xbar - mu0)/scale, df) /
      dnorm(xbar, mean = mu0, sd = scale)
  } else NA
  
  posterior_dist <- list(
    family = "student_t",
    df = df,
    location = xbar,
    scale = scale
  )
  
  structure(
    list(
      statistic = c(t = (xbar - mu0) / scale),
      parameter = c(df = df),
      estimate = c(mean = xbar),
      p.value = NA_real_,
      conf.int = NULL,
      alternative = alternative,
      method = "Bayesian one-sample t-test (Jeffreys prior)",
      data.name = deparse(substitute(x)),
      posterior_probability = post_prob,
      posterior_distribution = posterior_dist,
      bayes_factor_10 = bf10
    ),
    class = "htest"
  )
}
