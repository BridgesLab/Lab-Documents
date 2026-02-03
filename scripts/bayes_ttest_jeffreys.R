# bayes_ttest_jeffrey.R

#' Bayesian two-sample t-test with Jeffreys prior
#'
#' @param group1 Numeric vector
#' @param group2 Numeric vector
#' @param delta0 Null value for mean difference
#' @param var.equal Logical; equal variances?
#' @param compute_bf Logical; compute Bayes factor?
#'
#' @return An object of class htest with Bayesian extensions
#'

bayes_ttest_jeffreys <- function(
  group1,
  group2,
  delta0 = 0,
  var.equal = FALSE,
  compute_bf = TRUE
) {

  stopifnot(is.numeric(group1), is.numeric(group2))

  n1 <- length(group1)
  n2 <- length(group2)

  m1 <- mean(group1)
  m2 <- mean(group2)

  s1 <- sd(group1)
  s2 <- sd(group2)

  delta_hat <- m1 - m2

  if (var.equal) {
    df <- n1 + n2 - 2
    sp2 <- ((n1 - 1)*s1^2 + (n2 - 1)*s2^2) / df
    scale <- sqrt(sp2 * (1/n1 + 1/n2))

    post_prob <- 1 - pt((delta0 - delta_hat)/scale, df)

    bf10 <- if (compute_bf) {
      dt(delta_hat/scale, df) /
        dnorm(delta_hat, mean = 0, sd = scale)
    } else NA

    method <- "Bayesian two-sample t-test (Jeffreys prior, equal variance)"

  } else {
    se1 <- s1^2 / n1
    se2 <- s2^2 / n2
    scale <- sqrt(se1 + se2)

    df <- (se1 + se2)^2 /
      (se1^2/(n1 - 1) + se2^2/(n2 - 1))

    post_prob <- 1 - pt((delta0 - delta_hat)/scale, df)

    bf10 <- NA

    method <- "Bayesian two-sample t-test (Jeffreys prior, unequal variance)"
  }

  posterior_dist <- list(
    family = "student_t",
    df = df,
    location = delta_hat,
    scale = scale
  )

  structure(
    list(
      statistic = c(t = delta_hat / scale),
      parameter = c(df = df),
      estimate = c(
        mean_group1 = m1,
        mean_group2 = m2,
        mean_difference = delta_hat
      ),
      p.value = NA_real_,
      conf.int = NULL,
      alternative = paste0("true difference in means is greater than ", delta0),
      method = method,
      data.name = "group1 and group2",
      posterior_probability = post_prob,
      posterior_distribution = posterior_dist,
      bayes_factor_10 = bf10
    ),
    class = "htest"
  )
}
