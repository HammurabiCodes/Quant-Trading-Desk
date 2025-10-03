# My Portfolio Analysis Template
# Customize this template for your own portfolio analysis

# Source the trading desk
source("trading_desk.R")

# ============================================
# CONFIGURATION - Customize these settings
# ============================================

# Define your stock portfolio
# Replace these with stocks you want to analyze
MY_STOCKS <- c("AAPL", "MSFT", "GOOGL", "AMZN")

# Define analysis period
# Format: "YYYY-MM-DD"
START_DATE <- "2022-01-01"
END_DATE <- Sys.Date()  # Today's date

# Define custom portfolio weights (optional)
# Set to NULL to use equal weights or optimization
# Must sum to 1.0
CUSTOM_WEIGHTS <- NULL  # Example: c(0.25, 0.25, 0.25, 0.25)

# Risk-free rate for Sharpe ratio calculation (annual)
RISK_FREE_RATE <- 0.02  # 2% annual risk-free rate

# Benchmark for comparison (optional)
BENCHMARK_SYMBOL <- "SPY"  # S&P 500 ETF

# ============================================
# ANALYSIS EXECUTION
# ============================================

cat("========================================\n")
cat("MY PORTFOLIO ANALYSIS\n")
cat("========================================\n\n")

cat("Portfolio Stocks:", paste(MY_STOCKS, collapse = ", "), "\n")
cat("Analysis Period:", START_DATE, "to", END_DATE, "\n\n")

# Step 1: Initialize the trading desk
cat("Step 1: Fetching data and initializing...\n")
desk <- initialize_trading_desk(MY_STOCKS, START_DATE, END_DATE)

# Step 2: Individual stock technical analysis
cat("\n========================================\n")
cat("INDIVIDUAL STOCK ANALYSIS\n")
cat("========================================\n")

stock_analyses <- list()
for (symbol in MY_STOCKS) {
  cat(sprintf("\n--- Analyzing %s ---\n", symbol))
  stock_analyses[[symbol]] <- analyze_stock_technical(desk, symbol)
}

# Step 3: Portfolio risk analysis with equal weights
cat("\n========================================\n")
cat("EQUAL WEIGHT PORTFOLIO\n")
cat("========================================\n")

equal_weight_result <- analyze_portfolio_risk(desk, 
                                              weights = NULL,
                                              benchmark_symbol = BENCHMARK_SYMBOL)

# Step 4: Portfolio risk analysis with custom weights (if provided)
if (!is.null(CUSTOM_WEIGHTS)) {
  cat("\n========================================\n")
  cat("CUSTOM WEIGHT PORTFOLIO\n")
  cat("========================================\n")
  
  custom_weight_result <- analyze_portfolio_risk(desk,
                                                 weights = CUSTOM_WEIGHTS,
                                                 benchmark_symbol = BENCHMARK_SYMBOL)
}

# Step 5: Optimize portfolio - Maximum Sharpe Ratio
cat("\n========================================\n")
cat("OPTIMIZED PORTFOLIO (MAX SHARPE)\n")
cat("========================================\n")

max_sharpe_result <- optimize_portfolio_allocation(desk, method = "max_sharpe")

# Step 6: Optimize portfolio - Minimum Variance
cat("\n========================================\n")
cat("OPTIMIZED PORTFOLIO (MIN VARIANCE)\n")
cat("========================================\n")

min_var_result <- optimize_portfolio_allocation(desk, method = "min_variance")

# Step 7: Generate comprehensive report
cat("\n========================================\n")
cat("COMPREHENSIVE REPORT\n")
cat("========================================\n")

full_report <- generate_trading_report(desk)

# ============================================
# SAVE RESULTS (Optional)
# ============================================

# Uncomment these lines to save your results
# save_date <- format(Sys.Date(), "%Y%m%d")
# saveRDS(desk, sprintf("portfolio_data_%s.rds", save_date))
# saveRDS(full_report, sprintf("portfolio_report_%s.rds", save_date))
# cat(sprintf("\nResults saved with date: %s\n", save_date))

# ============================================
# SUMMARY AND RECOMMENDATIONS
# ============================================

cat("\n========================================\n")
cat("PORTFOLIO COMPARISON SUMMARY\n")
cat("========================================\n\n")

cat("Equal Weight Portfolio:\n")
cat(sprintf("  Sharpe Ratio: %.2f\n", equal_weight_result$sharpe_ratio))
cat(sprintf("  Volatility: %.2f%%\n", equal_weight_result$volatility * 100))
cat(sprintf("  Max Drawdown: %.2f%%\n", equal_weight_result$max_drawdown * 100))

if (!is.null(CUSTOM_WEIGHTS)) {
  cat("\nCustom Weight Portfolio:\n")
  cat(sprintf("  Sharpe Ratio: %.2f\n", custom_weight_result$sharpe_ratio))
  cat(sprintf("  Volatility: %.2f%%\n", custom_weight_result$volatility * 100))
  cat(sprintf("  Max Drawdown: %.2f%%\n", custom_weight_result$max_drawdown * 100))
}

cat("\nMax Sharpe Portfolio:\n")
cat(sprintf("  Sharpe Ratio: %.2f\n", max_sharpe_result$sharpe_ratio))
cat(sprintf("  Volatility: %.2f%%\n", max_sharpe_result$volatility * 100))
cat("  Optimal Weights:\n")
for (i in seq_along(max_sharpe_result$optimal_weights)) {
  cat(sprintf("    %s: %.2f%%\n", 
              names(max_sharpe_result$optimal_weights)[i],
              max_sharpe_result$optimal_weights[i] * 100))
}

cat("\nMin Variance Portfolio:\n")
cat(sprintf("  Sharpe Ratio: %.2f\n", min_var_result$sharpe_ratio))
cat(sprintf("  Volatility: %.2f%%\n", min_var_result$volatility * 100))
cat("  Optimal Weights:\n")
for (i in seq_along(min_var_result$optimal_weights)) {
  cat(sprintf("    %s: %.2f%%\n",
              names(min_var_result$optimal_weights)[i],
              min_var_result$optimal_weights[i] * 100))
}

cat("\n========================================\n")
cat("Analysis complete!\n")
cat("========================================\n")

# ============================================
# NOTES AND INTERPRETATION
# ============================================

cat("\nInterpretation Guide:\n")
cat("- Sharpe Ratio > 1 is good, > 2 is excellent\n")
cat("- Lower volatility = more stable returns\n")
cat("- Lower max drawdown = smaller losses during downturns\n")
cat("- Diversified weights = better risk management\n")
cat("\nDisclaimer: This is for educational purposes only.\n")
cat("Not financial advice. Always do your own research.\n")
