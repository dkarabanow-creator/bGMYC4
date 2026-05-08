\name{plot.multibgmyc}
\alias{plot.multibgmyc}
\title{
Plot MCMC output.
}
\description{
Plots pooled MCMC output from multiple trees.
}
\usage{
\method{plot}{multibgmyc}(x, plot = TRUE, ...)
}
\arguments{
\item{x}{
object of class "multibgmyc", output from bgmyc.multiphylo.}
\item{plot}{
logical. If TRUE, produces trace plots. If FALSE, returns a matrix of pooled parameters.}
\item{...}{
additional arguments passed to plot.}
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}
