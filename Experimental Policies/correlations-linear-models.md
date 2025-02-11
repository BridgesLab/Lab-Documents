---
title: "Correlations and Linear Models"
author: "Authors"
date: "2025-02-10"
editor: source
format: 
  html:
    toc: true
    toc-location: right
    keep-md: true
    code-fold: false
    code-summary: "Show the code"
  gfm:
    html-math-method: webtex
theme: journal
execute:
  echo: true
  warning: false
---



Lets say you want to explore the relationship between two continuous variables.  Here we will cover how to explore, graph, and quantify these relationships.


::: {.cell}

```{.r .cell-code}
# sets maize and blue color scheme
color_scheme <- c("#00274c", "#ffcb05")

library(tidyverse)
library(moderndive)
```
:::


We will use the `houseprices` dataset in the moderndive package.  It has data about a variety of factors about housing.  Here we will explore how the square feet of living space (`sqft_living`) relates to the `price`.

## Visualizing a Relationship

The best first thing to do is to make a plot looking at the two variables.  Here we will use ggplot, defining the x and y axis aesthetics, and adding both a linear and smoothed line (geom)


::: {.cell}

```{.r .cell-code}
library(ggplot2)
ggplot(house_prices,
       aes(y=price,x=sqft_living)) +
  geom_point(alpha=0.5) + #transparency of the points
  geom_smooth(method="loess",color=color_scheme[2]) + #smoothed line
  geom_smooth(method="lm",color=color_scheme[1]) + #linear relationship
  theme_classic(base_size=16) #classic theme, and increasing the font size
```

::: {.cell-output-display}
![](correlations-linear-models_files/figure-html/price-sqft-living-1.png){width=672}
:::
:::

This appears to be an approximately linear relationship (blue line), though th smooth best fit curve (maiz line) suggests it might be nonlinear below about 3000 square feet.  For now lets focus on describing the linear relationship, we will come back to a non-linear relationship in @non_linear.

## Describing the Linear Relationship

In general there are two components to a relationship

1. The slope estimate and its error, in this example how much does price increase per square foot of living space
2. The linearity ($R^2$), or how much of the price is explained by square feet of living space.

In both cases this can be solved with a linear model, and the results visualized with the `tidy` and `glance` functions from the `broom` package


::: {.cell}

```{.r .cell-code}
lm.1 <- lm(price~sqft_living,data=house_prices)
library(broom) #for glance/tidy
library(knitr) #for kable
tidy(lm.1) %>% kable(caption="Estimates for the price/square foot relationship")
```

::: {.cell-output-display}
Table: Estimates for the price/square foot relationship

|term        |    estimate|   std.error|  statistic| p.value|
|:-----------|-----------:|-----------:|----------:|-------:|
|(Intercept) | -43580.7431| 4402.689690|  -9.898663|       0|
|sqft_living |    280.6236|    1.936399| 144.920356|       0|
:::

```{.r .cell-code}
glance(lm.1) %>% kable(caption="Model fit for the price/square food relationship")
```

::: {.cell-output-display}
Table: Model fit for the price/square food relationship

| r.squared| adj.r.squared|    sigma| statistic| p.value| df|    logLik|      AIC|      BIC|     deviance| df.residual|  nobs|
|---------:|-------------:|--------:|---------:|-------:|--:|---------:|--------:|--------:|------------:|-----------:|-----:|
| 0.4928532|     0.4928298| 261452.9|  21001.91|       0|  1| -300267.3| 600540.6| 600564.5| 1.477276e+15|       21611| 21613|
:::
:::


As you can see from these tables, we estimate that the price increases by \$280.6235679 $\pm$ 1.9363986 per square foot of living space.  This is a highly significant relationship (p=0).  The $R^2$ for this model is estimated at 0.4928532.

### Testing the Assumptions of the Model

For a linear model there are four assumptions

* **Linearity**: The relationship between the predictor (x) and the outcome (y) is assumed to be linear. This means that for one unit change in the predictor, there is a constant change in the response.
* **Independence**: The residuals (error terms) are assumed to be independent of each other. This means we cannot predict the size of a residual from another residual or from the value of a predictor variable.
* **Homoscedasticity**: The residuals are assumed to have constant variance across all levels of the predictor variable. This is also known as homogeneity of variance.
* **Normality**: The residuals are assumed to be normally distributed. While perfect normality is not required, it suggests that the model is doing a good job of predicting the response.



::: {.cell}

```{.r .cell-code}
par(mfrow = c(2, 2))
plot(lm.1)
```

::: {.cell-output-display}
![](correlations-linear-models_files/figure-html/lm-assumptions-1.png){width=672}
:::
:::


## Evaluating Non-Linear Relationships {#non_linear}

Note perplexity.ai was used to help in generating this script

## Session Information


::: {.cell}

```{.r .cell-code}
sessionInfo()
```

::: {.cell-output .cell-output-stdout}
```
R version 4.4.2 (2024-10-31)
Platform: x86_64-apple-darwin20
Running under: macOS Monterey 12.7.6

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
 [1] knitr_1.49       broom_1.0.7      moderndive_0.7.0 lubridate_1.9.4 
 [5] forcats_1.0.0    stringr_1.5.1    dplyr_1.1.4      purrr_1.0.2     
 [9] readr_2.1.5      tidyr_1.3.1      tibble_3.2.1     ggplot2_3.5.1   
[13] tidyverse_2.0.0 

loaded via a namespace (and not attached):
 [1] generics_0.1.3       lattice_0.22-6       stringi_1.8.4       
 [4] hms_1.1.3            digest_0.6.37        magrittr_2.0.3      
 [7] evaluate_1.0.3       grid_4.4.2           timechange_0.3.0    
[10] fastmap_1.2.0        Matrix_1.7-1         operator.tools_1.6.3
[13] jsonlite_1.8.9       backports_1.5.0      mgcv_1.9-1          
[16] scales_1.3.0         infer_1.0.7          cli_3.6.3           
[19] rlang_1.1.4          munsell_0.5.1        splines_4.4.2       
[22] withr_3.0.2          yaml_2.3.10          tools_4.4.2         
[25] tzdb_0.4.0           colorspace_2.1-1     vctrs_0.6.5         
[28] R6_2.5.1             lifecycle_1.0.4      snakecase_0.11.1    
[31] htmlwidgets_1.6.4    janitor_2.2.1        pkgconfig_2.0.3     
[34] pillar_1.10.1        gtable_0.3.6         glue_1.8.0          
[37] xfun_0.50            tidyselect_1.2.1     rstudioapi_0.17.1   
[40] farver_2.1.2         htmltools_0.5.8.1    nlme_3.1-166        
[43] labeling_0.4.3       rmarkdown_2.29       formula.tools_1.7.1 
[46] compiler_4.4.2      
```
:::
:::
