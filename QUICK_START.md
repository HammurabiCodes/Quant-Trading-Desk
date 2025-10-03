# Quick Start Guide - Quant Trading Desk

This guide will help you get started with the Quantitative Trading Desk in just a few minutes.

## Prerequisites

1. **Install R** (version 4.0 or higher)
   - Download from: https://cran.r-project.org/
   - Windows: Run the installer
   - Mac: Use the .pkg installer
   - Linux: `sudo apt-get install r-base` (Ubuntu/Debian)

2. **Install RStudio** (Recommended but optional)
   - Download from: https://posit.co/download/rstudio-desktop/
   - Provides a better IDE experience

## Step-by-Step Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/HammurabiCodes/Quant-Trading-Desk.git
cd Quant-Trading-Desk
```

### Step 2: Install Dependencies

Open R or RStudio and run:

```r
source("install_dependencies.R")
```

This will automatically install all required packages:
- quantmod (for Yahoo Finance data)
- TTR (technical indicators)
- PerformanceAnalytics (risk metrics)
- PortfolioAnalytics (portfolio optimization)
- And other supporting packages

**Installation time:** 5-10 minutes depending on your internet connection.

### Step 3: Validate Setup

After installation completes, validate everything is working:

```r
source("validate_setup.R")
```

You should see checkmarks (✓) for all tests.

### Step 4: Run Your First Analysis

Try the example script:

```r
source("example_usage.R")
```

This will:
- Fetch real stock data from Yahoo Finance
- Perform technical analysis
- Calculate risk metrics
- Optimize portfolio allocations
- Generate comprehensive reports

## Your First Custom Analysis

Here's a simple example to get you started:

```r
# Load the trading desk
source("trading_desk.R")

# Define your stocks (change these to stocks you're interested in)
my_stocks <- c("AAPL", "MSFT", "GOOGL")
start_date <- "2022-01-01"

# Initialize the trading desk
desk <- initialize_trading_desk(my_stocks, start_date)

# Analyze a specific stock's technicals
apple_analysis <- analyze_stock_technical(desk, "AAPL")

# Analyze your portfolio's risk
risk_analysis <- analyze_portfolio_risk(desk)

# Find optimal portfolio weights
optimized <- optimize_portfolio_allocation(desk, "max_sharpe")
```

## Common Use Cases

### 1. Single Stock Technical Analysis

```r
source("trading_desk.R")

# Analyze Tesla
desk <- initialize_trading_desk(c("TSLA"), "2023-01-01")
tech <- analyze_stock_technical(desk, "TSLA")

# View current RSI
print(tail(tech$rsi, 1))

# View trading signal
print(tail(tech$signal, 1))
```

### 2. Compare Multiple Portfolios

```r
source("trading_desk.R")

# Create a tech portfolio
tech_stocks <- c("AAPL", "MSFT", "NVDA", "AMD")
desk <- initialize_trading_desk(tech_stocks, "2022-01-01")

# Compare strategies
equal_weight <- analyze_portfolio_risk(desk)
max_sharpe <- optimize_portfolio_allocation(desk, "max_sharpe")
min_var <- optimize_portfolio_allocation(desk, "min_variance")
```

### 3. Generate Full Report

```r
source("trading_desk.R")

# Mixed sector portfolio
stocks <- c("AAPL", "JPM", "JNJ", "XOM", "WMT")
desk <- initialize_trading_desk(stocks, "2021-01-01")

# Get comprehensive analysis
report <- generate_trading_report(desk)

# Save report for later
saveRDS(report, "my_portfolio_report.rds")
```

## Understanding the Output

### Technical Indicators

- **RSI (Relative Strength Index)**: 
  - Above 70 = Overbought (potential sell signal)
  - Below 30 = Oversold (potential buy signal)

- **Moving Average Signal**:
  - BULLISH = Short MA > Long MA (upward trend)
  - BEARISH = Short MA < Long MA (downward trend)

### Risk Metrics

- **Sharpe Ratio**: Higher is better (> 1 is good, > 2 is excellent)
- **Maximum Drawdown**: Largest peak-to-trough decline (lower is better)
- **VaR (95%)**: Maximum expected loss 95% of the time
- **Volatility**: Annualized standard deviation of returns

### Portfolio Weights

The optimizer will suggest percentage allocations:
```
AAPL: 25.3%
MSFT: 30.2%
GOOGL: 22.5%
AMZN: 22.0%
```

## Troubleshooting

### Issue: "Error in getSymbols..."
**Solution**: Check your internet connection. Yahoo Finance requires internet access.

### Issue: "Package 'xxx' not found"
**Solution**: Run `source("install_dependencies.R")` again.

### Issue: "Error in optimize.portfolio..."
**Solution**: Install ROI plugins: 
```r
install.packages(c("ROI.plugin.glpk", "ROI.plugin.quadprog"))
```

### Issue: No data for a specific symbol
**Solution**: 
- Verify the stock symbol is correct (use Yahoo Finance format)
- Some stocks might not have historical data for your date range
- Try a different date range or symbol

## Tips for Success

1. **Start Small**: Begin with 2-3 stocks before expanding
2. **Recent Data**: Use recent start dates (within last 2-3 years) for faster loading
3. **Valid Symbols**: Use valid Yahoo Finance symbols (e.g., "AAPL" not "Apple")
4. **Be Patient**: First data fetch can take a minute or two
5. **Save Results**: Use `saveRDS()` to save analysis results

## Next Steps

1. Explore the example_usage.R file for more scenarios
2. Read the full README.md for detailed documentation
3. Customize the analysis for your specific needs
4. Add your favorite stocks and test different strategies

## Getting Help

- Review the documentation in README.md
- Check function documentation in each module file
- Look at example_usage.R for working examples
- Open an issue on GitHub for bugs or questions

## Important Disclaimer

⚠️ **This tool is for educational and research purposes only.**
- Not financial advice
- Past performance doesn't guarantee future results
- Always consult a qualified financial advisor before investing
- Do your own research before making investment decisions

---

Happy Trading! 📈
