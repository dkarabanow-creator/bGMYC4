#' @export
plot.singlebgmyc <-
function(x, burnin = 0, thinning = 1, ...) {
  result <- x  # присваиваем старому имени, чтобы не менять внутренний код
  par(mfrow = c(2, 2))
  ylabels <- c("p.div", "p.coal", "threshold", "logposterior")
  for (i in 1:4) {
    plot(result$par[, i][((burnin + 1) / thinning):(length(result$par[, 1]) / thinning) * thinning], 
         xlab = "generations", ylab = ylabels[i])
  }
}
