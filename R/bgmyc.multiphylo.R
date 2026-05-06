bgmyc.multiphylo <-
function(multiphylo, mcmc, burnin, thinning, py1=0, py2=2, pc1=0, pc2=2, t1=2, t2=51, scale=c(20, 10, 5.00), start=c(1.0, 0.5, 50.0), sampler=bgmyc.gibbs, likelihood=bgmyc.lik, prior=bgmyc.prior){
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

  # Internal function for processing a single tree
  process_single_tree <- function(tree_idx, phylo_list, mcmc, burnin, thinning, 
                                  py1, py2, pc1, pc2, t1, t2, scale, start, 
                                  sampler, likelihood, prior) {
    data <- bgmyc.dataprep(phylo_list[[tree_idx]])
    sampler(data, m = mcmc, burnin = burnin, thinning = thinning,
            py1 = py1, py2 = py2, pc1 = pc1, pc2 = pc2, t1 = t1, t2 = t2,
            scale = scale, start = start, likelihood = likelihood, prior = prior)
  }

  old_plan <- future::plan()
  on.exit(future::plan(old_plan), add = TRUE)
  
  n_workers <- parallel::detectCores(logical = FALSE)
  cat("[INFO] Starting parallel analysis (using", n_workers, "cores)...\n")
  future::plan(future::multisession, workers = n_workers)

  outputlist <- future.apply::future_lapply(
    seq_len(ntre),
    process_single_tree,
    phylo_list = multiphylo, mcmc = mcmc, burnin = burnin, thinning = thinning,
    py1 = py1, py2 = py2, pc1 = pc1, pc2 = pc2, t1 = t1, t2 = t2,
    scale = scale, start = start, sampler = sampler, likelihood = likelihood, prior = prior,
    future.seed = TRUE  # Added: parallel-safe random number generation
  )

  class(outputlist) <- "multibgmyc"
  cat("[OK] All trees processed. Assembling results...\n")
  return(outputlist)
}
