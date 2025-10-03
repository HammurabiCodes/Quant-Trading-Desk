# Portfolio Analysis Module for Quant Trading Desk
# Functions for portfolio optimization and analysis

library(PortfolioAnalytics)
library(ROI)
library(ROI.plugin.glpk)
library(ROI.plugin.quadprog)

#' Calculate Optimal Portfolio Weights (Mean-Variance Optimization)
#'
#' @param returns_matrix xts object with returns for multiple assets
#' @param method Optimization method: "max_sharpe", "min_variance", "equal_weight"
#' @param rf Risk-free rate (annual, default 0.02)
#' @return Vector of optimal weights
#' @export
optimize_portfolio <- function(returns_matrix, method = "max_sharpe", rf = 0.02) {
  n_assets <- ncol(returns_matrix)
  asset_names <- colnames(returns_matrix)
  
  if (method == "equal_weight") {
    weights <- rep(1/n_assets, n_assets)
    names(weights) <- asset_names
    return(weights)
  }
  
  # Create portfolio specification
  port_spec <- portfolio.spec(assets = asset_names)
  
  # Add constraints
  port_spec <- add.constraint(port_spec, type = "full_investment")
  port_spec <- add.constraint(port_spec, type = "long_only")
  
  if (method == "max_sharpe") {
    # Maximize Sharpe ratio
    port_spec <- add.objective(port_spec, type = "return", name = "mean")
    port_spec <- add.objective(port_spec, type = "risk", name = "StdDev")
    
    opt <- optimize.portfolio(returns_matrix, port_spec, 
                             optimize_method = "ROI",
                             maxSR = TRUE,
                             trace = FALSE)
  } else if (method == "min_variance") {
    # Minimize variance
    port_spec <- add.objective(port_spec, type = "risk", name = "var")
    
    opt <- optimize.portfolio(returns_matrix, port_spec,
                             optimize_method = "ROI",
                             trace = FALSE)
  }
  
  weights <- extractWeights(opt)
  return(weights)
}

#' Calculate Efficient Frontier
#'
#' @param returns_matrix xts object with returns for multiple assets
#' @param n_portfolios Number of portfolios on the frontier (default 50)
#' @return Data frame with returns, risks, and weights
#' @export
calculate_efficient_frontier <- function(returns_matrix, n_portfolios = 50) {
  asset_names <- colnames(returns_matrix)
  
  # Create portfolio specification
  port_spec <- portfolio.spec(assets = asset_names)
  port_spec <- add.constraint(port_spec, type = "full_investment")
  port_spec <- add.constraint(port_spec, type = "long_only")
  port_spec <- add.objective(port_spec, type = "return", name = "mean")
  port_spec <- add.objective(port_spec, type = "risk", name = "StdDev")
  
  # Generate random portfolios for efficient frontier
  rp <- random_portfolios(port_spec, permutations = n_portfolios * 10)
  
  # Optimize
  opt <- optimize.portfolio(returns_matrix, port_spec,
                           optimize_method = "random",
                           rp = rp,
                           trace = FALSE)
  
  return(opt)
}

#' Calculate Portfolio Correlation Matrix
#'
#' @param returns_matrix xts object with returns for multiple assets
#' @return Correlation matrix
#' @export
calculate_correlation_matrix <- function(returns_matrix) {
  cor_matrix <- cor(returns_matrix, use = "pairwise.complete.obs")
  return(cor_matrix)
}

#' Calculate Portfolio Covariance Matrix
#'
#' @param returns_matrix xts object with returns for multiple assets
#' @param annualize Logical, whether to annualize (default TRUE)
#' @return Covariance matrix
#' @export
calculate_covariance_matrix <- function(returns_matrix, annualize = TRUE) {
  cov_matrix <- cov(returns_matrix, use = "pairwise.complete.obs")
  if (annualize) {
    cov_matrix <- cov_matrix * 252
  }
  return(cov_matrix)
}

#' Rebalance Portfolio
#'
#' @param current_weights Vector of current portfolio weights
#' @param target_weights Vector of target portfolio weights
#' @param threshold Rebalancing threshold (default 0.05)
#' @return List with rebalancing decision and trades
#' @export
rebalance_portfolio <- function(current_weights, target_weights, threshold = 0.05) {
  weight_diff <- target_weights - current_weights
  needs_rebalance <- any(abs(weight_diff) > threshold)
  
  result <- list(
    needs_rebalance = needs_rebalance,
    weight_differences = weight_diff,
    trades = weight_diff
  )
  
  return(result)
}

#' Calculate Diversification Ratio
#'
#' @param weights Vector of portfolio weights
#' @param cov_matrix Covariance matrix of returns
#' @return Numeric diversification ratio
#' @export
calculate_diversification_ratio <- function(weights, cov_matrix) {
  # Weighted average of individual volatilities
  individual_vols <- sqrt(diag(cov_matrix))
  weighted_avg_vol <- sum(weights * individual_vols)
  
  # Portfolio volatility
  portfolio_vol <- sqrt(t(weights) %*% cov_matrix %*% weights)
  
  # Diversification ratio
  div_ratio <- weighted_avg_vol / as.numeric(portfolio_vol)
  
  return(div_ratio)
}
