\name{plot.bgmycprobmat}
\alias{plot.bgmycprobmat}
\title{
Plots the matrix of probability of conspecificity.}
\details{
A plotting function that visualizes the matrix of probabilities of conspecificity.
}
\usage{
\method{plot}{bgmycprobmat}(x, tree, palette = "classic", save_pdf = NULL, legend_cex = 0.5, ...)
}
\arguments{
\item{x}{A matrix of conspecificity probabilities (output of spec.probmat)}

\item{tree}{A phylogenetic tree (phylo object), must match the matrix dimensions}

\item{palette}{Character; color palette (default: "classic")}

\item{save_pdf}{Character or NULL; output PDF path}

\item{legend_cex}{Numeric; legend text size (default: 0.5)}

\item{...}{Additional graphical parameters (currently unused)}
}
\value{
None; produces a plot as a side effect
}
\description{
Visualizes the conspecificity probability matrix alongside the phylogenetic tree.
Enhanced version with customizable color palettes and export options.
}
\examples{
\dontrun{
  data(east10)
  result  <- bgmyc.singlephy(east10[[1]], mcmc = 1000, burnin = 200)
  prob_mat  <- spec.probmat(result)
  plot(prob_mat, east10[[1]])
  plot(prob_mat, east10[[1]], palette = "viridis", save_pdf = "fig.pdf")
}
}
\author{
Noah M. Reid
Maintainer: Dmitry Karabanov <dk@ibiw.ru>
}