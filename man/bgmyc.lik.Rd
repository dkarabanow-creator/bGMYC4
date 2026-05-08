\name{bgmyc.lik}
\alias{bgmyc.lik}
\title{
GMYC likelihood function
}
\description{
Returns the log likelihood of the model given the data and parameter values.
}
\usage{
bgmyc.lik(params, data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{params}{
a vector of parameter values to be evaluated in the order: py, pc, t}
  \item{data}{
an output from gmyc.dataprep}
}
\details{
there probably isn't any reason to use this function on its own, but it can be optimized using "optim"}
\value{
returns the log likelihood of the model given data and parameter values}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
