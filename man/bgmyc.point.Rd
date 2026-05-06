\name{bgmyc.point}
\alias{bgmyc.point}
\title{
Returns a point estimate of species limits based on a posterior probability threshold input by the user.
}
\description{
This function processes output from a bgmyc analysis and produces a single point estimate of species limits based on a posterior probability threshold.
}
\usage{
bgmyc.point(probmat, ppcutoff)
}
\arguments{
  \item{probmat}{
output from function spec.probmat of class "bgmycprobmat"}
  \item{ppcutoff}{
a posterior probability threshold for lumping samples into species. e.g. if 0.05 were selected, 
all individuals having greater than 0.05 posterior probability of conspecificity will be lumped into species returned.}
}
\value{
Returns an R list where each entry gives the members of a species that meets the threshold. 
It is worth noting that sometimes, because of uncertainty in the phylogenetic tree, not all individuals in a "species" resulting 
from a given threshold will have greater than the specified probability of conspecificity. 
They can all be connected, however, through individuals whose probability of conspecificity is greater than the threshold.
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
