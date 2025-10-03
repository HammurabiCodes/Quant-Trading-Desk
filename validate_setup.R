# Validation Script for Quant Trading Desk
# This script checks that all modules can be loaded and basic functionality works

cat("========================================\n")
cat("Quant Trading Desk - Setup Validation\n")
cat("========================================\n\n")

# Test 1: Check if all module files exist
cat("Test 1: Checking module files...\n")
required_files <- c(
  "data_retrieval.R",
  "technical_analysis.R",
  "risk_metrics.R",
  "portfolio_analysis.R",
  "trading_desk.R"
)

all_files_exist <- TRUE
for (file in required_files) {
  if (file.exists(file)) {
    cat(sprintf("✓ %s exists\n", file))
  } else {
    cat(sprintf("✗ %s missing\n", file))
    all_files_exist <- FALSE
  }
}

if (!all_files_exist) {
  stop("Some required files are missing!")
}

# Test 2: Check if required packages are installed
cat("\nTest 2: Checking required packages...\n")
required_packages <- c(
  "quantmod", "TTR", "PerformanceAnalytics", 
  "PortfolioAnalytics", "xts", "zoo", "ROI"
)

missing_packages <- character(0)
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("✓ %s installed\n", pkg))
  } else {
    cat(sprintf("✗ %s missing\n", pkg))
    missing_packages <- c(missing_packages, pkg)
  }
}

if (length(missing_packages) > 0) {
  cat("\n⚠ Some packages are missing. Please run:\n")
  cat("source('install_dependencies.R')\n")
  cat("\nOr manually install missing packages:\n")
  cat(sprintf("install.packages(c('%s'))\n", paste(missing_packages, collapse = "', '")))
}

# Test 3: Try to source the modules (syntax check)
cat("\nTest 3: Loading modules (syntax check)...\n")
tryCatch({
  source("data_retrieval.R")
  cat("✓ data_retrieval.R loaded successfully\n")
}, error = function(e) {
  cat(sprintf("✗ data_retrieval.R error: %s\n", e$message))
})

tryCatch({
  source("technical_analysis.R")
  cat("✓ technical_analysis.R loaded successfully\n")
}, error = function(e) {
  cat(sprintf("✗ technical_analysis.R error: %s\n", e$message))
})

tryCatch({
  source("risk_metrics.R")
  cat("✓ risk_metrics.R loaded successfully\n")
}, error = function(e) {
  cat(sprintf("✗ risk_metrics.R error: %s\n", e$message))
})

tryCatch({
  source("portfolio_analysis.R")
  cat("✓ portfolio_analysis.R loaded successfully\n")
}, error = function(e) {
  cat(sprintf("✗ portfolio_analysis.R error: %s\n", e$message))
})

tryCatch({
  source("trading_desk.R")
  cat("✓ trading_desk.R loaded successfully\n")
}, error = function(e) {
  cat(sprintf("✗ trading_desk.R error: %s\n", e$message))
})

# Test 4: Check function availability
cat("\nTest 4: Checking function availability...\n")
expected_functions <- c(
  "get_stock_data",
  "calculate_returns",
  "calculate_sma",
  "calculate_rsi",
  "calculate_sharpe_ratio",
  "optimize_portfolio",
  "initialize_trading_desk"
)

for (func in expected_functions) {
  if (exists(func) && is.function(get(func))) {
    cat(sprintf("✓ Function '%s' available\n", func))
  } else {
    cat(sprintf("✗ Function '%s' not found\n", func))
  }
}

# Summary
cat("\n========================================\n")
cat("Validation Summary\n")
cat("========================================\n")

if (all_files_exist && length(missing_packages) == 0) {
  cat("✓ Setup is complete and ready to use!\n")
  cat("\nTo get started, try:\n")
  cat("  source('example_usage.R')\n")
} else {
  cat("⚠ Setup needs attention:\n")
  if (!all_files_exist) {
    cat("  - Some module files are missing\n")
  }
  if (length(missing_packages) > 0) {
    cat("  - Some R packages need to be installed\n")
    cat("    Run: source('install_dependencies.R')\n")
  }
}

cat("\n========================================\n")
