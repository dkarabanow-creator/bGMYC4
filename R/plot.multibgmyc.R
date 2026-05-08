#' @export
plot.multibgmyc <- function(x, plot = TRUE, ...) {
  result <- x
  parmat <- c()
  for (i in 1:length(result)) {
    parmat <- rbind(parmat, result[[i]]$par)
  }
  
  if (plot) {
    par(mfrow = c(2, 2))
    ylabels <- c("p.div", "p.coal", "threshold", "logposterior")
    
    for (i in 1:4) {
      vals <- parmat[, i]
      # OPT: Защита от NA/Inf при визуализации агрегированных цепей
      if (any(is.finite(vals))) {
        plot(vals, xlab = "generations", ylab = ylabels[i])
      } else {
        plot(0, 0, type = "n", xlab = "generations", ylab = ylabels[i], 
             main = "No finite values", xaxt = "n", yaxt = "n")
        text(0, 0, labels = "Chains unstable", col = "red")
      }
    }
  } else {
    return(parmat)
  }
}
