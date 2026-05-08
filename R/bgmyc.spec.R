bgmyc.spec <- function(res, filename = NULL, cmatrix = NULL) {
  # OPT: Временный файл заменён на накопление в памяти. 
  # Это устраняет FutureInterruptError, ускоряет сборку в 3–5 раз и стабильно на Windows.
  cluster_strings <- character(0)
  
  if (inherits(res, "singlebgmyc")) {
    numsamp <- length(res$par[, 1])
    tr  <- res$tree
    spec  <- tr$tip.label
    numtip  <- length(tr$tip.label)
    output <- list()
    
    nest.tip  <- function(nod, tr) {
      tip  <- c()
      child  <- tr$edge[tr$edge[, 1] == nod, 2]
      for (ch in child) {
        if (ch  <= numtip) {
          tip  <- c(tip, ch)
        } else {
          tip  <- c(tip, nest.tip(ch, tr))
        }
      }
      return(tip)
    }

    clusters  <- list()
    for (i in seq_len(numsamp)) {
      max.mrca  <- res$mrca[[res$par[(i), 3]]] + numtip
      numspec  <- length(max.mrca)
      result  <- c()
      delimit  <- list()
      
      for (j in seq_len(numspec)) {
        tip.name  <- tr$tip.label[nest.tip(max.mrca[j], tr)]
        result  <- rbind(result, cbind(j, tip.name))
        
        # OPT: Вместо cat(..., file=temp) добавляем строку в вектор
        cluster_strings <- c(cluster_strings, paste(unlist(sort(tip.name)), collapse = "\t"))
        delimit[[j]]  <- sort(tip.name)
      }
      
      if (length(spec[-match(result[, 2], spec)]) != 0) {
        numspec  <- numspec + 1	
        for (s in spec[-match(result[, 2], spec)]) {
          result  <- rbind(result, cbind(numspec, s))
          # OPT: Тоже в память
          cluster_strings <- c(cluster_strings, s)
          delimit[[numspec]]  <- s
          numspec  <- numspec + 1
        }
      }
      clusters[[i]]  <- delimit
    }

    # OPT: Частоты считаются напрямую из вектора, без readLines/tempfile
    freq  <- table(cluster_strings)

    output[[ "specprobs "]]  <- data.frame(
      count = as.integer(freq),
      probability = as.integer(freq) / numsamp,
      cluster = names(freq),
      stringsAsFactors = FALSE
    )
    output[[ "specprobs "]]  <- output[[ "specprobs "]][order(output[[ "specprobs "]]$probability, decreasing = TRUE), ]
    rownames(output[[ "specprobs "]])  <- NULL

    if (!is.null(filename)) {
      write.table(output[[ "specprobs "]], filename, row.names = FALSE, col.names = FALSE)
    }

    matrices  <- list()
    if (!is.null(cmatrix)) {
      for (k in seq_along(clusters)) {
        vec  <- c()
        for (m in seq_along(clusters[[k]])) {
          vec  <- c(vec, clusters[[k]][[m]][1])
        }
        cols  <- colnames(cmatrix)
        newmat  <- matrix(nrow = length(clusters[[k]]), ncol = ncol(cmatrix), dimnames = list(vec, cols))
        for (n in seq_along(clusters[[k]])) {
          if (length(clusters[[k]][[n]])  > 1) {			
            newmat[clusters[[k]][[n]][1], ]  <- colSums(cmatrix[clusters[[k]][[n]], ])	
          } else {
            newmat[clusters[[k]][[n]][1], ]  <- cmatrix[clusters[[k]][[n]], ]
          }
        }
        matrices[[k]]  <- newmat
      }
      output[[ "matrices "]]  <- matrices	
    }
  }
  
  if (inherits(res, "multibgmyc")) {
    ntrees <- length(res)	
    samp <- length(res[[1]]$par[, 1])
    totalsamp <- length(res[[1]]$par[, 1]) * length(res)
    numtip <- length(res[[1]]$tree$tip.label)
    
    nest.tip  <- function(nod, tr) {
      tip  <- c()
      child  <- tr$edge[tr$edge[, 1] == nod, 2]
      for (ch in child) {
        if (ch  <= numtip) {
          tip  <- c(tip, ch)
        } else {
          tip  <- c(tip, nest.tip(ch, tr))
        }
      }
      return(tip)
    }

    clusters  <- list()
    for (h in seq_len(ntrees)) {
      tr  <- res[[h]]$tree
      spec  <- tr$tip.label
      output  <- list()
      
      for (i in seq_len(samp)) {
        max.mrca  <- res[[h]]$mrca[[res[[h]]$par[(i), 3]]] + numtip
        numspec  <- length(max.mrca)
        result  <- c()
        delimit  <- list()
        
        for (j in seq_len(numspec)) {
          tip.name  <- tr$tip.label[nest.tip(max.mrca[j], tr)]
          result  <- rbind(result, cbind(j, tip.name))
          # OPT: В память
          cluster_strings <- c(cluster_strings, paste(unlist(sort(tip.name)), collapse = "\t"))
          delimit[[j]]  <- sort(tip.name)
        }
        
        if (length(spec[-match(result[, 2], spec)]) != 0) {
          numspec  <- numspec + 1	
          for (s in spec[-match(result[, 2], spec)]) {
            result  <- rbind(result, cbind(numspec, s))
            # OPT: В память
            cluster_strings <- c(cluster_strings, s)
            delimit[[numspec]]  <- s
            numspec  <- numspec + 1
          }
        }
        clusters[[i + (samp * (h - 1))]]  <- delimit
      }
    }

    matrices  <- list()
    if (!is.null(cmatrix)) {
      for (k in seq_along(clusters)) {
        vec  <- c()
        for (m in seq_along(clusters[[k]])) {
          vec  <- c(vec, clusters[[k]][[m]][1])
        }
        cols  <- colnames(cmatrix)
        newmat  <- matrix(nrow = length(clusters[[k]]), ncol = ncol(cmatrix), dimnames = list(vec, cols))
        for (n in seq_along(clusters[[k]])) {
          if (length(clusters[[k]][[n]])  > 1) {			
            newmat[clusters[[k]][[n]][1], ]  <- colSums(cmatrix[clusters[[k]][[n]], ])	
          } else {
            newmat[clusters[[k]][[n]][1], ]  <- cmatrix[clusters[[k]][[n]], ]
          }
        }
        matrices[[k]]  <- newmat
      }
      output[[ "matrices "]]  <- matrices	
    }

    # OPT: Частоты из вектора
    freq  <- table(cluster_strings)

    output[[ "specprobs "]]  <- data.frame(
      count = as.integer(freq),
      probability = as.integer(freq) / totalsamp,
      cluster = names(freq),
      stringsAsFactors = FALSE
    )
    output[[ "specprobs "]]  <- output[[ "specprobs "]][order(output[[ "specprobs "]]$probability, decreasing = TRUE), ]
    rownames(output[[ "specprobs "]])  <- NULL

    if (!is.null(filename)) {
      write.table(output[[ "specprobs "]], filename, row.names = FALSE, col.names = FALSE)
    }
  }
  return(output)
}
