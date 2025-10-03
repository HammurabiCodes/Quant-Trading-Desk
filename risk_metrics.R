# Risk Metrics Module for Quant Trading Desk
# Functions for calculating risk and performance metrics

library(PerformanceAnalytics)

#' Calculate Portfolio Returns
#'
#' @param returns_matrix xts object with returns for multiple assets
#' @param weights Vector of portfolio weights (must sum to 1)
#' @return xts object with portfolio returns
#' @export
calculate_portfolio_returns <- function(returns_matrix, weights) {
  portfolio_returns <- Return.portfolio(returns_matrix, weights = weights)
  return(portfolio_returns)
}

#' Calculate Sharpe Ratio
#'
#' @param returns xts object with returns
#' @param rf Risk-free rate (annual, default 0.02)
#' @return Numeric Sharpe ratio
#' @export
calculate_sharpe_ratio <- function(returns, rf = 0.02) {
  sharpe <- SharpeRatio(returns, Rf = rf/252, FUN = "StdDev")
  return(as.numeric(sharpe))
}

#' Calculate Maximum Drawdown
#'
#' @param returns xts object with returns
#' @return Numeric maximum drawdown
#' @export
calculate_max_drawdown <- function(returns) {
  max_dd <- maxDrawdown(returns)
  return(max_dd)
}

#' Calculate Value at Risk (VaR)
#'
#' @param returns xts object with returns
#' @param p Confidence level (default 0.95)
#' @param method Method for VaR calculation (default "historical")
#' @return Numeric VaR
#' @export
calculate_var <- function(returns, p = 0.95, method = "historical") {
  var <- VaR(returns, p = p, method = method)
  return(as.numeric(var))
}

#' Calculate Conditional Value at Risk (CVaR/Expected Shortfall)
#'
#' @param returns xts object with returns
#' @param p Confidence level (default 0.95)
#' @return Numeric CVaR
#' @export
calculate_cvar <- function(returns, p = 0.95) {
  cvar <- ES(returns, p = p, method = "historical")
  return(as.numeric(cvar))
}

#' Calculate Volatility (Standard Deviation)
#'
#' @param returns xts object with returns
#' @param annualize Logical, whether to annualize (default TRUE)
#' @return Numeric volatility
#' @export
calculate_volatility <- function(returns, annualize = TRUE) {
  vol <- sd(returns, na.rm = TRUE)
  if (annualize) {
    vol <- vol * sqrt(252)
  }
  return(as.numeric(vol))
}

#' Calculate Beta
#'
#' @param asset_returns xts object with asset returns
#' @param market_returns xts object with market returns
#' @return Numeric beta
#' @export
calculate_beta <- function(asset_returns, market_returns) {
  merged_data <- merge(asset_returns, market_returns, all = FALSE)
  beta <- CAPM.beta(merged_data[, 1], merged_data[, 2])
  return(as.numeric(beta))
}

#' Calculate Alpha
#'
#' @param asset_returns xts object with asset returns
#' @param market_returns xts object with market returns
#' @param rf Risk-free rate (annual, default 0.02)
#' @return Numeric alpha
#' @export
calculate_alpha <- function(asset_returns, market_returns, rf = 0.02) {
  merged_data <- merge(asset_returns, market_returns, all = FALSE)
  alpha <- CAPM.alpha(merged_data[, 1], merged_data[, 2], Rf = rf/252)
  return(as.numeric(alpha))
}

#' Calculate Information Ratio
#'
#' @param asset_returns xts object with asset returns
#' @param benchmark_returns xts object with benchmark returns
#' @return Numeric information ratio
#' @export
calculate_information_ratio <- function(asset_returns, benchmark_returns) {
  merged_data <- merge(asset_returns, benchmark_returns, all = FALSE)
  ir <- InformationRatio(merged_data[, 1], merged_data[, 2])
  return(as.numeric(ir))
}

#' Calculate Sortino Ratio
#'
#' @param returns xts object with returns
#' @param mar Minimum acceptable return (default 0)
#' @return Numeric Sortino ratio
#' @export
calculate_sortino_ratio <- function(returns, mar = 0) {
  sortino <- SortinoRatio(returns, MAR = mar)
  return(as.numeric(sortino))
}

#' Calculate Calmar Ratio
#'
#' @param returns xts object with returns
#' @return Numeric Calmar ratio
#' @export
calculate_calmar_ratio <- function(returns) {
  calmar <- CalmarRatio(returns)
  return(as.numeric(calmar))
}

#' Generate Performance Summary
#'
#' @param returns xts object with returns
#' @param rf Risk-free rate (annual, default 0.02)
#' @return Data frame with performance metrics
#' @export
generate_performance_summary <- function(returns, rf = 0.02) {
  total_return <- Return.cumulative(returns)
  annual_return <- Return.annualized(returns)
  annual_vol <- StdDev.annualized(returns)
  sharpe <- calculate_sharpe_ratio(returns, rf)
  max_dd <- calculate_max_drawdown(returns)
  var_95 <- calculate_var(returns, 0.95)
  cvar_95 <- calculate_cvar(returns, 0.95)
  
  summary_df <- data.frame(
    Metric = c("Total Return", "Annual Return", "Annual Volatility", 
               "Sharpe Ratio", "Max Drawdown", "VaR (95%)", "CVaR (95%)"),
    Value = c(total_return, annual_return, annual_vol, sharpe, 
              max_dd, var_95, cvar_95)
  )
  
  return(summary_df)
}
