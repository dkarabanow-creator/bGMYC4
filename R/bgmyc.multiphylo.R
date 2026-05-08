bgmyc.multiphylo <- function(multiphylo, mcmc, burnin, thinning, py1=0, py2=2, pc1=0, pc2=2, t1=2, t2=51, scale=c(20, 10, 5.00), start=c(1.0, 0.5, 50.0), sampler=bgmyc.gibbs, likelihood=bgmyc.lik, prior=bgmyc.prior) {
  ntre <- length(multiphylo)
  cat("You are running a multi tree analysis on ", ntre, " trees.\n")
  cat("These trees each contain ", length(multiphylo[[1]]$tip.label), " tips.\n")
  cat("The Yule process rate change parameter has a uniform prior ranging from ", py1, " to ", py2, ".\n")
  cat("The coalescent process rate change parameter has a uniform prior ranging from ", pc1, " to ", pc2, ".\n")
  cat("The threshold parameter, which is equal to the number of species, has a uniform prior ranging from ", t1, " to ", t2, ". The upper bound of this prior should not be more than the number of tips in your trees.\n")
  cat("The MCMC will start with the Yule parameter set to ", start[1], ".\n")
  cat("The MCMC will start with the coalescent parameter set to ", start[2], ".\n")
  cat("The MCMC will start with the threshold parameter set to ", start[3], ". If this number is greater than the number of tips in your tree, an error will result.\n")
  cat("Given your settings for mcmc, burnin and thinning, your analysis will result in ", ((mcmc-burnin)/thinning)*ntre, " samples being retained.\n")

# OPT: Robust worker detection for CRAN/Check environments
n_workers <- parallel::detectCores(logical = FALSE)
if (is.na(n_workers) || n_workers < 1) n_workers <- 2L

# Never spawn more workers than trees
n_workers <- min(n_workers, ntre)
cat(sprintf("[INFO] Starting parallel analysis (using %d cores)...\n", n_workers))

  cl <- parallel::makeCluster(n_workers)
  on.exit(parallel::stopCluster(cl), add = TRUE)

  # Загружаем пакет в каждый воркер. 
  # ВАЖНО: Работает ТОЛЬКО после devtools::install(), а не load_all()!
  parallel::clusterEvalQ(cl, {
    library(bGMYC4)
    library(ape)
    NULL
  })

  # Замыкание автоматически захватывает все аргументы из родительской среды
  process_tree <- function(idx) {
    data <- bgmyc.dataprep(multiphylo[[idx]])
    sampler(data, m = mcmc, burnin = burnin, thinning = thinning,
            py1 = py1, py2 = py2, pc1 = pc1, pc2 = pc2, t1 = t1, t2 = t2,
            scale = scale, start = start, likelihood = likelihood, prior = prior)
  }

  # Чистый параллельный запуск без прогресс-баров (они блокируют PSOCK-сокеты Windows)
  outputlist <- parallel::parLapply(cl, seq_len(ntre), process_tree)

  class(outputlist) <- "multibgmyc"
  cat("[OK] All trees processed. Assembling results...\n")
  return(outputlist)
}
