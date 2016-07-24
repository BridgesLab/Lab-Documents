# Why do we use the negative binomial distribution for analysing RNAseq data?

This post is in reference to a workshop held at UTHSC about methodologies in RNAseq.  One issue that was discussed was why tools such as DESeq, Cuffdiff and EdgeR use a negative binomial distribution with generalized linear models to determine significance.  Our lab currently uses the following pipeline to analyse our data:

* [Tophat](https://ccb.jhu.edu/software/tophat/index.shtml)/[Bowtie](http://bowtie.cbcb.umd.edu/) to align the reads to a [GENCODE](http://www.gencodegenes.org/) genome version (We are currently testing using [kallisto](https://github.com/pachterlab/kallisto) instead of tophat2/bowtie/htseq)
* [HTSeq](http://www-huber.embl.de/users/anders/HTSeq/doc/overview.html) to annotate reads to known genomic features
* [DESeq2](http://bioconductor.org/packages/release/bioc/html/DESeq2.html) to perform differential expression analyses 

If you want more specifics about our current (and evolving) approaches see our recent papers in [PLOS One](http://dx.doi.org/10.1371/journal.pone.0129359) and [JME](http://dx.doi.org/10.1530/JME-15-0119) or the associated repository with all the raw data and code on [Github](http://bridgeslab.github.io/CushingAcromegalyStudy/).

First of all, since reads are count based, they can't be normally distributed (you can't have -3 counts, or 12.2 counts). Two distributions for count based data are [poisson](https://en.wikipedia.org/wiki/Poisson_distribution) (which presumes the variance and mean [ie expression in our case] are equal) or [negative binomial](https://en.wikipedia.org/wiki/Negative_binomial_distribution) (which does not).  This is especially a problem when the number of biological replicates are low because it is hard to accurately model variance of count based data if you are looking at only that gene and making the assumptions of normally distributed continuous data (ie a *t*-test).  A good estimate of variance for each gene is essential to determine whether the changes are due to chance.

Most RNAseq tools allow for the global variance (ie for a gene in 'general') to be estimated for a certain read density.  This generates a more accurate estimate of the variance than looking at each individual gene's (potentially small n) distribution because you can make some assumptions in general about how low expressing and high expressing genes vary.  

This variance parameter is then used to model the NB distribution for each gene (because it allows for expression and variance to be unlinked) and therefore to more accurately estimate the error term.  As the number of samples increases, the local (gene-specific) variance can be better estimated (but the expression will generally follow a skewed, stochastic and non-normal distribution).
