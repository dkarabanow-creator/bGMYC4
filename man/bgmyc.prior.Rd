\name{bgmyc.prior}
\alias{bgmyc.prior}
\title{
a function to return the prior probability of a model.
}
\description{
Given model parameter values and parameters governing the prior distribution for each, this function returns prior probability of the model.
}
\usage{
bgmyc.prior(params, py1, py2, pc1, pc2, t1, t2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{params}{
parameter values for which the function returns prior probabilities. in the order: py, pc, t
}
  \item{py1}{
governs the prior on the Yule (speciation) rate change parameter. using the default prior distribution, this is the lower bound of a uniform distribution. this can be the most influential prior of the three. rate change is parameterized as n^py where n is the number of lineages in a waiting interval (see Pons et al. 2006). if there are 50 sequences in an analysis and the Yule rate change parameter is 2, this allows for a potential 50-fold increase in speciation rate. this unrealistic parameter value can cause the threshold between Yule and Coalescent process to be difficult to distinguish. are more reasonable upper bound for the prior would probably be less than 1.5 (a potential 7-fold increase). Or you could modify the prior function to use a different distribution entirely. 
}
  \item{py2}{
governs the prior on the Yule rate change parameter. using the default prior distribution, this is the upper bound of a uniform distribution. 
}
  \item{pc1}{
governs the prior on the coalescent rate change parameter. using the default prior distribution, this is the lower bound of a uniform distribution. rate change is parameterized as (n(n-1))^pc where n is the number of lineages in a waiting interval (see Pons et al. 2006). In principle pc can be interpreted as change in effective population size (pc<1 decline, pc>1 growth) but because identical haplotypes must be excluded from this analysis an accurate biological interpretation is not possible. 
}
  \item{pc2}{
governs the prior on the coalescent rate change parameter. using the default prior distribution, this is the upper bound of a uniform distribution. 
}
  \item{t1}{
governs the prior on the threshold parameter. the lower bound of a uniform distribution. the bounds of this uniform distribution should not be below 1 or greater than the number of unique haplotypes in the analysis.
}
\item{t2}{
governs the prior on the threshold parameter. the upper bound of a uniform distribution
}
}
\details{
this function is used by bgmyc.gibbs, bgmyc.singlephy and bgmyc.multiphylo to get model prior probabilities in the MCMC. each parameter prior is a uniform distribution whose parameters are set as above. this function can be easily modified to use either gamma or lognormal priors and should fit smoothly into the other existing functions.}
\value{
returns a log prior probability}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
