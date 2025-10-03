"""
Demo script for Quant Trading Desk
Demonstrates the usage of all indicators and metrics.
"""

import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pandas as pd
import numpy as np
from quant_trading_desk import TradingDesk
from quant_trading_desk.data_fetcher import fetch_data


def demo_with_live_data(ticker='AAPL'):
    """
    Demonstrate Trading Desk with live market data.
    
    Args:
        ticker (str): Stock ticker symbol
    """
    print(f"\n{'='*60}")
    print(f"Quant Trading Desk - Demo with {ticker}")
    print(f"{'='*60}\n")
    
    try:
        # Fetch historical data
        print(f"Fetching data for {ticker}...")
        data = fetch_data(ticker, period='1y')
        print(f"Data fetched: {len(data)} trading days\n")
        
        # Initialize Trading Desk
        desk = TradingDesk()
        
        # Get comprehensive analysis
        print("Performing technical analysis...\n")
        results = desk.analyze(data)
        
        # Display summary
        summary = desk.get_summary(data)
        
        print("="*60)
        print("ANALYSIS SUMMARY")
        print("="*60)
        print(f"\nCurrent Price: ${summary['current_price']:.2f}")
        print(f"\nSharpe Ratio: {summary['sharpe_ratio']:.4f}")
        
        print("\n--- Bollinger Bands ---")
        print(f"Upper Band: ${summary['bollinger_bands']['upper']:.2f}")
        print(f"Middle Band: ${summary['bollinger_bands']['middle']:.2f}")
        print(f"Lower Band: ${summary['bollinger_bands']['lower']:.2f}")
        
        print("\n--- MACD ---")
        print(f"MACD Line: {summary['macd']['macd_line']:.4f}")
        print(f"Signal Line: {summary['macd']['signal_line']:.4f}")
        print(f"Histogram: {summary['macd']['histogram']:.4f}")
        
        print(f"\n--- RSI ---")
        print(f"RSI: {summary['rsi']:.2f}")
        
        # Generate trading signals
        signals = desk.generate_signals(data)
        latest_signal = signals.iloc[-1]
        
        print("\n" + "="*60)
        print("TRADING SIGNALS (Latest)")
        print("="*60)
        print(f"Bollinger Bands Signal: {signal_to_text(latest_signal['bb_signal'])}")
        print(f"MACD Signal: {signal_to_text(latest_signal['macd_signal'])}")
        print(f"RSI Signal: {signal_to_text(latest_signal['rsi_signal'])}")
        print(f"Combined Signal: {signal_to_text(latest_signal['combined_signal'], combined=True)}")
        
        print("\n" + "="*60 + "\n")
        
    except ImportError as e:
        print(f"Error: {e}")
        print("\nPlease install yfinance: pip install yfinance")
    except Exception as e:
        print(f"Error: {e}")


def demo_with_sample_data():
    """
    Demonstrate Trading Desk with generated sample data.
    """
    print(f"\n{'='*60}")
    print("Quant Trading Desk - Demo with Sample Data")
    print(f"{'='*60}\n")
    
    # Generate sample price data
    np.random.seed(42)
    dates = pd.date_range(start='2023-01-01', end='2023-12-31', freq='D')
    
    # Generate realistic price movements
    returns = np.random.normal(0.0005, 0.02, len(dates))
    prices = 100 * np.exp(np.cumsum(returns))
    
    data = pd.DataFrame({
        'close': prices
    }, index=dates)
    
    print(f"Sample data generated: {len(data)} days")
    print(f"Price range: ${data['close'].min():.2f} - ${data['close'].max():.2f}\n")
    
    # Initialize Trading Desk
    desk = TradingDesk()
    
    # Get comprehensive analysis
    print("Performing technical analysis...\n")
    results = desk.analyze(data)
    
    # Display summary
    summary = desk.get_summary(data)
    
    print("="*60)
    print("ANALYSIS SUMMARY")
    print("="*60)
    print(f"\nCurrent Price: ${summary['current_price']:.2f}")
    print(f"\nSharpe Ratio: {summary['sharpe_ratio']:.4f}")
    
    print("\n--- Bollinger Bands ---")
    print(f"Upper Band: ${summary['bollinger_bands']['upper']:.2f}")
    print(f"Middle Band: ${summary['bollinger_bands']['middle']:.2f}")
    print(f"Lower Band: ${summary['bollinger_bands']['lower']:.2f}")
    
    print("\n--- MACD ---")
    print(f"MACD Line: {summary['macd']['macd_line']:.4f}")
    print(f"Signal Line: {summary['macd']['signal_line']:.4f}")
    print(f"Histogram: {summary['macd']['histogram']:.4f}")
    
    print(f"\n--- RSI ---")
    print(f"RSI: {summary['rsi']:.2f}")
    
    # Generate trading signals
    signals = desk.generate_signals(data)
    latest_signal = signals.iloc[-1]
    
    print("\n" + "="*60)
    print("TRADING SIGNALS (Latest)")
    print("="*60)
    print(f"Bollinger Bands Signal: {signal_to_text(latest_signal['bb_signal'])}")
    print(f"MACD Signal: {signal_to_text(latest_signal['macd_signal'])}")
    print(f"RSI Signal: {signal_to_text(latest_signal['rsi_signal'])}")
    print(f"Combined Signal: {signal_to_text(latest_signal['combined_signal'], combined=True)}")
    
    print("\n" + "="*60 + "\n")


def signal_to_text(signal, combined=False):
    """
    Convert numeric signal to text description.
    
    Args:
        signal (float): Signal value
        combined (bool): Whether this is a combined signal
        
    Returns:
        str: Text description of signal
    """
    if combined:
        if signal > 1:
            return "STRONG BUY"
        elif signal > 0:
            return "BUY"
        elif signal < -1:
            return "STRONG SELL"
        elif signal < 0:
            return "SELL"
        else:
            return "NEUTRAL"
    else:
        if signal > 0:
            return "BUY"
        elif signal < 0:
            return "SELL"
        else:
            return "NEUTRAL"


if __name__ == "__main__":
    # Run demo with sample data (always works)
    demo_with_sample_data()
    
    # Try to run demo with live data if yfinance is available
    try:
        demo_with_live_data('AAPL')
    except:
        print("\n(Live data demo skipped - install yfinance to enable)")
