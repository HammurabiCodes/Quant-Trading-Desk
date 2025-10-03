# Quant Trading Desk

A comprehensive Python library for quantitative trading analysis, featuring technical indicators and performance metrics for financial analytics.

## Features

- **Technical Indicators**
  - **Bollinger Bands**: Volatility bands for identifying overbought/oversold conditions
  - **MACD (Moving Average Convergence Divergence)**: Trend-following momentum indicator
  - **RSI (Relative Strength Index)**: Momentum oscillator measuring speed and change of price movements
  
- **Performance Metrics**
  - **Sharpe Ratio**: Risk-adjusted return calculator for portfolio performance evaluation

- **Trading Desk**: Integrated platform combining all indicators for comprehensive market analysis and signal generation

## Installation

### Requirements

- Python 3.7+
- numpy
- pandas
- yfinance (optional, for fetching live market data)

### Install Dependencies

```bash
pip install -r requirements.txt
```

## Quick Start

### Basic Usage

```python
from quant_trading_desk import TradingDesk
from quant_trading_desk.data_fetcher import fetch_data

# Fetch market data
data = fetch_data('AAPL', period='1y')

# Initialize Trading Desk
desk = TradingDesk()

# Get comprehensive analysis
results = desk.analyze(data)

# Get summary of current indicators
summary = desk.get_summary(data)
print(f"Current Price: ${summary['current_price']:.2f}")
print(f"Sharpe Ratio: {summary['sharpe_ratio']:.4f}")
print(f"RSI: {summary['rsi']:.2f}")

# Generate trading signals
signals = desk.generate_signals(data)
print(signals.tail())
```

### Using Individual Indicators

```python
from quant_trading_desk.indicators import BollingerBands, MACD, RSI
from quant_trading_desk.performance import SharpeRatio
import pandas as pd

# Sample price data
prices = pd.Series([100, 102, 101, 103, 105, 104, 106, 108])

# Bollinger Bands
bb = BollingerBands(period=20, std_dev=2)
bb_results = bb.calculate(prices)
print(bb_results)

# MACD
macd = MACD(fast_period=12, slow_period=26, signal_period=9)
macd_results = macd.calculate(prices)
print(macd_results)

# RSI
rsi = RSI(period=14)
rsi_values = rsi.calculate(prices)
print(rsi_values)

# Sharpe Ratio
sharpe = SharpeRatio(risk_free_rate=0.02)
sharpe_value = sharpe.calculate_from_prices(prices)
print(f"Sharpe Ratio: {sharpe_value:.4f}")
```

## Project Structure

```
Quant-Trading-Desk/
├── quant_trading_desk/
│   ├── __init__.py           # Package initialization
│   ├── indicators.py         # Technical indicators (BB, MACD, RSI)
│   ├── performance.py        # Performance metrics (Sharpe Ratio)
│   ├── trading_desk.py       # Main Trading Desk class
│   └── data_fetcher.py       # Data fetching utilities
├── tests/
│   ├── test_indicators.py    # Tests for indicators
│   ├── test_performance.py   # Tests for performance metrics
│   └── test_trading_desk.py  # Tests for Trading Desk
├── examples/
│   └── demo.py               # Demo script
├── requirements.txt          # Project dependencies
└── README.md                 # This file
```

## Running Examples

Run the demo script to see the library in action:

```bash
python examples/demo.py
```

This will:
1. Run analysis on sample data
2. Fetch and analyze live market data (if yfinance is installed)
3. Display all indicators and trading signals

## Running Tests

Run the unit tests to verify the installation:

```bash
python -m pytest tests/
```

Or run individual test files:

```bash
python tests/test_indicators.py
python tests/test_performance.py
python tests/test_trading_desk.py
```

## Technical Indicators Explained

### Bollinger Bands
Bollinger Bands consist of three lines:
- **Upper Band**: Middle Band + (Standard Deviation × multiplier)
- **Middle Band**: Simple Moving Average (SMA)
- **Lower Band**: Middle Band - (Standard Deviation × multiplier)

**Trading Signals**:
- Price touching lower band → Potential buy signal (oversold)
- Price touching upper band → Potential sell signal (overbought)

### MACD (Moving Average Convergence Divergence)
MACD shows the relationship between two exponential moving averages:
- **MACD Line**: Fast EMA - Slow EMA
- **Signal Line**: EMA of MACD Line
- **Histogram**: MACD Line - Signal Line

**Trading Signals**:
- MACD crosses above signal line → Buy signal
- MACD crosses below signal line → Sell signal

### RSI (Relative Strength Index)
RSI measures momentum on a scale of 0-100:
- **Above 70**: Overbought condition (potential sell)
- **Below 30**: Oversold condition (potential buy)
- **50**: Neutral

### Sharpe Ratio
The Sharpe Ratio measures risk-adjusted returns:
- **Formula**: (Return - Risk-free Rate) / Standard Deviation
- **Higher values**: Better risk-adjusted performance
- **Typical values**:
  - < 1.0: Sub-optimal
  - 1.0-2.0: Good
  - 2.0-3.0: Very Good
  - > 3.0: Excellent

## Customization

All indicators support customizable parameters:

```python
desk = TradingDesk(
    bb_period=20,           # Bollinger Bands period
    bb_std_dev=2,          # Bollinger Bands standard deviation
    macd_fast=12,          # MACD fast period
    macd_slow=26,          # MACD slow period
    macd_signal=9,         # MACD signal period
    rsi_period=14,         # RSI period
    risk_free_rate=0.02,   # Annual risk-free rate
    periods_per_year=252   # Trading days per year
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Disclaimer

This software is for educational and research purposes only. It should not be used as the sole basis for making investment decisions. Always consult with a qualified financial advisor before making investment decisions.