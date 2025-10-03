# Main Trading Desk Script
# Orchestrates the quantitative trading analysis

# Load required modules
source("data_retrieval.R")
source("technical_analysis.R")
source("risk_metrics.R")
source("portfolio_analysis.R")

library(ggplot2)
library(gridExtra)

#' Initialize Trading Desk Analysis
#'
#' @param symbols Character vector of stock symbols
#' @param start_date Start date in 'YYYY-MM-DD' format
#' @param end_date End date in 'YYYY-MM-DD' format (default today)
#' @return List containing stock data and analysis results
#' @export
initialize_trading_desk <- function(symbols, start_date, end_date = Sys.Date()) {
  cat("=== Quantitative Trading Desk ===\n")
  cat(sprintf("Analyzing: %s\n", paste(symbols, collapse = ", ")))
  cat(sprintf("Period: %s to %s\n\n", start_date, end_date))
  
  # Fetch stock data
  cat("Step 1: Fetching stock data...\n")
  stock_data <- get_stock_data(symbols, start_date, end_date)
  
  # Extract prices
  cat("\nStep 2: Extracting price data...\n")
  prices <- get_prices_matrix(stock_data, price_type = "Adjusted")
  
  # Calculate returns
  cat("Step 3: Calculating returns...\n")
  returns_list <- lapply(stock_data, calculate_returns)
  returns_matrix <- do.call(merge, returns_list)
  colnames(returns_matrix) <- symbols
  
  result <- list(
    stock_data = stock_data,
    prices = prices,
    returns = returns_matrix,
    symbols = symbols
  )
  
  cat("\nInitialization complete!\n")
  return(result)
}

#' Perform Technical Analysis on a Single Stock
#'
#' @param trading_desk Trading desk object from initialize_trading_desk
#' @param symbol Stock symbol to analyze
#' @return List with technical indicators
#' @export
analyze_stock_technical <- function(trading_desk, symbol) {
  cat(sprintf("\n=== Technical Analysis for %s ===\n", symbol))
  
  stock_data <- trading_desk$stock_data[[symbol]]
  prices <- Cl(stock_data)
  
  # Calculate technical indicators
  sma_20 <- calculate_sma(prices, 20)
  sma_50 <- calculate_sma(prices, 50)
  sma_200 <- calculate_sma(prices, 200)
  rsi <- calculate_rsi(prices, 14)
  macd <- calculate_macd(prices)
  bbands <- calculate_bbands(prices)
  atr <- calculate_atr(stock_data)
  
  # Generate signals
  signal <- ma_crossover_signal(prices, 50, 200)
  
  current_price <- as.numeric(tail(prices, 1))
  current_rsi <- as.numeric(tail(rsi, 1))
  current_signal <- as.numeric(tail(signal, 1))
  
  cat(sprintf("Current Price: $%.2f\n", current_price))
  cat(sprintf("RSI(14): %.2f\n", current_rsi))
  cat(sprintf("Signal: %s\n", ifelse(current_signal > 0, "BULLISH", "BEARISH")))
  
  result <- list(
    prices = prices,
    sma_20 = sma_20,
    sma_50 = sma_50,
    sma_200 = sma_200,
    rsi = rsi,
    macd = macd,
    bbands = bbands,
    atr = atr,
    signal = signal
  )
  
  return(result)
}

#' Perform Risk Analysis on Portfolio
#'
#' @param trading_desk Trading desk object from initialize_trading_desk
#' @param weights Vector of portfolio weights (optional, default equal weight)
#' @param benchmark_symbol Benchmark symbol for comparison (optional)
#' @return List with risk metrics
#' @export
analyze_portfolio_risk <- function(trading_desk, weights = NULL, benchmark_symbol = "SPY") {
  cat("\n=== Portfolio Risk Analysis ===\n")
  
  returns_matrix <- trading_desk$returns
  
  # Use equal weights if not provided
  if (is.null(weights)) {
    n_assets <- ncol(returns_matrix)
    weights <- rep(1/n_assets, n_assets)
  }
  
  # Calculate portfolio returns
  portfolio_returns <- calculate_portfolio_returns(returns_matrix, weights)
  
  # Calculate risk metrics
  sharpe <- calculate_sharpe_ratio(portfolio_returns)
  max_dd <- calculate_max_drawdown(portfolio_returns)
  volatility <- calculate_volatility(portfolio_returns)
  var_95 <- calculate_var(portfolio_returns, 0.95)
  cvar_95 <- calculate_cvar(portfolio_returns, 0.95)
  
  cat(sprintf("Sharpe Ratio: %.2f\n", sharpe))
  cat(sprintf("Annual Volatility: %.2f%%\n", volatility * 100))
  cat(sprintf("Maximum Drawdown: %.2f%%\n", max_dd * 100))
  cat(sprintf("VaR (95%%): %.2f%%\n", var_95 * 100))
  cat(sprintf("CVaR (95%%): %.2f%%\n", cvar_95 * 100))
  
  # Generate performance summary
  perf_summary <- generate_performance_summary(portfolio_returns)
  cat("\nPerformance Summary:\n")
  print(perf_summary)
  
  result <- list(
    portfolio_returns = portfolio_returns,
    weights = weights,
    sharpe_ratio = sharpe,
    max_drawdown = max_dd,
    volatility = volatility,
    var = var_95,
    cvar = cvar_95,
    performance_summary = perf_summary
  )
  
  return(result)
}

#' Optimize Portfolio Allocation
#'
#' @param trading_desk Trading desk object from initialize_trading_desk
#' @param method Optimization method: "max_sharpe", "min_variance", "equal_weight"
#' @return List with optimal weights and portfolio metrics
#' @export
optimize_portfolio_allocation <- function(trading_desk, method = "max_sharpe") {
  cat(sprintf("\n=== Portfolio Optimization (%s) ===\n", method))
  
  returns_matrix <- trading_desk$returns
  
  # Optimize portfolio
  optimal_weights <- optimize_portfolio(returns_matrix, method = method)
  
  cat("\nOptimal Portfolio Weights:\n")
  for (i in seq_along(optimal_weights)) {
    cat(sprintf("%s: %.2f%%\n", names(optimal_weights)[i], optimal_weights[i] * 100))
  }
  
  # Calculate portfolio metrics with optimal weights
  portfolio_returns <- calculate_portfolio_returns(returns_matrix, optimal_weights)
  sharpe <- calculate_sharpe_ratio(portfolio_returns)
  volatility <- calculate_volatility(portfolio_returns)
  
  cat(sprintf("\nOptimized Portfolio Sharpe Ratio: %.2f\n", sharpe))
  cat(sprintf("Optimized Portfolio Volatility: %.2f%%\n", volatility * 100))
  
  result <- list(
    optimal_weights = optimal_weights,
    portfolio_returns = portfolio_returns,
    sharpe_ratio = sharpe,
    volatility = volatility
  )
  
  return(result)
}

#' Generate Trading Desk Report
#'
#' @param trading_desk Trading desk object from initialize_trading_desk
#' @param output_file File path to save the report (optional)
#' @export
generate_trading_report <- function(trading_desk, output_file = NULL) {
  cat("\n=== Generating Trading Desk Report ===\n")
  
  # Calculate correlation matrix
  cor_matrix <- calculate_correlation_matrix(trading_desk$returns)
  cat("\nCorrelation Matrix:\n")
  print(round(cor_matrix, 3))
  
  # Perform portfolio optimization
  cat("\n--- Equal Weight Portfolio ---\n")
  equal_weight_result <- analyze_portfolio_risk(trading_desk)
  
  cat("\n--- Optimized Portfolio (Max Sharpe) ---\n")
  optimized_result <- optimize_portfolio_allocation(trading_desk, "max_sharpe")
  
  cat("\n--- Optimized Portfolio (Min Variance) ---\n")
  min_var_result <- optimize_portfolio_allocation(trading_desk, "min_variance")
  
  report <- list(
    correlation_matrix = cor_matrix,
    equal_weight = equal_weight_result,
    max_sharpe = optimized_result,
    min_variance = min_var_result
  )
  
  if (!is.null(output_file)) {
    saveRDS(report, output_file)
    cat(sprintf("\nReport saved to: %s\n", output_file))
  }
  
  return(report)
}
