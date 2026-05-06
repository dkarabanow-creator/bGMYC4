\name{spec.probmat}
\alias{spec.probmat}
\title{
Return matrix of probability of conspecificity.
}
\description{
This function processes output from bgmyc analysis and yields a matrix of the probability of conspecificity 
for each pair of leaves in the given distribution of trees.
}
\usage{
spec.probmat(res)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{res}{
output from function bgmyc.spec}
}
\value{
A matrix of tree leaves by tree leaves whose values are the probability of conspecificity.
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
