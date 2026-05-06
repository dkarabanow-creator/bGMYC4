## ----include = FALSE----------------------------------------------------------
# EN: Disable execution for CRAN checks to prevent timeouts on interactive MCMC.
# RU: Отключено выполнение для проверки CRAN, чтобы избежать таймаутов.
# Для локального запуска: измените eval = FALSE на eval = TRUE или запускайте блоки вручную.
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7, fig.height = 5,
  warning = FALSE, message = FALSE,
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
# library(ape)
# library(bGMYC4)  # Use devtools::load_all(".") during development
# 
# # EN: Safe numeric input with bounds checking / Безопасный ввод чисел с проверкой границ
# safe_num <- function(prompt, default, min_v = NULL, max_v = NULL, hint = "") {
#   if (!interactive()) return(default)
#   inp <- readline(sprintf("%s [%s] %s: ", prompt, default, hint))
#   if (inp == "") return(default)
#   val <- suppressWarnings(as.numeric(inp))
#   if (is.na(val)) {
#     cat("  ⚠️ Invalid/Неверный ввод. Оставляю текущее.\n")
#     return(default)
#   }
#   if (!is.null(min_v) && val < min_v) {
#     cat(sprintf("  ⚠️ < min (%s). Using %s.\n", min_v, min_v))
#     return(min_v)
#   }
#   if (!is.null(max_v) && val > max_v) {
#     cat(sprintf("  ⚠️ > max (%s). Using %s.\n", max_v, max_v))
#     return(max_v)
#   }
#   return(val)
# }
# 
# # EN: Read Nexus files while stripping BEAST2 metadata / Чтение Nexus с удалением метаданных BEAST2
# read_beast_nexus <- function(file_path) {
#   cat(sprintf("📥 Reading / Читаю: %s\n", basename(file_path)))
#   lines <- readLines(file_path, warn = FALSE)
#   lines <- gsub("\\[&[^]]*\\]", "", lines)  # Strip [&...] tags
#   tmp <- tempfile(fileext = ".trees")
#   writeLines(lines, tmp)
#   tr <- read.nexus(tmp)
#   unlink(tmp)
#   return(tr)
# }
# 
# # EN: Enforce ultrametricity with float rounding / Обеспечение ультраметричности
# fix_ultrametric <- function(tr) {
#   if (!is.ultrametric(tr)) {
#     cat("⚠️ Not ultrametric / Не ультраметрично. Округляю длины ветвей / Rounding edges...\n")
#     tr$edge.length <- round(tr$edge.length, 8)
#   }
#   if (!is.ultrametric(tr)) stop("❌ Still not ultrametric / Всё ещё не ультраметрично. Проверьте экспорт BEAST2.")
#   return(tr)
# }

## ----preprocessing------------------------------------------------------------
# cat("══════════════════════════════════════════════════════════════\n")
# cat("🌿 bGMYC4 Interactive Workflow / Интерактивный рабочий процесс\n")
# cat("══════════════════════════════════════════════════════════════\n")
# cat("Select data source / Выберите источник данных:\n")
# cat("  1. Built-in 'east10' / Встроенный датасет 'east10'\n")
# cat("  2. Custom BEAST2 files / Собственные файлы\n")
# choice <- safe_num("Enter 1 or 2 / Введите 1 или 2", 1, min_v = 1, max_v = 2)
# 
# if (choice == 1) {
#   data(east10)
#   tree_consensus <- east10[[1]]
#   all_trees <- east10
# } else {
#   cat("\n📂 Select directory / Выберите директорию:\n")
#   dir_path <- utils::choose.dir(default = getwd(), caption = "Select trees folder")
#   if (dir_path == "") stop("❌ Directory not selected / Директория не выбрана.")
#   setwd(dir_path)
#   tree_consensus <- read_beast_nexus(utils::choose.files(caption = "Select .tree file"))
#   all_trees      <- read_beast_nexus(utils::choose.files(caption = "Select .trees file"))
# }
# 
# ntips <- length(tree_consensus$tip.label)
# cat(sprintf("✅ Trees loaded / Загружено деревьев: %d | Tips / Таксонов: %d\n", length(all_trees), ntips))
# 
# # EN: Rooting check & outgroup removal / Проверка укоренения и удаление аутгрупп
# cat("\n🔍 Rooting check / Проверка укоренения:\n")
# cat("⚠️ GMYC requires strictly rooted trees / GMYC требует строго укоренённых деревьев.\n")
# if (!all(sapply(all_trees, is.rooted))) {
#   og_str <- readline("Enter outgroup(s) / Введите аутгруппу(ы) (comma-separated): ")
#   outgroups <- trimws(strsplit(og_str, ",")[[1]])
#   all_trees      <- lapply(all_trees, function(t) if (!is.rooted(t)) root(t, outgroups[1], resolve.root = TRUE) else t)
#   tree_consensus <- if (!is.rooted(tree_consensus)) root(tree_consensus, outgroups[1], resolve.root = TRUE) else tree_consensus
# }
# 
# cat("\n🔪 Remove taxa from analysis? / Удалить таксоны из анализа? (y/n): ")
# if (tolower(readline("")) %in% c("y", "yes", "да", "")) {
#   og_str <- readline("Enter taxa to drop / Введите таксоны для удаления (comma-separated): ")
#   drop_list <- trimws(strsplit(og_str, ",")[[1]])
#   tree_consensus <- drop.tip(tree_consensus, drop_list)
#   all_trees      <- lapply(all_trees, drop.tip, tip = drop_list)
#   class(all_trees) <- "multiPhylo"
#   ntips <- length(tree_consensus$tip.label)
#   cat(sprintf("✅ Tips remaining / Осталось таксонов: %d\n", ntips))
# }
# 
# # EN: Final ultrametric check & tree sampling / Финальная проверка и выборка
# tree_consensus <- fix_ultrametric(tree_consensus)
# all_trees      <- lapply(all_trees, fix_ultrametric)
# class(all_trees) <- "multiPhylo"
# 
# n_sample <- safe_num("How many trees to sample? / Сколько деревьев взять? (10-100 recommended)", 10, min_v = 1, max_v = length(all_trees))
# trees_sample <- sample(all_trees, n_sample)
# class(trees_sample) <- "multiPhylo"
# cat(sprintf("✅ Sampled / Выбрано: %d trees\n", n_sample))

## ----diagnostics-loop---------------------------------------------------------
# # EN: Initial parameters / Начальные параметры
# prm <- list(
#   mcmc = 5000, burnin = 1000, thinning = 10,
#   py1 = 0, py2 = 1.5, pc1 = 0, pc2 = 2.0,
#   t1 = 2, t2 = min(35, ntips - 5),
#   scale = c(25, 10, 5), start = c(1, 0.5, floor(ntips/3))
# )
# prm$start[3] <- max(prm$t1 + 1, min(prm$start[3], prm$t2 - 1)) # Safety clamp
# 
# # EN: Diagnostic printer & plotter / Функция диагностики и графиков
# show_diag <- function(res, prm) {
#   cat("\n📊 FULL DIAGNOSTICS / ПОЛНАЯ ДИАГНОСТИКА\n")
#   cat(sprintf("⚙️  Parameters: mcmc=%d | burnin=%d | thin=%d\n", prm$mcmc, prm$burnin, prm$thinning))
#   acc <- res$accept
#   cat(sprintf("📈 Acceptance rates: py=%.2f | pc=%.2f | t=%.2f [Optimal/Оптимум: 0.20–0.40]\n", acc[1], acc[2], acc[3]))
# 
#   par_vec <- res$par[, 4]
#   q <- split(par_vec, cut(seq_along(par_vec), 4, labels = FALSE))
#   cv <- sd(sapply(q, var)) / mean(sapply(q, var))
#   cat(sprintf("📉 Stationarity (CV<0.6): %s\n", ifelse(cv < 0.6, "✅ YES/ДА", "⚠️ CHECK/ПРОВЕРЬТЕ")))
# 
#   cat("\n💡 Recommendations / Рекомендации:\n")
#   if (acc[1] > 0.50) cat("   ↑ scale[1] or ↑ py2 (py too conservative)\n")
#   if (acc[1] < 0.15) cat("   ↓ scale[1] (py too bold)\n")
#   if (acc[2] > 0.50) cat("   ↑ scale[2]\n")
#   if (acc[2] < 0.15) cat("   ↓ scale[2]\n")
#   if (cv >= 0.6) cat("   ↑ burnin to 30% mcmc or ↑ mcmc (chain not stationary)\n")
#   if (cv < 0.6 && all(acc > 0.2 & acc < 0.45)) cat("   ✅ Parameters optimal. Ready for multi-tree.\n")
# 
#   cat("\n🖼️  Opening trace plots... / Открываю графики сходимости...\n")
#   plot(res)
#   cat("👀 Close plot window when done. / Закройте окно графиков, когда закончите.\n")
# }
# 
# # EN: Interactive tuning loop / Интерактивный цикл настройки
# cat("\n🔄 Starting diagnostic loop / Запускаю диагностику...\n")
# repeat {
#   cat("🚀 Running single-tree MCMC / Запуск MCMC на одном дереве...\n")
#   res <- bgmyc.singlephy(
#     phylo = tree_consensus, mcmc = prm$mcmc, burnin = prm$burnin, thinning = prm$thinning,
#     py1 = prm$py1, py2 = prm$py2, pc1 = prm$pc1, pc2 = prm$pc2, t1 = prm$t1, t2 = prm$t2,
#     scale = prm$scale, start = prm$start
#   )
#   show_diag(res, prm)
# 
#   cat("❓ Use these parameters for multi-tree analysis? / Использовать эти параметры? (y/n): ")
#   if (!interactive()) break
#   ans <- tolower(trimws(readline("")))
#   if (ans %in% c("y", "да", "")) break
# 
#   cat("\n🔧 Adjust parameters (Enter=keep current) / Настройка параметров (Enter=оставить текущее)\n")
#   prm$mcmc     <- safe_num("mcmc", prm$mcmc, min_v = 1000, hint = "[↑=more accurate]")
#   prm$burnin   <- safe_num("burnin", prm$burnin, min_v = 100, max_v = prm$mcmc - 100, hint = "[20-30% of mcmc]")
#   prm$thinning <- safe_num("thinning", prm$thinning, min_v = 1, hint = "[↓ autocorrelation]")
#   prm$py2      <- safe_num("py2", prm$py2, min_v = prm$py1 + 0.1, hint = "[≤1.5 recommended]")
#   prm$pc2      <- safe_num("pc2", prm$pc2, min_v = prm$pc1 + 0.1, hint = "[≤2.0]")
#   prm$t2       <- safe_num("t2", prm$t2, max_v = ntips - 2, hint = "[< number of tips]")
#   prm$scale    <- c(safe_num("scale[1]", prm$scale[1], min_v = 1),
#                     safe_num("scale[2]", prm$scale[2], min_v = 1),
#                     safe_num("scale[3]", prm$scale[3], min_v = 1))
#   prm$start    <- c(safe_num("start[1]", prm$start[1], min_v = 0),
#                     safe_num("start[2]", prm$start[2], min_v = 0),
#                     safe_num("start[3]", prm$start[3], min_v = prm$t1 + 1, max_v = prm$t2 - 1))
#   prm$start[3] <- max(prm$t1 + 1, min(prm$start[3], prm$t2 - 1))
# }

## ----final-analysis-----------------------------------------------------------
# cat("\n🌲 Running multi-tree analysis / Запуск анализа на множестве деревьев...\n")
# result_multi <- bgmyc.multiphylo(
#   multiphylo = trees_sample, mcmc = 50000, burnin = 10000, thinning = 25,
#   py1 = prm$py1, py2 = prm$py2, pc1 = prm$pc1, pc2 = prm$pc2,
#   t1 = prm$t1, t2 = prm$t2, scale = prm$scale, start = prm$start
# )
# 
# cat("\n🌡️  Building heatmap / Строю тепловую карту...\n")
# prob_mat <- spec.probmat(result_multi)
# plot(prob_mat, trees_sample[[1]])  # Ordered by tree topology / Упорядочено по топологии
# 
# cat("\n🔍 Delimitation (PP > 0.05) / Делимитация (PP > 0.05)...\n")
# out <- bgmyc.point(prob_mat, ppcutoff = 0.05)
# cat("✅ Clusters / Кластеров:", length(out), "\n")
# for (i in seq_along(out)) {
#   cat(paste0("  ", i, ": ", paste(out[[i]][1:4], collapse = ", "),
#              if (length(out[[i]]) > 4) "...\n" else "\n"))
# }
# 
# save(prm, res, result_multi, prob_mat, out, file = "bGMYC_final_results.RData")
# cat("💾 Results saved / Результаты сохранены.\n🎉 Analysis complete / Анализ завершён!\n")

