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

There is an articulation of the *Likelihood Principal*: once $Y$ has been observed we now note it as $Y = y_o$ , and no other value of Y matters. We should treat as $L(\theta|y_o) = Pr(Y = y_o | \theta)$ as the only likelihood function of $\theta$ and no other aspects of the experiment or data matter for inference.

What if the prior probabilities are continuous, if we model them as $\theta = Beta(\alpha,\beta)$.  The density of this prior is given by:

$$ \pi(\theta \mid \alpha, \beta) = \frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha)\Gamma(\beta)} \theta^{\alpha - 1} (1 - \theta)^{\beta - 1} $$

In this case $\frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha)\Gamma(\beta)}$ is a normalizing factor that ensures probabilities intgrate to one and exist between zero and one.

The posterior density is therefore proprotional to to the prior times the likelihood $\pi(\theta \mid y) \propto \pi(\theta) \times p(y \mid \theta)$.  This expands out to this $\pi(\theta \mid y) \propto \theta^{\alpha - 1} (1 - \theta)^{\beta - 1} \times \theta^y (1 - \theta)^{n - y}$ droppping the constants for now.  By combining the exponents we get $\pi(\theta \mid y) \propto \theta^{(\alpha + y) - 1} (1 - \theta)^{( \beta + n - y) - 1}$.  This is the kernel (un-normalized density) of a Beta distribution with updated parameters $\alpha' = \alpha + y, \quad \beta' = \beta + n - y$

To get the proper density, we need to insert the Beta normalizing constant with the new parameters $\pi(\theta \mid y) = \frac{\Gamma(\alpha + y + \beta + n - y)}{\Gamma(\alpha + y)\Gamma(\beta + n - y)} \theta^{\alpha + y - 1} (1 - \theta)^{\beta + n - y - 1}$ which simplifies to
$\theta \mid y \sim \operatorname{Beta}(y + \alpha, \, n - y + \beta)$.  This is the posterior probability distribution.

To calculate the mean and variance, for any $\operatorname{Beta}(a, b)$ random variable:$\mathbb{E}[\theta] = \frac{a}{a + b}, \quad \operatorname{Var}(\theta) = \frac{ab}{(a + b)^2 (a + b + 1)}$ we can plug in $a = y + \alpha$, $b = n - y + \beta$: $\mathbb{E}[\theta \mid y] = \frac{y + \alpha}{n + \alpha + \beta}$ (this is a weighted average between the observed proportion $y/n$ and the prior “pseudo-mean” $\alpha/(\alpha + \beta)$, with more weight on the data when n is large) $\operatorname{Var}(\theta \mid y) = \frac{(y + \alpha)(n - y + \beta)}{(n + \alpha + \beta)^2 (n + \alpha + \beta + 1)}$

To summarize if our priors are $Beta(\alpha, \beta)$ then $P(\theta|Y=8)=y ∼ Beta(y + α, n − y + β)$



::: {.cell}

```{.r .cell-code}
alpha <- 2
beta <- 10
range <- seq(0,1,by=0.1)
likelihood <- pbeta(range,shape1=alpha,shape2=beta)
data.beta <- data.frame(range=range,
                        likelihood=likelihood)

ggplot(data.beta,aes(y=likelihood,x=range)) +
  geom_line() +
  labs(title=paste0("Prior Distribution - Beta(",alpha,",",beta,")"),
       x="Value",
       y="Likelihood") +
  theme_classic(base_size=16)
```

::: {.cell-output-display}
![](Bayesian-Learning-Notes_files/figure-html/lecture-2-continuous-prior-1.png){width=672}
:::
:::


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
Running under: macOS Tahoe 26.1

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
 [5] scales_1.4.0       yaml_2.3.11        fastmap_1.2.0      R6_2.6.1          
 [9] labeling_0.4.3     generics_0.1.4     htmlwidgets_1.6.4  pillar_1.11.1     
[13] RColorBrewer_1.1-3 tzdb_0.5.0         rlang_1.1.6        stringi_1.8.7     
[17] xfun_0.54          S7_0.2.1           timechange_0.3.0   cli_3.6.5         
[21] withr_3.0.2        magrittr_2.0.4     digest_0.6.39      grid_4.5.2        
[25] rstudioapi_0.17.1  hms_1.1.4          lifecycle_1.0.4    vctrs_0.6.5       
[29] evaluate_1.0.5     glue_1.8.0         farver_2.1.2       rmarkdown_2.30    
[33] tools_4.5.2        pkgconfig_2.0.3    htmltools_0.5.9   
```


:::
:::

