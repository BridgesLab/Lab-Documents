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
theme: journal
---


::: {.cell}

```{.r .cell-code}
#hide this code chunk
#| echo: false
#| message: false

library(knitr)
#figures makde will go to directory called figures, will make them as both png and pdf files 
opts_chunk$set(fig.path='figures/',
               dev=c('png','pdf'))
options(scipen = 2, digits = 3)

knitr::knit_hooks$set(inline = function(x) {
  knitr:::format_sci(x, 'md')
})
  
se <- function(x) sd(x, na.rm=T)/sqrt(length(x))

#load these packages, nearly always needed
library(tidyverse)
```

::: {.cell-output .cell-output-stderr}

```
── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.4     ✔ readr     2.1.5
✔ forcats   1.0.0     ✔ stringr   1.5.1
✔ ggplot2   3.5.1     ✔ tibble    3.2.1
✔ lubridate 1.9.3     ✔ tidyr     1.3.1
✔ purrr     1.0.2     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```


:::

```{.r .cell-code}
# sets maize and blue color scheme
color.scheme <- c('#00274c', '#ffcb05')
```
:::



# Purpose

Succintly describe the purpose of the experiment

# Experimental Details

Link to the protocol used (permalink preferred) for the experiment and include any notes relevant to your analysis.  This might include specifics not in the general protocol such as cell lines, treatment doses etc.

# Raw Data

Describe your raw data files, including what the columns mean (and what units they are in).



::: {.cell}

```{.r .cell-code}
library(readr) #loads the readr package
filename <- 'testfile.csv' #input file(s)

#this loads whatever the file is into a dataframe called exp.data if it exists
if(filename %in% dir()){
  exp.data <- read_csv(filename)
}
```

::: {.cell-output .cell-output-stderr}

```
Rows: 60 Columns: 3
── Column specification ────────────────────────────────────────────────────────
Delimiter: ","
chr (1): supp
dbl (2): len, dose

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


:::
:::



These data can be found in **/Users/davebrid/Documents/GitHub/Lab-Documents/Experimental Policies** in a file named **testfile.csv**.  This script was most recently updated on **Tue Oct 15 19:26:43 2024**.

# Analysis

Describe the analysis as you intersperse code chunks

# Interpretation

A brief summary of what the interpretation of these results were

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
 [1] lubridate_1.9.3 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
 [5] purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
 [9] ggplot2_3.5.1   tidyverse_2.0.0 knitr_1.48     

loaded via a namespace (and not attached):
 [1] bit_4.0.5         gtable_0.3.5      jsonlite_1.8.8    crayon_1.5.3     
 [5] compiler_4.4.1    tidyselect_1.2.1  parallel_4.4.1    scales_1.3.0     
 [9] yaml_2.3.10       fastmap_1.2.0     R6_2.5.1          generics_0.1.3   
[13] htmlwidgets_1.6.4 munsell_0.5.1     pillar_1.9.0      tzdb_0.4.0       
[17] rlang_1.1.4       utf8_1.2.4        stringi_1.8.4     xfun_0.47        
[21] bit64_4.0.5       timechange_0.3.0  cli_3.6.3         withr_3.0.1      
[25] magrittr_2.0.3    digest_0.6.37     grid_4.4.1        vroom_1.6.5      
[29] rstudioapi_0.16.0 hms_1.1.3         lifecycle_1.0.4   vctrs_0.6.5      
[33] evaluate_0.24.0   glue_1.7.0        fansi_1.0.6       colorspace_2.1-1 
[37] rmarkdown_2.28    tools_4.4.1       pkgconfig_2.0.3   htmltools_0.5.8.1
```


:::
:::



# References

If needed you will need a *.bib file.  See the details at <https://quarto.org/docs/authoring/citations.html>