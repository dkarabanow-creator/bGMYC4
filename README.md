# bGMYC4
## *Bayesian species delimitation, made reproducible and accessible*

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![R-CMD-check](https://github.com/dkarabanow-creator/bGMYC4/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dkarabanow-creator/bGMYC4/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/bGMYC4)](https://CRAN.R-project.org/package=bGMYC4)

**Bayesian General Mixed Yule-Coalescent (GMYC) model for species delimitation in R ≥ 4.5**

---

## 🌍 Overview 

**EN:** bGMYC4 implements a Bayesian version of the General Mixed Yule-Coalescent model for species delimitation from single-locus data. It uses Markov Chain Monte Carlo (MCMC) simulation to evaluate the posterior distribution of species boundaries, allowing the use of multiple phylogenetic trees to account for phylogenetic uncertainty. The package includes interactive diagnostics, parameter tuning, and visualization tools.

---

## ✨ Key Features 

| Feature | Description |
|---------|-------------|
| 🌲 Single & Multi-tree analysis | Run GMYC on one tree or pool uncertainty across multiple BEAST2 trees |
| 📊 Interactive diagnostics | Real-time MCMC convergence checks with trace plots and acceptance rate guidance |
| ⚙️ Parameter tuning | Safe input handlers with biological hints for priors, scales, and thresholds |
| 🌡️ Heatmap visualization | Conspecificity probability matrices ordered by tree topology |
| 🌐 Bilingual workflow | Full EN/RU documentation and interactive vignette |
| 🧬 BEAST2 ready | Automatic cleaning of Nexus annotations and ultrametricity enforcement |
| ⚡ Optimized performance | Parallel `bgmyc.multiphylo()`, pure-R post-processing, vectorized matrices |

---

## 📦 Installation 

### 🔹 From GitHub (recommended)
```r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("dkarabanow-creator/bGMYC4", build_vignettes = TRUE)
```

### 🔹 From source archive
```r
install.packages("path/to/bGMYC4_4.1.0.tar.gz", repos = NULL, type = "source")
# To build vignettes locally:
# install.packages("path/to/bGMYC4_4.1.0.tar.gz", repos = NULL, type = "source", build_vignettes = TRUE)
```

### 🔹 System requirements
- **R ≥ 4.5.1** (tested on 4.5.1–4.5.3)
- **OS:** Windows 10/11, macOS, Linux
- **Dependencies:** `ape`, `future`, `future.apply`, `parallel`, `knitr`, `rmarkdown`

---

## 🚀 Quick Start 

### 1. Load the package
```r
library(bGMYC4)
```

### 2. Open the interactive tutorial
```r
browseVignettes("bGMYC4")
# Or run directly:
vignette("bGMYC4-interactive", package = "bGMYC4")
```

### 3. Run a minimal example
```r
# Load built-in test data
data(east10)

# Run single-tree analysis (short MCMC for testing)
result <- bgmyc.singlephy(
  phylo = east10[[1]],
  mcmc = 1000, burnin = 200, thinning = 10,
  py1 = 0, py2 = 1.5, pc1 = 0, pc2 = 2,
  t1 = 2, t2 = 35,
  scale = c(20, 10, 5),
  start = c(1, 0.5, 10)
)

# Check convergence
plot(result)

# Build conspecificity matrix
prob_mat <- spec.probmat(result)
plot(prob_mat, east10[[1]])

# Extract species clusters (your threshold)
out <- bgmyc.point(prob_mat, ppcutoff = 0.05)
cat("Delimited clusters:", length(out), "\n")
```

---

## 📚 Documentation 

| Resource | Command | Description |
|----------|---------|-------------|
| Package help | `?bGMYC4` | Function reference |
| Interactive tutorial | `browseVignettes("bGMYC4")` | Step-by-step workflow with diagnostics |
| Function details | `?bgmyc.multiphylo`, `?spec.probmat` | Parameter explanations |
| Built-in data | `?east10` | Simulated dataset for testing |
| Performance tips | `vignette("bGMYC4-interactive", package = "bGMYC4")` | Section "Performance & Export" |

---

## 🔧 Workflow Overview 

1. **Data selection**  
   - Built-in `east10` (simulated)  
   - Custom BEAST2 files (`.tree`, `.trees`)

2. **Tree preprocessing**  
   - Strip BEAST2 annotations `[&...]`  
   - Rooting check and outgroup removal  
   - Ultrametricity enforcement (`fix_ultrametric()`)

3. **Interactive diagnostics**  
   - Run `bgmyc.singlephy()` on one tree  
   - Check acceptance rates (optimal: `0.20–0.40`)  
   - Evaluate trace plots (`plot(result)`)  
   - Tune parameters with biological hints

4. **Multi-tree analysis**  
   - Run `bgmyc.multiphylo()` on sampled trees  
   - Pool phylogenetic uncertainty (parallel by default)

5. **Visualization and delimitation**  
   - Build conspecificity heatmap (`spec.probmat()`)  
   - Extract clusters at your `ppcutoff` (e.g., `0.05`)

---

## ⚙️ Parameter Reference 

| Parameter | Role | Recommended Range | Notes |
|-----------|------|------------------|-------|
| `mcmc` | Chain length | `10k` (test), `50k+` (final) | Longer = better posterior resolution |
| `burnin` | Burn-in | `20–30%` of `mcmc` | Discards non-stationary start |
| `thinning` | Sampling interval | `10–50` | Reduces autocorrelation & RAM usage |
| `py1`, `py2` | Yule rate priors | `0`, `0.5–1.5` | Model: λ ∝ n^py; >1.5 blurs Yule/Coalescent boundary |
| `pc1`, `pc2` | Coalescent priors | `0`, `1.0–2.0` | Models Ne change; <1 → decline, >1 → growth |
| `t1`, `t2` | Threshold prior (species count) | `2`, `min(2, ntips-1)` | Must be `< ntips`; auto-capped to prevent crashes |
| `scale` | MCMC proposal widths | `c(20–30, 10–15, 3–7)` | Tune via acceptance rates; higher = more conservative |
| `ppcutoff` | Species lumping threshold | `0.05` (sensitive), `0.95` (strict) | Low = captures high intraspecific variation / ILS |

---

## ⚡ Performance & Compatibility 

The optimized `bGMYC4 v4.1.0` is **fully compatible with R ≥ 4.5** and includes:

| Feature / Возможность | Description |
|----------------------|----------------------|
| 🔁 **Automatic parallelization** | `bgmyc.multiphylo()` runs in parallel via `future.apply` (uses all CPU cores by default) |
| 🧹 **Pure-R post-processing** | `bgmyc.spec()` and `spec.probmat()` use native R functions — no external `sort`/`uniq` dependencies |
| 🚀 **Vectorized operations** | Faster heatmap construction and matrix indexing |
| 🔐 **Parallel-safe RNG** | `future.seed = TRUE` ensures reproducible multi-tree analyses |
| 🖥️ **R ≥ 4.5 compatibility** | Full support for modern R features, byte-compilation (`compiler::enableJIT(3)`), and optimized memory management |

### Limit CPU cores (optional) 
```r
# Before running bgmyc.multiphylo():
future::plan(future::multisession, workers = 8)  # Use 8 cores instead of all
```

### Export results to CSV 
```r
# After bgmyc.spec():
write.csv(spec_out$specprobs, 
          file = "bGMYC_clusters.csv", 
          row.names = FALSE, 
          fileEncoding = "UTF-8")
```

### Validate model fit 
```r
# Compare Yule vs Coalescent rates:
rates <- checkrates(result_multi)
plot(rates)  # Opens 4 diagnostic plots
```

### Speed tip 
```r
# Add to your ~/.Rprofile for automatic JIT acceleration:
compiler::enableJIT(3)  # +2–3% speedup on all MCMC loops, no code changes
```

---

## ❓ Troubleshooting 

| Issue | Solution |
|-------|----------|
| `Your input tree is not ultrametric` | Use `fix_ultrametric()` or check BEAST2 export settings |
| `start[3] out of bounds` | Ensure `t1 < start[3] < t2`; script auto-clamps values |
| `Error in read.nexus` | Verify files are Nexus format; use `read.tree()` for Newick |
| `future::evalFuture() failed` | Run `devtools::install()` before `load_all()`; ensure package is in library |
| Slow post-processing | Update to v4.1.0 for pure-R optimizations in `bgmyc.spec()` |
| Non-ASCII warning in check | All R code now uses ASCII-only; comments may contain UTF-8 |

---

## 📄 Citation 

**If you use bGMYC4 in your research, please cite:**

@Manual{bGMYC4,
  title = {bGMYC4: Reid's Bayesian General Mixed Yule-Coalescent Model for Species Delimitation, Optimized v4.1 for R ≥ 4.5},
  author = {Karabanov, Dmitry and Qwen3.6},
  year = {2026},
  note = {R package version 4.1.0},
  url = {https://github.com/dkarabanow-creator/bGMYC4},
}

**Please, cite the foundational works:**
- Pons et al. (2006) *Syst. Biol.* 55:595 — GMYC model
- Reid & Carstens (2012) *Mol. Ecol. Res.* 12:446 — Bayesian implementation

---

## 🤝 Contributing 

Contributions are welcome! To contribute:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-idea`)
3. Commit changes with clear messages
4. Push to your fork and open a Pull Request

**For bug reports or feature requests:**  
→ Use [GitHub Issues](https://github.com/dkarabanow-creator/bGMYC4/issues) with:
- R session info (`sessionInfo()`)
- Minimal reproducible example
- Expected vs actual behavior

---

## 📜 License 

bGMYC4 is free software: you can redistribute it and/or modify it under the terms of the **GNU General Public License v3.0**.  
See [LICENSE](LICENSE) for details.

---

## 📬 Contact

**Dmitry Karabanov**  
📧 dk[at]ibiw.ru  
🏛 Institute for Biology of Inland Waters, RAS  
🔗 [ORCID](https://orcid.org/0000-0001-6008-7441)  

---

> *bGMYC4 – Bayesian species delimitation, made simple, reproducible, and biologist‑friendly* 🌿🔬
