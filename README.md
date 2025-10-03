# Quant-Trading-Desk

A comprehensive quantitative trading desk built in R that pulls stock data from Yahoo Finance and performs sophisticated quantitative analysis using various technical indicators, risk metrics, and portfolio optimization techniques.

## Features

### Data Retrieval
- Fetch historical stock data from Yahoo Finance
- Support for multiple stock symbols
- Calculate returns (arithmetic and logarithmic)
- Extract price matrices for portfolio analysis

### Technical Analysis
- **Moving Averages**: SMA, EMA
- **Momentum Indicators**: RSI, MACD, Stochastic Oscillator
- **Volatility Indicators**: Bollinger Bands, ATR
- **Volume Analysis**: VWAP (Volume-Weighted Average Price)
- **Trading Signals**: Moving Average Crossover strategies

### Risk Metrics
- Sharpe Ratio
- Sortino Ratio
- Calmar Ratio
- Maximum Drawdown
- Value at Risk (VaR)
- Conditional Value at Risk (CVaR)
- Volatility calculations
- Beta and Alpha (CAPM)
- Information Ratio

### Portfolio Analysis
- Mean-Variance Optimization
- Maximum Sharpe Ratio portfolios
- Minimum Variance portfolios
- Efficient Frontier calculation
- Correlation and Covariance matrices
- Diversification Ratio
- Portfolio rebalancing

## Installation

### Prerequisites

You need R (version 4.0 or higher) and RStudio installed on your system.

### Required R Packages

Install the required packages by running:

```r
# Install from CRAN
install.packages(c(
  "quantmod",           # For fetching stock data
  "TTR",                # Technical Trading Rules
  "PerformanceAnalytics", # Performance and risk metrics
  "PortfolioAnalytics", # Portfolio optimization
  "xts",                # Time series objects
  "zoo",                # Time series infrastructure
  "ROI",                # R Optimization Infrastructure
  "ROI.plugin.glpk",    # Linear programming solver
  "ROI.plugin.quadprog", # Quadratic programming solver
  "ggplot2",            # Plotting
  "gridExtra"           # Multiple plots
))
```

## Usage

### Quick Start

1. **Clone the repository:**
```bash
git clone https://github.com/HammurabiCodes/Quant-Trading-Desk.git
cd Quant-Trading-Desk
```

2. **Run the example usage script:**
```r
source("example_usage.R")
```

### Basic Example

```r
# Source the main trading desk
source("trading_desk.R")

# Define your stock portfolio
symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN")
start_date <- "2020-01-01"

# Initialize the trading desk
desk <- initialize_trading_desk(symbols, start_date)

# Perform technical analysis on a single stock
tech_analysis <- analyze_stock_technical(desk, "AAPL")

# Analyze portfolio risk
risk_analysis <- analyze_portfolio_risk(desk)

# Optimize portfolio allocation
optimized <- optimize_portfolio_allocation(desk, "max_sharpe")

# Generate comprehensive report
report <- generate_trading_report(desk)
```

## Module Documentation

### 1. data_retrieval.R
Functions for fetching and processing stock data from Yahoo Finance.

**Key Functions:**
- `get_stock_data(symbols, start_date, end_date)` - Fetch stock data
- `calculate_returns(stock_data, type)` - Calculate returns
- `get_prices_matrix(stock_data_list, price_type)` - Extract price matrix

### 2. technical_analysis.R
Technical indicators and trading signals.

**Key Functions:**
- `calculate_sma(prices, n)` - Simple Moving Average
- `calculate_ema(prices, n)` - Exponential Moving Average
- `calculate_rsi(prices, n)` - Relative Strength Index
- `calculate_macd(prices, nFast, nSlow, nSig)` - MACD
- `calculate_bbands(prices, n, sd)` - Bollinger Bands
- `ma_crossover_signal(prices, short_period, long_period)` - Trading signals

### 3. risk_metrics.R
Risk and performance measurement functions.

**Key Functions:**
- `calculate_sharpe_ratio(returns, rf)` - Sharpe Ratio
- `calculate_max_drawdown(returns)` - Maximum Drawdown
- `calculate_var(returns, p, method)` - Value at Risk
- `calculate_beta(asset_returns, market_returns)` - Beta
- `generate_performance_summary(returns, rf)` - Comprehensive metrics

### 4. portfolio_analysis.R
Portfolio optimization and analysis.

**Key Functions:**
- `optimize_portfolio(returns_matrix, method, rf)` - Portfolio optimization
- `calculate_efficient_frontier(returns_matrix, n_portfolios)` - Efficient frontier
- `calculate_correlation_matrix(returns_matrix)` - Correlation analysis
- `calculate_diversification_ratio(weights, cov_matrix)` - Diversification measure

### 5. trading_desk.R
Main orchestration script that ties all modules together.

**Key Functions:**
- `initialize_trading_desk(symbols, start_date, end_date)` - Setup analysis
- `analyze_stock_technical(trading_desk, symbol)` - Technical analysis
- `analyze_portfolio_risk(trading_desk, weights, benchmark_symbol)` - Risk analysis
- `optimize_portfolio_allocation(trading_desk, method)` - Portfolio optimization
- `generate_trading_report(trading_desk, output_file)` - Comprehensive report

## Example Workflows

### Workflow 1: Single Stock Analysis
```r
source("trading_desk.R")

# Analyze Apple stock
desk <- initialize_trading_desk(c("AAPL"), "2020-01-01")
tech <- analyze_stock_technical(desk, "AAPL")
risk <- analyze_portfolio_risk(desk)
```

### Workflow 2: Portfolio Optimization
```r
source("trading_desk.R")

# Diversified tech portfolio
symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN", "NVDA")
desk <- initialize_trading_desk(symbols, "2021-01-01")

# Compare different strategies
equal_weight <- analyze_portfolio_risk(desk)
max_sharpe <- optimize_portfolio_allocation(desk, "max_sharpe")
min_variance <- optimize_portfolio_allocation(desk, "min_variance")
```

### Workflow 3: Sector Analysis
```r
source("trading_desk.R")

# Multi-sector portfolio
sectors <- c("AAPL", "JPM", "JNJ", "XOM", "WMT")
desk <- initialize_trading_desk(sectors, "2020-01-01")

# Generate full report
report <- generate_trading_report(desk)
```

## Output Examples

The trading desk provides detailed output including:
- Current stock prices and technical indicators
- RSI values and trading signals (Bullish/Bearish)
- Portfolio performance metrics (Sharpe Ratio, Volatility, Drawdown)
- Optimal portfolio weights
- Correlation matrices
- Value at Risk (VaR) and Conditional VaR

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This project is open source and available under the MIT License.

## Disclaimer

This software is for educational and research purposes only. It should not be considered as financial advice. Always do your own research and consult with a qualified financial advisor before making investment decisions. Past performance does not guarantee future results.

## Author

HammurabiCodes

## Acknowledgments

- **quantmod**: Jeffrey A. Ryan and Joshua M. Ulrich
- **PerformanceAnalytics**: Brian G. Peterson and Peter Carl
- **TTR**: Joshua M. Ulrich
- **PortfolioAnalytics**: Ross Bennett, et al.