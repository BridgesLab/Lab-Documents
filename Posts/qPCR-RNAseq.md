# Validation of RNAseq Experiments by qPCR?

This was originally posted [here](http://dave-bridges.blogspot.com/2014/11/validation-of-rnaseq-experiments-by-qpcr.html) on 9 November 2014:

This post is in response to a couple of twitter discussions regarding whether its "useful" to do <a href="http://en.wikipedia.org/wiki/Real-time_polymerase_chain_reaction">qPCR</a> validation of <a href="http://en.wikipedia.org/wiki/RNA-Seq">RNAseq</a> hits:

<blockquote class="twitter-tweet" lang="en">
As preliminary data for a talk can I graph transcript counts of particular genes (transcriptome data) instead of qPCR (haven't done it yet)?
— Sciencegurl (@sciencegurlz0) <a href="https://twitter.com/sciencegurlz0/status/526718661646876672">October 27, 2014</a></blockquote>


<script async="" charset="utf-8" src="//platform.twitter.com/widgets.js"></script>

In response to the that I posted a response I made in response to a similar query from a reviewer for a recent manuscript (original available <a href="https://github.com/BridgesLab/CushingAcromegalyStudy/issues/41#issuecomment-60597409">here</a>).  Based on the fact that this came up a couple times in two weeks, I thought that I'd try to be more clear on my thoughts (and put them somewhere easier for others to find).  This is how we address this issue experimentally, and in response to reviewer requests.  Feel free to use any of these arguments yourself but your mileage with your supervisor/manuscript or grant reviewers may vary.  Most importantly, if you have some suggestions/data/papers that we should include please comment below and I'll try to keep this post up to date.
<h3>
The Answer We Gave:</h3>
<blockquote>
We had considered performing qPCR studies to ‘re-validate’ some of our gene-expression findings but there is little evidence that qPCR analyses from the same samples will add any extra utility to our data so we decided to eschew those experiments. Previous studies have shown extremely close correlations between qPCR and RNAseq data [1-4]. Ideally, we would re-validate our findings (potentially by qPCR) in a separate cohort of samples, but due to the difficulty in accessing these samples, those experiments are not possible at this time.</blockquote>

<h3>
What Do We Mean By Validation of RNAseq Results?</h3>
<div>
RNAseq, like microarrays before them generate a lot of data.  Ideally you can determine the levels of every gene/transcript/exon in the genome, and given proper experimental design determine a large number of significantly differentially expressed genes.  To follow up these findings, we often want to test how valid those observations are.  In my interpretation, this can mean a few different things:
<ol>
<li>Are these transcripts really differentially expressed in these samples (technical reproducibility)?</li>
<li>Are these transcripts really generally differentially expressed in other samples (biological reproducibility)?</li>
<li>Do these transcriptional changes represent phenotypic differences (significance)?</li>
</ol>
For the third question, I'd say you'd want to perform some non-transcriptional response such as a western blot, enzymatic or cell based assay to show that the transcriptional change has some biological phenotype.  Ideally, you may even go farther and manipulate the expression of a gene of interest back to the control condition, to test the hypothesis that a change in that gene is causative of some particular phenotype.&nbsp;</div>
<div>
<h3>
Why was qPCR the traditional validation experiment from microarray studies?</h3>
</div>
<div>
Normally though, the question of validation stems from one of the first two questions.  This is probably based on prior work with microarrays.  <a href="http://en.wikipedia.org/wiki/DNA_microarray">Microarrays</a> were/are great tools for transcriptomic analysis (though I am hard pressed to think of a reason to do them in lieuw of RNAseq).  One major problem with microarrays was probe bias.  What this means is that there was a limited number of hybridization probes in a microarray experiment, and its possible that this probe may not be representative of the transcript as a whole.  Furthermore, not all transcripts of interest may be present on the microarray of choice.  As a result, the standard in the field was to examine transcript abundance by qPCR to technically validate microarray results.</div>
<div>
<h3>
How similar are RNAseq and qPCR results?</h3>
</div>
<div>
Probe bias, poor sensitivity and reduced linear range are not as problematic in RNAseq experiments, since the entire transcript is assessed in a more or less unbiased manner [5].  Several studies have compared RNAseq results to qPCR data, and have found excellent correlation between these methods [1-4].  In cases where there are discrepancies exist, I would argue that it is most likely due to bias in the qPCR experiment (which has its own probe-bias based on what region of the cDNA is amplified).  Therefore, it is unlikely to yield new information, and when it does, the information is probably worse than the quality of RNAseq data.</div>
<div>
<h3>
Under What Conditions Would qPCR Be a Good Validation Method?</h3>
This isn't to say qPCR isn't useful, we use it all the time in my lab.  Its a great tool for looking at a small number of genes in samples for example.  But when would it be good to use in the context of validating a RNAseq experiment?  I would argue that it is most useful in the case where you have independent samples from those that you did your RNAseq studies on.  For example, maybe for economical reasons, you examined 5 control samples and 5 drug-treated samples but you have another 20 samples available.  qPCR would be a great way to test whether the differences observed are also true in separate samples, thus answering question #2.  I think this is especially important as in my experience a lot of RNAseq studies are underpowered to answer the questions asked (if you want a quick and easy way to check the power of your experimental design I like <a href="http://bioinformatics.bc.edu/marthlab/scotty/scotty.php">Scotty</a>).</div>
<div>
<h3>
References</h3>
</div>
<div>
Thanks to <a href="http://genomebio.org/">Matthew MacManes</a> (@<a href="http://twitter.com/macmanes">macmanes</a>) and Alejandro Montenegro (@<a href="http://twitter.com/aemonten">aemonten</a>) for spurring this discussion, and sending me towards a nice paper by <a href="http://hugheslab.ccbr.utoronto.ca/">Timothy Hughes</a> [6], which is a great summary of similar, more general issues.</div>
<div>
<ol>
<li>Griffith M, Griffith OL, Mwenifumbo J, Goya R, Morrissy a S, et al. (2010) Alternative expression analysis by RNA sequencing. Nat Methods 7: 843–847. doi:<a href="http://dx.doi.org/10.1038/nmeth.1503">10.1038/nmeth.1503</a>.</li>
<li>Asmann YW, Klee EW, Thompson EA, Perez E a, Middha S, et al. (2009) 3’ tag digital gene expression profiling of human brain and universal reference RNA using Illumina Genome Analyzer. BMC Genomics 10: 531. doi:<a href="http://dx.doi.org/10.1186/1471-2164-10-531">10.1186/1471-2164-10-531</a>.</li>
<li>Wu AR, Neff NF, Kalisky T, Dalerba P, Treutlein B, et al. (2014) Quantitative assessment of single-cell RNA-sequencing methods. Nat Methods 11: 41–46. doi:<a href="http://dx.doi.org/10.1038/nmeth.2694">10.1038/nmeth.2694</a>.</li>
<li>Shi Y, He M (2014) Differential gene expression identified by RNA-Seq and qPCR in two sizes of pearl oyster (Pinctada fucata). Gene 538: 313–322. doi:<a href="http://dx.doi.org/10.1016/j.gene.2014.01.031">10.1016/j.gene.2014.01.031</a>.</li>
<li>Wang Z, Gerstein M, Snyder M (2009) RNA-Seq: a revolutionary tool for transcriptomics. Nat Rev Genet 10: 57–63. doi: <a href="http://dx.doi.org/10.1038/nrg2484">10.1038/nrg2484</a>.</li>
<li><div style="margin-left: 32pt; text-indent: -32.0pt;">
Hughes TR (2009) “Validation” in genome-scale research. J Biol 8: 3. doi:<a href="http://dx.doi.org/10.1186/jbiol104">10.1186/jbiol104</a>.</div>
</li>
</ol>
</div>
