# Quick Start Guide

## Installation

```bash
# Install required dependencies
pip install -r requirements.txt
```

## Basic Usage Example

```python
from quant_trading_desk import TradingDesk
import pandas as pd
import numpy as np

# Generate or load price data
np.random.seed(42)
dates = pd.date_range(start='2023-01-01', periods=100, freq='D')
prices = 100 + np.cumsum(np.random.randn(100) * 2)
data = pd.DataFrame({'close': prices}, index=dates)

# Initialize Trading Desk
desk = TradingDesk()

# Get comprehensive analysis
results = desk.analyze(data)

# Get summary
summary = desk.get_summary(data)
print(f"Current Price: ${summary['current_price']:.2f}")
print(f"Sharpe Ratio: {summary['sharpe_ratio']:.4f}")
print(f"RSI: {summary['rsi']:.2f}")

# Generate trading signals
signals = desk.generate_signals(data)
print(signals.tail())
```

## Running the Demo

```bash
python examples/demo.py
```

## Running Tests

```bash
# Run all tests
python -m unittest discover tests -v

# Or run individual test files
python tests/test_indicators.py
python tests/test_performance.py
python tests/test_trading_desk.py
```

## Key Components

### 1. Technical Indicators

#### Bollinger Bands
```python
from quant_trading_desk.indicators import BollingerBands

bb = BollingerBands(period=20, std_dev=2)
bb_results = bb.calculate(data)
```

#### MACD
```python
from quant_trading_desk.indicators import MACD

macd = MACD(fast_period=12, slow_period=26, signal_period=9)
macd_results = macd.calculate(data)
```

#### RSI
```python
from quant_trading_desk.indicators import RSI

rsi = RSI(period=14)
rsi_values = rsi.calculate(data)
```

### 2. Performance Metrics

#### Sharpe Ratio
```python
from quant_trading_desk.performance import SharpeRatio

sharpe = SharpeRatio(risk_free_rate=0.02, periods_per_year=252)
sharpe_value = sharpe.calculate_from_prices(data)
```

### 3. Data Fetching

```python
from quant_trading_desk.data_fetcher import fetch_data

# Fetch live market data (requires yfinance)
data = fetch_data('AAPL', period='1y')

# Or load from CSV
from quant_trading_desk.data_fetcher import load_csv
data = load_csv('prices.csv', date_column='Date')
```

## Understanding Trading Signals

The `generate_signals()` method returns:
- **bb_signal**: -1 (sell), 0 (neutral), 1 (buy)
- **macd_signal**: -1 (sell), 0 (neutral), 1 (buy)
- **rsi_signal**: -1 (sell), 0 (neutral), 1 (buy)
- **combined_signal**: Sum of all signals (-3 to +3)

Combined signal interpretation:
- **> 1**: Strong Buy
- **> 0**: Buy
- **< -1**: Strong Sell
- **< 0**: Sell
- **0**: Neutral

## Customizing Parameters

```python
desk = TradingDesk(
    bb_period=20,           # Bollinger Bands period
    bb_std_dev=2,          # Bollinger Bands standard deviation
    macd_fast=12,          # MACD fast period
    macd_slow=26,          # MACD slow period
    macd_signal=9,         # MACD signal period
    rsi_period=14,         # RSI period
    risk_free_rate=0.02,   # Annual risk-free rate (2%)
    periods_per_year=252   # Trading days per year
)
```

## Next Steps

1. Read the full [README.md](README.md) for detailed documentation
2. Explore the [examples/demo.py](examples/demo.py) script
3. Review the test files in the `tests/` directory for usage examples
4. Customize indicator parameters for your trading strategy
