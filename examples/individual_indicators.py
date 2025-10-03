"""
Example demonstrating individual indicator usage.
"""

import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pandas as pd
import numpy as np
from quant_trading_desk.indicators import BollingerBands, MACD, RSI
from quant_trading_desk.performance import SharpeRatio


def main():
    print("\n" + "="*60)
    print("Individual Indicators Demo")
    print("="*60 + "\n")
    
    # Generate sample data
    np.random.seed(42)
    dates = pd.date_range(start='2023-01-01', periods=100, freq='D')
    returns = np.random.normal(0.0005, 0.02, 100)
    prices = 100 * np.exp(np.cumsum(returns))
    data = pd.Series(prices, index=dates)
    
    print(f"Sample data: {len(data)} days")
    print(f"Price range: ${data.min():.2f} - ${data.max():.2f}")
    print(f"Current price: ${data.iloc[-1]:.2f}\n")
    
    # 1. Bollinger Bands
    print("-" * 60)
    print("1. BOLLINGER BANDS")
    print("-" * 60)
    
    bb = BollingerBands(period=20, std_dev=2)
    bb_results = bb.calculate(data)
    
    print("\nLast 5 days:")
    print(bb_results.tail())
    
    latest = bb_results.iloc[-1]
    print(f"\nCurrent bands:")
    print(f"  Upper: ${latest['upper_band']:.2f}")
    print(f"  Middle: ${latest['middle_band']:.2f}")
    print(f"  Lower: ${latest['lower_band']:.2f}")
    
    # 2. MACD
    print("\n" + "-" * 60)
    print("2. MACD (Moving Average Convergence Divergence)")
    print("-" * 60)
    
    macd = MACD(fast_period=12, slow_period=26, signal_period=9)
    macd_results = macd.calculate(data)
    
    print("\nLast 5 days:")
    print(macd_results.tail())
    
    latest = macd_results.iloc[-1]
    print(f"\nCurrent values:")
    print(f"  MACD Line: {latest['macd_line']:.4f}")
    print(f"  Signal Line: {latest['signal_line']:.4f}")
    print(f"  Histogram: {latest['histogram']:.4f}")
    
    if latest['histogram'] > 0:
        print("  → Bullish signal (MACD above signal)")
    else:
        print("  → Bearish signal (MACD below signal)")
    
    # 3. RSI
    print("\n" + "-" * 60)
    print("3. RSI (Relative Strength Index)")
    print("-" * 60)
    
    rsi = RSI(period=14)
    rsi_values = rsi.calculate(data)
    
    print("\nLast 5 days:")
    print(rsi_values.tail())
    
    current_rsi = rsi_values.iloc[-1]
    print(f"\nCurrent RSI: {current_rsi:.2f}")
    
    if current_rsi > 70:
        print("  → Overbought (potential sell signal)")
    elif current_rsi < 30:
        print("  → Oversold (potential buy signal)")
    else:
        print("  → Neutral")
    
    # 4. Sharpe Ratio
    print("\n" + "-" * 60)
    print("4. SHARPE RATIO")
    print("-" * 60)
    
    sharpe = SharpeRatio(risk_free_rate=0.02, periods_per_year=252)
    sharpe_value = sharpe.calculate_from_prices(data)
    
    print(f"\nAnnualized Sharpe Ratio: {sharpe_value:.4f}")
    
    if sharpe_value > 2:
        print("  → Excellent risk-adjusted returns")
    elif sharpe_value > 1:
        print("  → Good risk-adjusted returns")
    elif sharpe_value > 0:
        print("  → Positive but sub-optimal returns")
    else:
        print("  → Poor risk-adjusted returns")
    
    # Summary
    print("\n" + "="*60)
    print("SUMMARY")
    print("="*60)
    print(f"Price: ${data.iloc[-1]:.2f}")
    print(f"Bollinger Band Position: ", end="")
    if data.iloc[-1] > bb_results.iloc[-1]['upper_band']:
        print("Above upper band (overbought)")
    elif data.iloc[-1] < bb_results.iloc[-1]['lower_band']:
        print("Below lower band (oversold)")
    else:
        print("Within bands (normal)")
    
    print(f"MACD: {'Bullish' if macd_results.iloc[-1]['histogram'] > 0 else 'Bearish'}")
    print(f"RSI: {current_rsi:.2f} ({'Overbought' if current_rsi > 70 else 'Oversold' if current_rsi < 30 else 'Neutral'})")
    print(f"Sharpe Ratio: {sharpe_value:.4f}")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()
