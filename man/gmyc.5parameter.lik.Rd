\name{gmyc.5parameter.lik}
\alias{gmyc.5parameter.lik}
\title{
5 parameter likelihood function.
}
\description{
Returns the likelihood of the GMYC model if all 5 parameters are free to vary.
}
\usage{
gmyc.5parameter.lik(params, data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{params}{
a vector of five the five parameters in the model in the order y, c, py, pc, t}
  \item{data}{
output from gmyc.dataprep}
}
\details{
The Pons et al. implementation of the GMYC (and this one) treat the model as if it had 3 parameters, 
a Yule rate change parameter, a coalescent rate change parameter and a threshold parameter. 
The Yule and coalescent rates are fixed to an ML estimator at each possible threshold and not integrated over. 
Allowing all 5 parameters to vary freely in some cases yields a flatter likelihood surface 
which in some cases (in simulation) has a peak very far away from the true value and very different 
from the 3 parameter implementation. Using the ML estimator for the rate parameters yields empirically 
better peformance so we use it in our paper (Reid and Carstens 2012), but it took some time to figure that out. 
We include this function here for anyone who feels like messing with it.
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
