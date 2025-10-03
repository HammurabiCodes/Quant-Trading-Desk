# Example Usage of Quant Trading Desk
# This script demonstrates how to use the trading desk for stock analysis

# Source the main trading desk script
source("trading_desk.R")

# Example 1: Analyze a single stock portfolio
cat("========================================\n")
cat("EXAMPLE 1: Single Stock Analysis\n")
cat("========================================\n\n")

# Define parameters
symbols <- c("AAPL")
start_date <- "2020-01-01"
end_date <- Sys.Date()

# Initialize trading desk
desk <- initialize_trading_desk(symbols, start_date, end_date)

# Perform technical analysis
tech_analysis <- analyze_stock_technical(desk, "AAPL")

# Analyze risk
risk_analysis <- analyze_portfolio_risk(desk)

# Example 2: Analyze a diversified portfolio
cat("\n\n========================================\n")
cat("EXAMPLE 2: Diversified Portfolio Analysis\n")
cat("========================================\n\n")

# Define a portfolio of tech stocks
tech_portfolio <- c("AAPL", "MSFT", "GOOGL", "AMZN")
start_date <- "2021-01-01"

# Initialize trading desk
tech_desk <- initialize_trading_desk(tech_portfolio, start_date)

# Generate comprehensive report
report <- generate_trading_report(tech_desk)

# Example 3: Sector-based portfolio
cat("\n\n========================================\n")
cat("EXAMPLE 3: Sector Portfolio Analysis\n")
cat("========================================\n\n")

# Mix of sectors: Tech, Finance, Healthcare, Consumer
sector_portfolio <- c("AAPL", "JPM", "JNJ", "WMT", "XOM")
start_date <- "2020-01-01"

# Initialize trading desk
sector_desk <- initialize_trading_desk(sector_portfolio, start_date)

# Analyze with equal weights
cat("\n--- Equal Weight Strategy ---\n")
equal_weight_analysis <- analyze_portfolio_risk(sector_desk)

# Optimize portfolio
cat("\n--- Optimized Strategy (Max Sharpe) ---\n")
optimized_analysis <- optimize_portfolio_allocation(sector_desk, "max_sharpe")

cat("\n--- Optimized Strategy (Min Variance) ---\n")
min_var_analysis <- optimize_portfolio_allocation(sector_desk, "min_variance")

# Example 4: Technical Analysis with Multiple Indicators
cat("\n\n========================================\n")
cat("EXAMPLE 4: Detailed Technical Analysis\n")
cat("========================================\n\n")

# Analyze Tesla
tesla_symbols <- c("TSLA")
tesla_desk <- initialize_trading_desk(tesla_symbols, "2022-01-01")

# Get detailed technical indicators
tsla_tech <- analyze_stock_technical(tesla_desk, "TSLA")

# Print recent RSI values
cat("\nRecent RSI values:\n")
print(tail(tsla_tech$rsi, 10))

# Print recent MACD values
cat("\nRecent MACD values:\n")
print(tail(tsla_tech$macd, 10))

cat("\n========================================\n")
cat("Examples completed!\n")
cat("========================================\n")
