---
title: "Informative title"
author: "Authors"
date: "2000-01-01"
format: 
  html:
    toc: true
    toc-location: right
    keep-md: true
    code-fold: true
    code-summary: "Show the code"
    fig-path: "figures/"
  gfm:
    html-math-method: webtex
theme: journal
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

# sets maize and blue color scheme
color_scheme <- c("#00274c", "#ffcb05")
```
:::


## Purpose

Succintly describe the purpose of the experiment

## Experimental Details

Link to the protocol used (permalink preferred) for the experiment and include any notes relevant to your analysis.  This might include specifics not in the general protocol such as cell lines, treatment doses etc.

## Raw Data

Describe your raw data files, including what the columns mean (and what units they are in).


::: {.cell}

```{.r .cell-code}
library(readr) #loads the readr package
filename <- "testfile.csv" #input file(s)

#this loads whatever the file is into a dataframe called exp.data if it exists
if (filename %in% dir()) {
  exp.data <- read_csv(filename)
}
```
:::


These data can be found in **/Users/davebrid/Documents/GitHub/Lab-Documents-BL/Experimental Policies** in a file named **testfile.csv**.  This script was most recently updated on **Mon Jan 27 19:43:52 2025**.

## Analysis

Describe the analysis as you intersperse code chunks

## Interpretation

A brief summary of what the interpretation of these results were

## References

If needed you will need a *.bib file.  See the details at <https://quarto.org/docs/authoring/citations.html>

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
 [1] lubridate_1.9.4 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
 [5] purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
 [9] ggplot2_3.5.1   tidyverse_2.0.0

loaded via a namespace (and not attached):
 [1] bit_4.5.0.1       gtable_0.3.6      jsonlite_1.8.9    crayon_1.5.3     
 [5] compiler_4.4.2    tidyselect_1.2.1  parallel_4.4.2    scales_1.3.0     
 [9] yaml_2.3.10       fastmap_1.2.0     R6_2.5.1          generics_0.1.3   
[13] knitr_1.49        htmlwidgets_1.6.4 munsell_0.5.1     pillar_1.10.1    
[17] tzdb_0.4.0        rlang_1.1.4       stringi_1.8.4     xfun_0.50        
[21] bit64_4.5.2       timechange_0.3.0  cli_3.6.3         withr_3.0.2      
[25] magrittr_2.0.3    digest_0.6.37     grid_4.4.2        vroom_1.6.5      
[29] rstudioapi_0.17.1 hms_1.1.3         lifecycle_1.0.4   vctrs_0.6.5      
[33] evaluate_1.0.3    glue_1.8.0        colorspace_2.1-1  rmarkdown_2.29   
[37] tools_4.4.2       pkgconfig_2.0.3   htmltools_0.5.8.1
```
:::
:::
