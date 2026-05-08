\name{bgmyc.multiphylo}
\alias{bgmyc.multiphylo}
\title{
Multi-tree GMYC analysis
}
\description{
conducts MCMC analysis for multiple trees.
}
\usage{
bgmyc.multiphylo(multiphylo, mcmc, burnin, thinning,
                 py1 = 0, py2 = 2, pc1 = 0, pc2 = 2,
                 t1 = 2, t2 = 51, scale = c(20, 10, 5),
                 start = c(1, 0.5, 50),
                 sampler = bgmyc.gibbs,
                 likelihood = bgmyc.lik, prior = bgmyc.prior)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{multiphylo}{
an ape "multiphylo" object
}
  \item{mcmc}{
number of samples to take from the Markov Chain
}
  \item{burnin}{
the number of samples to discard as burn-in
}
  \item{thinning}{
the interval at which samples are retained from the Markov Chain
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
governs the prior on the threshold parameter. the upper bound of a uniform distribution.
}
  \item{scale}{
a vector of scale parameters governing the proposal distributions for the markov chain. the first to are the Yule and coalescent rate change parameters. increasing them makes the proposals more conservative. the third is the threshold parameter. increasing it makes the proposals more liberal.
}
  \item{start}{
a vector of starting parameters in the same order as the scale parameters, py, pc, t. t may need to be set so that it is not impossible given the dataset. 
}
  \item{sampler}{
an MCMC sampler function. the only function provided is bgmyc.gibbs. 
}
  \item{likelihood}{
a function that calculates the likelihood of the data given the model and parameters. in this case, bgmyc.lik is the only function provided that will work. 
}
  \item{prior}{
a function that returns the prior probability of each parameter value. in this case bgmyc.prior is the only function provided. that function could in principle be easily modified and a new one used here. e.g., replace the uniform distribution density functions (dunif) with gamma or lognormal distributions (dgamma, dlnorm). 
}
}
\details{
conducts Markov Chain Monte Carlo sampling for the GMYC model for each of the trees in a "multiphylo" object. MCMC output should be checked for non-stationary behavior using plot(output). A matrix containing MCMC samples pooled across all trees can be obtained using plot(output, plot=FALSE)
}
\value{
a list of class "multibgmyc" containing a series of objects of class "singlebgmyc" each of which contains MCMC samples from each tree. 
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
\examples{
# Load test data
data(east10)

# Single tree analysis
result.single <- bgmyc.singlephy(
  phylo = east10[[1]], 
  mcmc = 100, burnin = 1, thinning = 10
)
plot(result.single)

# Multi-tree analysis (explicitly 2 trees to satisfy CRAN parallel limits)
result.multi <- bgmyc.multiphylo(
  multiphylo = east10[1:2], 
  mcmc = 100, burnin = 1, thinning = 10
)

# Post-processing
probmat <- spec.probmat(result.multi)
}
