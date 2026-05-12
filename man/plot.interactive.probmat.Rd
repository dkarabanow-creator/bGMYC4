\name{plot.interactive.probmat}
\alias{plot.interactive.probmat}
\title{
Interactive plot method for bgmycprobmat objects}
\description{
Creates an interactive heatmap of conspecificity probabilities using plotly,
with a phylogenetic tree aligned on the left side.
}
\usage{
\method{plot}{interactive.probmat}(
  x,
  tree,
  palette = "green",
  show_tree = TRUE,
  tree_width = 0.3,
  width = 1400,
  height = 1000,
  save_html = NULL,
  ...
)
}
\arguments{
\item{x}{A matrix of conspecificity probabilities (output of spec.probmat)}

\item{tree}{A phylogenetic tree (phylo object), must match the matrix dimensions}

\item{palette}{Character; color palette: "green" (default), "viridis", "RdYlBu", "classic"}

\item{show_tree}{Logical; if TRUE, displays phylogenetic tree on the left (default: TRUE)}

\item{tree_width}{Numeric; relative width of tree panel (0-1, default: 0.3)}

\item{width}{Numeric; total plot width in pixels (default: 1400)}

\item{height}{Numeric; total plot height in pixels (default: 1000)}

\item{save_html}{Character or NULL; if provided, saves interactive plot to this HTML file}

\item{...}{Additional arguments passed to ape::plot.phylo for tree styling}
}
\value{
A plotly object (invisibly); also saves to HTML if save_html is specified
}
\examples{
\dontrun{
data(east10)
res <- bgmyc.singlephy(east10[[1]], mcmc = 1000, burnin = 200, thinning = 10)
prob_mat <- spec.probmat(res)
plot.interactive.probmat(prob_mat, east10[[1]])
plot.interactive.probmat(prob_mat, east10[[1]], save_html = "heatmap.html")
}
}
\author{
Qwen 3.6
Dmitry Karabanov <dk@ibiw.ru>
}
