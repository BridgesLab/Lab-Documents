---
title: "General Statistics"
author: "Dave Bridges"
date: "May 9, 2014"
output:
  html_document:
    highlight: tango
    keep_md: yes
    number_sections: yes
    toc: yes
  pdf_document:
    highlight: tango
    keep_tex: yes
    number_sections: yes
    toc: yes
---



# General Statistical Methods

There are several important concepts that we will adhere to in our group.  These involve design considerations, execution considerations and analysis concerns.



## Experimental Design

Where possible, prior to performing an experiment or study perform a power analysis.  This is mainly to determine the appropriate sample sizes.  To do this, you need to know a few of things:

* Either the sample size or the difference.  The difference is provided in standard deviations.  This means that you need to know the standard deviation of your measurement in question.  It is a good idea to keep a log of these for your data, so that you can approximate what this is.  If you hope to detect a correlation you will need to know the expected correlation coefficient.
* The desired false positive rate (normally 0.05).  This is the rate at which you find a difference where there is none.  This is also known as the type I error rate.
* The desired power (normally 0.8).  This indicates that 80% of the time you will detect the effect if there is one.  This is also known as 1 minus the false negative rate or 1 minus the Type II error rate.

We use the R package **pwr** to do a power analysis (Champely, 2017).  Here is an example:

### Pairwise Comparasons


```r
require(pwr)
false.negative.rate <- 0.05
statistical.power <- 0.8
sd <- 3.5 #this is calculated from known measurements
difference <- 3  #you hope to detect a difference 
pwr.t.test(d = difference, sig.level = false.negative.rate, power=statistical.power)
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 3.07
##               d = 3
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

This tells us that in order to see a difference of at least 3, with at standard devation of 3.5 we need at least **3** observations in each group.

### Correlations

The following is an example for detecting a correlation.  


```r
require(pwr)
false.negative.rate <- 0.05
statistical.power <- 0.8
correlation.coefficient <- 0.6 #note that this is the r, to get the R2 value you will have to square this result.
pwr.r.test(r = correlation.coefficient, sig.level = false.negative.rate, power=statistical.power)
```

```
## 
##      approximate correlation power calculation (arctangh transformation) 
## 
##               n = 18.6
##               r = 0.6
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
```

This tells us that in order to detect a correlation coefficient of at least 0.6 (or an R^2 of 0.36) you need more than **18** observations.

# Pairwise Testing

If you have two groups (and two groups only) that you want to know if they are different, you will normally want to do a pairwise test.  This is **not** the case if you have paired data (before and after for example).  The most common of these is something called a Student's *t*-test, but this test has two key assumptions:

* The data are normally distributed
* The two groups have equal variance

## Testing the Assumptions

Best practice is to first test for normality, and if that test passes, to then test for equal variance

### Testing Normality

To test normality, we use a Shapiro-Wilk test (details on [Wikipedia](https://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_test) on each of your two groups).  Below is an example where there are two groups:


```r
#create seed for reproducibility
set.seed(1265)
test.data <- tibble(Treatment=c(rep("Experiment",6), rep("Control",6)),
           Result = rnorm(n=12, mean=10, sd=3))
#test.data$Treatment <- as.factor(test.data$Treatment)
kable(test.data, caption="The test data used in the following examples")
```



Table: The test data used in the following examples

Treatment     Result
-----------  -------
Experiment     11.26
Experiment      8.33
Experiment      9.94
Experiment     11.83
Experiment      6.56
Experiment     11.41
Control         8.89
Control        11.59
Control         9.39
Control         8.74
Control         6.31
Control         7.82

Each of the two groups, in this case **Test** and **Control** must have Shapiro-Wilk tests done separately.  Some sample code for this is below (requires dplyr to be loaded):


```r
#filter only for the control data
control.data <- filter(test.data, Treatment=="Control")
#The broom package makes the results of the test appear in a table, with the tidy command
library(broom)

#run the Shapiro-Wilk test on the values
shapiro.test(control.data$Result) %>% tidy %>% kable
```



 statistic   p.value  method                      
----------  --------  ----------------------------
     0.968      0.88  Shapiro-Wilk normality test 

```r
experiment.data <- filter(test.data, Treatment=="Experiment")
shapiro.test(test.data$Result) %>% tidy %>% kable
```



 statistic   p.value  method                      
----------  --------  ----------------------------
      0.93     0.377  Shapiro-Wilk normality test 

Based on these results, since both p-values are >0.05 we do not reject the presumption of normality and can go on.  If one or more of the p-values were less than 0.05 we would then use a Mann-Whitney test (also known as a Wilcoxon rank sum test) will be done, see below for more details.

### Testing for Equal Variance

We generally use the [car](https://cran.r-project.org/web/packages/car/index.html) package which contains code for [Levene's Test](https://en.wikipedia.org/wiki/Levene%27s_test) to see if two groups can be assumed to have equal variance:


```r
#load the car package
library(car)

#runs the test, grouping by the Treatment variable
leveneTest(Result ~ Treatment, data=test.data) %>% tidy %>% kable
```



term     df   statistic   p.value
------  ---  ----------  --------
group     1       0.368     0.558
         10          NA        NA

## Performing the Appropriate Pairwise Test

The logic to follow is:

* If the Shapiro-Wilk test passes, do Levene's test.  If it fails for either group, move on to a **Wilcoxon Rank Sum Test**.
* If Levene's test *passes*, do a Student's *t* Test, which assumes equal variance.
* If Levene's test *fails*, do a Welch's *t* Test, which does not assume equal variance.

### Student's *t* Test


```r
#The default for t.test in R is Welch's, so you need to set the var.equal variable to be TRUE
t.test(Result~Treatment,data=test.data, var.equal=T) %>% tidy %>% kable
```



 estimate1   estimate2   statistic   p.value   parameter   conf.low   conf.high  method              alternative 
----------  ----------  ----------  --------  ----------  ---------  ----------  ------------------  ------------
      8.79        9.89      -0.992     0.345          10      -3.56        1.37  Two Sample t-test   two.sided   

### Welch's *t* Test


```r
#The default for t.test in R is Welch's, so you need to set the var.equal variable to be FALSE, or leave the default
t.test(Result~Treatment,data=test.data, var.equal=F) %>% tidy %>% kable
```



 estimate   estimate1   estimate2   statistic   p.value   parameter   conf.low   conf.high  method                    alternative 
---------  ----------  ----------  ----------  --------  ----------  ---------  ----------  ------------------------  ------------
     -1.1        8.79        9.89      -0.992     0.345        9.72      -3.57        1.38  Welch Two Sample t-test   two.sided   

### Wilcoxon Rank Sum Test


```r
# no need to specify anything about variance
wilcox.test(Result~Treatment,data=test.data) %>% tidy %>% kable
```



 statistic   p.value  method                   alternative 
----------  --------  -----------------------  ------------
        12     0.394  Wilcoxon rank sum test   two.sided   


# Corrections for Multiple Observations

The best illustration I have seen for the need for multiple observation corrections is this cartoon from XKCD (see http://xkcd.com/882/):

![Significance by XKCD.  Image is from http://imgs.xkcd.com/comics/significant.png](http://imgs.xkcd.com/comics/significant.png "Significance by XKCD.  Image is from http://imgs.xkcd.com/comics/significant.png")


Any conceptually coherent set of observations must therefore be corrected for multiple observations.  In most cases, we will use the method of Benjamini and Hochberg since our p-values are not entirely independent.  Some sample code for this is here:


```r
p.values <- c(0.023, 0.043, 0.056, 0.421, 0.012)
data.frame(unadjusted = p.values, adjusted=p.adjust(p.values, method="BH"))
```

```
##   unadjusted adjusted
## 1      0.023   0.0575
## 2      0.043   0.0700
## 3      0.056   0.0700
## 4      0.421   0.4210
## 5      0.012   0.0575
```

# Session Information


```r
sessionInfo()
```

```
## R version 3.4.2 (2017-09-28)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: macOS High Sierra 10.13.1
## 
## Matrix products: default
## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] car_2.1-6           broom_0.4.3         bindrcpp_0.2       
## [4] pwr_1.2-1           knitcitations_1.0.9 dplyr_0.7.4        
## [7] tidyr_0.7.2         knitr_1.17         
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.14       nloptr_1.0.4       compiler_3.4.2    
##  [4] plyr_1.8.4         highr_0.6          bindr_0.1         
##  [7] tools_3.4.2        lme4_1.1-14        digest_0.6.12     
## [10] jsonlite_1.5       lubridate_1.7.1    evaluate_0.10.1   
## [13] tibble_1.3.4       nlme_3.1-131       lattice_0.20-35   
## [16] mgcv_1.8-22        pkgconfig_2.0.1    rlang_0.1.4       
## [19] Matrix_1.2-12      psych_1.7.8        bibtex_0.4.2      
## [22] yaml_2.1.15        parallel_3.4.2     SparseM_1.77      
## [25] RefManageR_0.14.20 stringr_1.2.0      httr_1.3.1        
## [28] xml2_1.1.1         MatrixModels_0.4-1 nnet_7.3-12       
## [31] rprojroot_1.2      grid_3.4.2         glue_1.2.0        
## [34] R6_2.2.2           foreign_0.8-69     rmarkdown_1.8     
## [37] minqa_1.2.4        reshape2_1.4.2     purrr_0.2.4       
## [40] magrittr_1.5       splines_3.4.2      MASS_7.3-47       
## [43] backports_1.1.1    htmltools_0.3.6    pbkrtest_0.4-7    
## [46] assertthat_0.2.0   mnormt_1.5-5       quantreg_5.34     
## [49] stringi_1.1.6
```

# References

<a name=bib-pwr></a>[[1]](#cite-pwr) S. Champely. _pwr: Basic
Functions for Power Analysis_. R package version 1.2-1. 2017. URL:
[https://CRAN.R-project.org/package=pwr](https://CRAN.R-project.org/package=pwr).
