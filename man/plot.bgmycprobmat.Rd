\name{plot.bgmycprobmat}
\alias{plot.bgmycprobmat}
\title{
Plots the matrix of probability of conspecificity.
}
\description{
Plots the matrix of probability of conspecificity along with a tree and a legend in order to visualize results.
}
\usage{
\method{plot}{bgmycprobmat}(x, tree, ...)
}
\arguments{
\item{x}{
output from spec.probmat, a matrix of conspecificity probabilities.}
\item{tree}{
a single tree in "phylo" object format, used to order the matrix tips.}
\item{...}{
additional arguments passed to plot.}
}
\details{
A plotting function that visualizes the matrix of probabilities of conspecificity.
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
