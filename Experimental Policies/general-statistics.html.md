---
title: "General Statistics"
author: "Dave Bridges"
date: "May 9, 2014"
format: 
  html:
    toc: true
    toc-location: right
    keep-md: true
    code-fold: true
    code-summary: "Show the code"
theme: journal
bibliography: references.bib   
execute: 
  message: false
---


::: {.cell}

```{.r .cell-code}
library(knitr)
#figures makde will go to directory called figures, will make them as both png and pdf files 
opts_chunk$set(fig.path='figures/',dev=c('png','pdf'))
options(scipen = 2, digits = 3)
# set echo and message to TRUE if you want to display code blocks and code output respectively

knitr::knit_hooks$set(inline = function(x) {
  knitr:::format_sci(x, 'md')
})


superpose.eb <- function (x, y, ebl, ebu = ebl, length = 0.08, ...)
  arrows(x, y + ebu, x, y - ebl, angle = 90, code = 3,
  length = length, ...)

  
se <- function(x) sd(x, na.rm=T)/sqrt(length(x))

#load these packages, nearly always needed
library(tidyr)
library(dplyr)
```

::: {.cell-output .cell-output-stderr}

```

Attaching package: 'dplyr'
```


:::

::: {.cell-output .cell-output-stderr}

```
The following objects are masked from 'package:stats':

    filter, lag
```


:::

::: {.cell-output .cell-output-stderr}

```
The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union
```


:::

```{.r .cell-code}
# sets maize and blue color scheme
color.scheme <- c('#00274c', '#ffcb05')
```
:::



# General Statistical Methods

There are several important concepts that we will adhere to in our group.  These involve design considerations, execution considerations and analysis concerns.  The standard for our field is null hypothesis significance testing, which means that we are generally comparing our data to a null hypothesis, generating an **effect size** and a **p-value**.  As a general rule, we report both of these both within our Rmd/qmd scripts, and in our publications.

We generally use an $\alpha$ of $p<0.05$ to determine significance, which means that (if true) we are rejecting the null hypothesis.  This is known as null hypothesis significance testing.

An alternative approach is to use a Bayesian approach, described in more detail in [this document](https://bridgeslab.github.io/Lab-Documents/Experimental%20Policies/bayesian-analyses.html)

# Pairwise Testing

If you have two groups (and two groups only) that you want to know if they are different, you will normally want to do a pairwise test.  This is **not** the case if you have paired data (before and after for example).  The most common of these is something called a Student's *t*-test, but this test has two key assumptions:

* The data are normally distributed
* The two groups have equal variance

## Testing the Assumptions

Best practice is to first test for normality, and if that test passes, to then test for equal variance

### Testing Normality

To test normality, we use a Shapiro-Wilk test (details on [Wikipedia](https://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_test) on each of your two groups).  Below is an example where there are two groups:



::: {.cell}

```{.r .cell-code}
#create seed for reproducibility
set.seed(1265)
test.data <- tibble(Treatment=c(rep("Experiment",6), rep("Control",6)),
           Result = rnorm(n=12, mean=10, sd=3))
#test.data$Treatment <- as.factor(test.data$Treatment)
kable(test.data, caption="The test data used in the following examples")
```

::: {.cell-output-display}


Table: The test data used in the following examples

|Treatment  | Result|
|:----------|------:|
|Experiment |  11.26|
|Experiment |   8.33|
|Experiment |   9.94|
|Experiment |  11.83|
|Experiment |   6.56|
|Experiment |  11.41|
|Control    |   8.89|
|Control    |  11.59|
|Control    |   9.39|
|Control    |   8.74|
|Control    |   6.31|
|Control    |   7.82|


:::
:::



Each of the two groups, in this case **Test** and **Control** must have Shapiro-Wilk tests done separately.  Some sample code for this is below (requires dplyr to be loaded):



::: {.cell}

```{.r .cell-code}
#filter only for the control data
control.data <- filter(test.data, Treatment=="Control")
#The broom package makes the results of the test appear in a table, with the tidy command
library(broom)

#run the Shapiro-Wilk test on the values
shapiro.test(control.data$Result) %>% tidy %>% kable(caption="Shapiro-Wilk test for normality of control data")
```

::: {.cell-output-display}


Table: Shapiro-Wilk test for normality of control data

| statistic| p.value|method                      |
|---------:|-------:|:---------------------------|
|     0.968|    0.88|Shapiro-Wilk normality test |


:::

```{.r .cell-code}
experiment.data <- filter(test.data, Treatment=="Experiment")
shapiro.test(test.data$Result) %>% tidy %>% kable(caption="Shapiro-Wilk test for normality of the test data")
```

::: {.cell-output-display}


Table: Shapiro-Wilk test for normality of the test data

| statistic| p.value|method                      |
|---------:|-------:|:---------------------------|
|      0.93|   0.377|Shapiro-Wilk normality test |


:::
:::



Based on these results, since both p-values are >0.05 we do not reject the presumption of normality and can go on.  If one or more of the p-values were less than 0.05 we would then use a Mann-Whitney test (also known as a Wilcoxon rank sum test) will be done, see below for more details.

### Testing for Equal Variance

We generally use the [car](https://cran.r-project.org/web/packages/car/index.html) package which contains code for [Levene's Test](https://en.wikipedia.org/wiki/Levene%27s_test) to see if two groups can be assumed to have equal variance.  For more details see @car:



::: {.cell}

```{.r .cell-code}
#load the car package
library(car)
```

::: {.cell-output .cell-output-stderr}

```
Loading required package: carData
```


:::

::: {.cell-output .cell-output-stderr}

```

Attaching package: 'car'
```


:::

::: {.cell-output .cell-output-stderr}

```
The following object is masked from 'package:dplyr':

    recode
```


:::

```{.r .cell-code}
#runs the test, grouping by the Treatment variable
leveneTest(Result ~ Treatment, data=test.data) %>% tidy %>% kable(caption="Levene's test on test data")
```

::: {.cell-output .cell-output-stderr}

```
Warning in leveneTest.default(y = y, group = group, ...): group coerced to
factor.
```


:::

::: {.cell-output-display}


Table: Levene's test on test data

| statistic| p.value| df| df.residual|
|---------:|-------:|--:|-----------:|
|     0.368|   0.558|  1|          10|


:::
:::



## Performing the Appropriate Pairwise Test

The logic to follow is:

* If the Shapiro-Wilk test passes, do Levene's test.  If it fails for either group, move on to a **Wilcoxon Rank Sum Test**.
* If Levene's test *passes*, do a Student's *t* Test, which assumes equal variance.
* If Levene's test *fails*, do a Welch's *t* Test, which does not assume equal variance.

### Student's *t* Test



::: {.cell}

```{.r .cell-code}
#The default for t.test in R is Welch's, so you need to set the var.equal variable to be TRUE
t.test(Result~Treatment,data=test.data, var.equal=T) %>% tidy %>% kable(caption="Student's t test for test data")
```

::: {.cell-output-display}


Table: Student's t test for test data

| estimate| estimate1| estimate2| statistic| p.value| parameter| conf.low| conf.high|method            |alternative |
|--------:|---------:|---------:|---------:|-------:|---------:|--------:|---------:|:-----------------|:-----------|
|     -1.1|      8.79|      9.89|    -0.992|   0.345|        10|    -3.56|      1.37|Two Sample t-test |two.sided   |


:::
:::



### Welch's *t* Test



::: {.cell}

```{.r .cell-code}
#The default for t.test in R is Welch's, so you need to set the var.equal variable to be FALSE, or leave the default
t.test(Result~Treatment,data=test.data, var.equal=F) %>% tidy %>% kable(caption="Welch's t test for test data")
```

::: {.cell-output-display}


Table: Welch's t test for test data

| estimate| estimate1| estimate2| statistic| p.value| parameter| conf.low| conf.high|method                  |alternative |
|--------:|---------:|---------:|---------:|-------:|---------:|--------:|---------:|:-----------------------|:-----------|
|     -1.1|      8.79|      9.89|    -0.992|   0.345|      9.72|    -3.57|      1.38|Welch Two Sample t-test |two.sided   |


:::
:::



### Wilcoxon Rank Sum Test



::: {.cell}

```{.r .cell-code}
# no need to specify anything about variance
wilcox.test(Result~Treatment,data=test.data) %>% tidy %>% kable(caption="Mann-Whitney test for test data")
```

::: {.cell-output-display}


Table: Mann-Whitney test for test data

| statistic| p.value|method                       |alternative |
|---------:|-------:|:----------------------------|:-----------|
|        12|   0.394|Wilcoxon rank sum exact test |two.sided   |


:::
:::



# Corrections for Multiple Observations

The best illustration I have seen for the need for multiple observation corrections is this cartoon from XKCD (see http://xkcd.com/882/):

![Significance by XKCD.  Image is from http://imgs.xkcd.com/comics/significant.png](http://imgs.xkcd.com/comics/significant.png "Significance by XKCD.  Image is from http://imgs.xkcd.com/comics/significant.png")


Any conceptually coherent set of observations must therefore be corrected for multiple observations.  In most cases, we will use the method of @Benjamini1995 since our p-values are not entirely independent.  Some sample code for this is here:



::: {.cell}

```{.r .cell-code}
p.values <- c(0.023, 0.043, 0.056, 0.421, 0.012)
data.frame(unadjusted = p.values, adjusted=p.adjust(p.values, method="BH")) %>% 
  kable(caption="Effects of adjusting p-values by the method of Benjamini-Hochberg")
```

::: {.cell-output-display}


Table: Effects of adjusting p-values by the method of Benjamini-Hochberg

| unadjusted| adjusted|
|----------:|--------:|
|      0.023|    0.057|
|      0.043|    0.070|
|      0.056|    0.070|
|      0.421|    0.421|
|      0.012|    0.057|


:::
:::



# Session Information



::: {.cell}

```{.r .cell-code}
sessionInfo()
```

::: {.cell-output .cell-output-stdout}

```
R version 4.4.1 (2024-06-14)
Platform: x86_64-apple-darwin20
Running under: macOS Sonoma 14.7

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.4-x86_64/Resources/lib/libRblas.0.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.4-x86_64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/Detroit
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] car_3.1-2     carData_3.0-5 broom_1.0.6   dplyr_1.1.4   tidyr_1.3.1  
[6] knitr_1.48   

loaded via a namespace (and not attached):
 [1] vctrs_0.6.5       cli_3.6.3         rlang_1.1.4       xfun_0.47        
 [5] purrr_1.0.2       generics_0.1.3    jsonlite_1.8.8    glue_1.7.0       
 [9] backports_1.5.0   htmltools_0.5.8.1 fansi_1.0.6       rmarkdown_2.28   
[13] abind_1.4-8       evaluate_0.24.0   tibble_3.2.1      fastmap_1.2.0    
[17] yaml_2.3.10       lifecycle_1.0.4   compiler_4.4.1    htmlwidgets_1.6.4
[21] pkgconfig_2.0.3   rstudioapi_0.16.0 digest_0.6.37     R6_2.5.1         
[25] tidyselect_1.2.1  utf8_1.2.4        pillar_1.9.0      magrittr_2.0.3   
[29] withr_3.0.1       tools_4.4.1      
```


:::
:::



# References


::: {#refs}
:::