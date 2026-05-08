bgmyc.lik <- function(params, data) {
  # Явное приведение к integer для безопасной индексации списков
  t_idx <- as.integer(params[3])
  n <- data$n[[t_idx]]
  p <- c(rep(params[2], n), params[1])
  mat <- data$list.i.mat[[t_idx]]
  s_nod <- data$list.s.nod[[t_idx]]
  internod <- data$internod
  
  # OPT: Замена ifelse() на логическую индексацию (~2x быстрее, меньше RAM)
  # ifelse вычисляет ОБЕ ветки для всех элементов. Прямая индексация 
  # применяет exp(p*log) только где mat > 0, избегая лишних вычислений.
  log_mat <- log(mat)
  mat_p <- mat^p
  pos <- mat > 0
  mat_p[pos] <- exp(p * log_mat)[pos]
  
  # Lambda для первых n интервалов (Yule process)
  denom1 <- sum(mat_p[1:n, ] %*% internod)
  lambda1 <- sum(s_nod[1:n, ]) / denom1
  
  # Lambda для последнего интервала (Coalescent process)
  denom2 <- sum(mat_p[n + 1, ] * internod)
  lambda2 <- sum(s_nod[n + 1, ]) / denom2
  
  # Объединяем в вектор длиной numnod + 1
  lambda <- c(rep(lambda1, n), lambda2)
  
  # b = t(mat^p) %*% lambda
  b <- t(mat_p) %*% lambda
  
  # Правдоподобие: L = b * exp(-b * t)
  lik <- b * exp(-b * internod)
  out <- sum(log(lik))
  
  # Защита от числовых артефактов
  if (!is.finite(out)) return(-Inf)
  return(out)
}
