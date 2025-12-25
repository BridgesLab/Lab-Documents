---
title: "Notes while learning Bayesian inference"
author: "Dave Bridges"
date: "2025-12-13"
editor: source
format: 
  html:
    toc: true
    toc-location: right
    keep-md: true
    code-fold: true
    code-summary: "Show the code"
    fig-path: "figures/"
theme: journal
bibliography: references.bib
execute:
  echo: true
  warning: false
---


::: {.cell}

```{.r .cell-code}
# hide this code chunk
#| echo: false
#| message: false

# defines the se function
se <- function(x) {
  sd(x, na.rm = TRUE) / sqrt(length(x))
}

#load these packages, nearly always needed
library(tidyverse)
library(knitr)

# sets maize and blue color scheme
color_scheme <- c("#00274c", "#ffcb05")
```
:::


## Purpose

These are notes as I work through and understand the notes from BIOSTAT 682

### Lecture 2: Single Parameter Models

The motivating example here is that there was an incidence of cancer wherein 8 cancers appeared out of a total of 145 people.  The question is whether this incidence is greater than the expected incidence of 4.458% from [@CancerStatisticsNCI2015]

Using the binomial distribution probability mass function for a binomial distribution

$$P(Y = y | n, \theta) = \binom{n}{y} \theta^y (1 - \theta)^{n-y}$$
In this nomenclature $\binom{n}{y}$ expands out to $\frac{n!}{y! \times (1-y)!}$ where $y$ is the number of successes, $n$ is the number of trials.  In the overall cuntion $\theta$ is the probability of success on each trial.  


This can also be denoted as $Y \sim \text{Binomial}(n, \theta)$ where $n$ is the number of trials and $\theta$ is the probability of success on each trial, Using this we can calculate the likelihood of observing 8 or more cancers out of 145 people given the expected incidence rate of 4.44% and some other probabilities

The hypothesis being tested are that:

- $H_A: \theta = 0.03$
- $H_B: \theta = 0.04$ 
- $H_C: \theta = 0.05$
- $H_D: \theta = 0.06$


In terms of prior probabilities, we can assign prior probabilities to each of the hypotheses above.  If we think that $H1$ is 50% likely, and $H_{A-D}$ are equally likely after that.

Likelihoods are calculated from the probability mass function for the binomal function $Y \sim \text{Binomial}(n, \theta)$ 

 can be calculated for each tested hypothesis ($H_x$ in comparason to all possible hypotheses $Hi$) via $P(H_x \mid y_o = 8) = \frac{P(H_x) \times, P(y_o = 8 \mid H_x)}{\sum_{i=A}^{D} P(H_i) \times, P(y_o = 8 \mid H_i)}$.  In simplified terms this is the prior probability of the hypothesis, times its likelihood divided by the sum of all prior probabilities times their likelihoods.


::: {.cell}

```{.r .cell-code}
n <- 145
cases <- 8
theta <- c(0.03, 0.04, 0.05, 0.06)
priors <- c(0.5, rep(0.5/3,3))

data.frame(hypothesis = theta,
           priors=priors) |>
  mutate(likelihood = dbinom(cases, size = n, prob = hypothesis)) |> #this does not give the same results as the notes probably an approximation
  mutate(rel.likelihood = likelihood / min(likelihood)) |>
  mutate(posterior = priors * likelihood / sum(priors * likelihood)) |>
  kable(caption=paste0("Probability of observing ", cases, " cases out of ",n, " trials"),
        digits=c(3,3,2))
```

::: {.cell-output-display}


Table: Probability of observing 8 cases out of 145 trials

| hypothesis| priors| likelihood| rel.likelihood| posterior|
|----------:|------:|----------:|--------------:|---------:|
|       0.03|  0.500|       0.04|          1.000|     0.244|
|       0.04|  0.167|       0.10|          2.415|     0.196|
|       0.05|  0.167|       0.14|          3.429|     0.279|
|       0.06|  0.167|       0.14|          3.460|     0.281|


:::

```{.r .cell-code}
#this does not give the same results as the notes
```
:::


This means that hypotheses 4 and 5 explain the data approximately the same times better than hypothesis 1.

#### The likilihood principal

There is an articulation of the *Likelihood Principal*: once $Y$ has been observed we now note it as $Y = y_o$ , and no other value of Y matters. We should treat as $L(\theta|y_o) = Pr(Y = y_o | \theta)$ as the only likelihood function of $\theta$ and no other aspects of the experiment or data matter for inference.

#### The conjugate prior for a binomial distribution is a beta distribution

What if the prior probabilities are continuous, if we model them as $\theta = Beta(\alpha,\beta)$.  The density of this prior is given by:

$$ \pi(\theta \mid \alpha, \beta) = \frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha)\Gamma(\beta)} \theta^{\alpha - 1} (1 - \theta)^{\beta - 1} $$

In this case $\frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha)\Gamma(\beta)}$ is a normalizing factor that ensures probabilities intgrate to one and exist between zero and one.

The posterior density is therefore proprotional to to the prior times the likelihood $\pi(\theta \mid y) \propto \pi(\theta) \times p(y \mid \theta)$.  This expands out to this $\pi(\theta \mid y) \propto \theta^{\alpha - 1} (1 - \theta)^{\beta - 1} \times \theta^y (1 - \theta)^{n - y}$ droppping the constants for now.  By combining the exponents we get $\pi(\theta \mid y) \propto \theta^{(\alpha + y) - 1} (1 - \theta)^{( \beta + n - y) - 1}$.  This is the kernel (un-normalized density) of a Beta distribution with updated parameters $\alpha' = \alpha + y, \quad \beta' = \beta + n - y$

To get the proper density, we need to insert the Beta normalizing constant with the new parameters $\pi(\theta \mid y) = \frac{\Gamma(\alpha + y + \beta + n - y)}{\Gamma(\alpha + y)\Gamma(\beta + n - y)} \theta^{\alpha + y - 1} (1 - \theta)^{\beta + n - y - 1}$ which simplifies to
$\theta \mid y \sim \operatorname{Beta}(y + \alpha, \, n - y + \beta)$.  This is the posterior probability distribution.

To calculate the mean and variance, for any $\operatorname{Beta}(a, b)$ random variable:$\mathbb{E}[\theta] = \frac{a}{a + b}, \quad \operatorname{Var}(\theta) = \frac{ab}{(a + b)^2 (a + b + 1)}$ we can plug in $a = y + \alpha$, $b = n - y + \beta$: $\mathbb{E}[\theta \mid y] = \frac{y + \alpha}{n + \alpha + \beta}$ (this is a weighted average between the observed proportion $y/n$ and the prior “pseudo-mean” $\alpha/(\alpha + \beta)$, with more weight on the data when n is large) $\operatorname{Var}(\theta \mid y) = \frac{(y + \alpha)(n - y + \beta)}{(n + \alpha + \beta)^2 (n + \alpha + \beta + 1)}$

To summarize if our priors are $Beta(\alpha, \beta)$ and our posterior probabilities are $P(\theta|Y=y_o=8)=Beta(y_o + α, n − y_o + β)$



::: {.cell}

```{.r .cell-code}
#mean = alpha / (alpha + beta) so to guestimate 0.444 is 4/85
alpha <-  1
beta <- 1

range <- seq(0,1,by=0.001)
prior <- dbeta(range,shape1=alpha,shape2=beta)
posterior <- dbeta(range,shape1=cases + alpha, shape2=n - cases + beta)
data.beta <- data.frame(range=range,
                        prior=prior,
                        posterior=posterior) |>
  pivot_longer(cols=c("prior","posterior"),
               names_to="distribution",
               values_to="value")

ggplot(data.beta,aes(y=value,x=range,col=distribution)) +
  geom_line() +
  labs(title=paste0("Distribution - Beta(",round(alpha,2),",",round(beta,2),")"),
       x="Value",
       y="Likelihood") +
  theme_classic(base_size=16) +
  theme(legend.position = c(0.85,0.85)) 
```

::: {.cell-output-display}
![](Bayesian-Learning-Notes_files/figure-html/lecture-2-continuous-prior-1.png){width=672}
:::

```{.r .cell-code}
#these are defined from the conjugate prior/posterior relationship
prior_mean = alpha/(alpha+beta)
prior_ci_lower = qbeta(0.025, alpha, beta)
prior_ci_upper = qbeta(0.975, alpha, beta)
posterior_mean = (alpha + cases)/(alpha+cases+n-cases+beta)
posterior_ci_lower = qbeta(0.025, (alpha + cases), (cases+n-cases+beta))
posterior_ci_upper = qbeta(0.975, (alpha + cases), (cases+n-cases+beta))

data.frame(Distribution=c("Prior","Posterior"),
           Mean=c(prior_mean,posterior_mean),
           CI_Lower=c(prior_ci_lower,posterior_ci_lower),
           CI_Upper=c(prior_ci_upper,posterior_ci_upper)) |>
  kable(digits=3,
        caption="Summary statistics for prior and posterior distributions")
```

::: {.cell-output-display}


Table: Summary statistics for prior and posterior distributions

|Distribution |  Mean| CI_Lower| CI_Upper|
|:------------|-----:|--------:|--------:|
|Prior        | 0.500|    0.025|    0.975|
|Posterior    | 0.061|    0.027|    0.100|


:::
:::


By this model the posterior probability that the incidence is greater than 4.44% is 79.8%.

#### Example of Beta as a Conjugate Prior

Imagine there is a mouse that has a rare phenotype, we observe $n=20$ mice, and find $y=4$ have this phenotype. The probability of this occuring can be denoted as $Y | p \sim Bin(20,p)$.  Before noticing this, we believe the phenotype is uncommon but i have low certainty on this hypothesis, given as $p \sim Beta(2,20)$. This was selected because in $Beta(\alpha,\beta)$ this means that

- $\alpha-1$ is how often its observed (successes)
- $\beta-1$ is the number of times not observed (failures)
- $\alpha + \beta$ is the strength of this conviction
- The mean estimate is $E[p]=\frac{\alpha}{\alpha + \beta}$

So this prior is formulating on the expectation that out of 18 examples, I would have expected one example of this phenotype.  This corresponds to an estimate of 10% $\frac{2}{2+19}$.  Here are three possible visualizations of priors for this example, presuming one success out of 18, 5, or 30 trials


::: {.cell}

```{.r .cell-code}
prior.data.frame <- data.frame(probability=seq(0,1,by=0.01)) |>
  expand_grid(observed=1, attempts=c(20,5,30)) |>
  mutate(alpha = observed + 1,
         beta = attempts - observed + 1) |>
  mutate(prior = paste0("Beta(",alpha,",",beta,")")) |>
  mutate(density=dbeta(probability,alpha,beta)) 

ggplot(prior.data.frame, aes(y=density,x=probability,col=prior)) +
  geom_line() +
  theme_classic(base_size = 16) +
  theme(legend.position=c(0.8,0.8))
```

::: {.cell-output-display}
![](Bayesian-Learning-Notes_files/figure-html/binomial-conjugate-example-prior-plot-1.png){width=672}
:::
:::


The posterior is the likelihood times prior is $L(p|y_o=4) \times \pi(p)$.  This becomes $(p∣y_o) \sim Beta(\alpha+Y_o,\beta+n−y_o)$.  For this example this computes to $Beta(2+4,20+20-4)=Beta(6,36)$



::: {.cell}

```{.r .cell-code}
data.frame(probability=seq(0,1,by=0.01)) |>
  mutate(prior = dbeta(probability,2,18),
         posterior = dbeta(probability,6,36)) |>
  pivot_longer(c(prior,posterior),names_to="type",values_to = "density") |>
  ggplot(aes(y=density,x=probability,col=type)) +
  geom_line() +
  geom_vline(xintercept=4/20, lty=2, col="grey") +
  annotate(
    geom  = "text",
    x     = 4/20+0.01,           # ← your chosen x-position
    y     = 8,            # ← your chosen y-position
    label = "Observed",
    hjust = 0,            # 0 = left justified (most important part)
    vjust = 0.5,          # optional: 0.5 = vertically centered
    size  = 5, color = "grey"
  ) +
  theme_classic(base_size=16) +
  theme(legend.position=c(0.8,0.8))
```

::: {.cell-output-display}
![](Bayesian-Learning-Notes_files/figure-html/beta-example-prior-posterior-1.png){width=672}
:::
:::


Given this result of a posterior probability of $Beta(6,36)$ this corresponds to a mean probability of $\frac{6}{6+36}=\frac{6}{42}=$ 0.1428571.  The variance is $Var(p)=\frac{\alpha \times \beta}{(\alpha + beta)^2\times(\alpha + \beta + 1)}= \frac{6\times 36}{(6+36)^2\times(6+36+1)}=$ 0.0028477.  The posterior mode is $MAP=\frac{\alpha-1}{\alpha + \beta - 2}=$ 0.125.


## References

::: {#refs}
:::

## Session Information


::: {.cell}

```{.r .cell-code}
sessionInfo()
```

::: {.cell-output .cell-output-stdout}

```
R version 4.5.2 (2025-10-31)
Platform: aarch64-apple-darwin20
Running under: macOS Tahoe 26.2

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/Detroit
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] knitr_1.50      lubridate_1.9.4 forcats_1.0.1   stringr_1.6.0  
 [5] dplyr_1.1.4     purrr_1.2.0     readr_2.1.6     tidyr_1.3.1    
 [9] tibble_3.3.0    ggplot2_4.0.1   tidyverse_2.0.0

loaded via a namespace (and not attached):
 [1] gtable_0.3.6       jsonlite_2.0.0     compiler_4.5.2     tidyselect_1.2.1  
 [5] dichromat_2.0-0.1  scales_1.4.0       yaml_2.3.12        fastmap_1.2.0     
 [9] R6_2.6.1           labeling_0.4.3     generics_0.1.4     htmlwidgets_1.6.4 
[13] pillar_1.11.1      RColorBrewer_1.1-3 tzdb_0.5.0         rlang_1.1.6       
[17] stringi_1.8.7      xfun_0.54          S7_0.2.1           timechange_0.3.0  
[21] cli_3.6.5          withr_3.0.2        magrittr_2.0.4     digest_0.6.39     
[25] grid_4.5.2         rstudioapi_0.17.1  hms_1.1.4          lifecycle_1.0.4   
[29] vctrs_0.6.5        evaluate_1.0.5     glue_1.8.0         farver_2.1.2      
[33] rmarkdown_2.30     tools_4.5.2        pkgconfig_2.0.3    htmltools_0.5.9   
```


:::
:::

