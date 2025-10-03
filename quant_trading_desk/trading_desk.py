"""
Trading Desk Module
Integrates all technical indicators and performance metrics.
"""

import pandas as pd
import numpy as np
from .indicators import BollingerBands, MACD, RSI
from .performance import SharpeRatio


class TradingDesk:
    """
    Main Trading Desk class that integrates all indicators and metrics.
    
    Provides a unified interface for technical analysis using Bollinger Bands,
    MACD, RSI, and Sharpe Ratio.
    """
    
    def __init__(self, 
                 bb_period=20, bb_std_dev=2,
                 macd_fast=12, macd_slow=26, macd_signal=9,
                 rsi_period=14,
                 risk_free_rate=0.02, periods_per_year=252):
        """
        Initialize Trading Desk with indicator parameters.
        
        Args:
            bb_period (int): Bollinger Bands period
            bb_std_dev (float): Bollinger Bands standard deviation
            macd_fast (int): MACD fast period
            macd_slow (int): MACD slow period
            macd_signal (int): MACD signal period
            rsi_period (int): RSI period
            risk_free_rate (float): Annual risk-free rate for Sharpe Ratio
            periods_per_year (int): Trading periods per year
        """
        self.bollinger_bands = BollingerBands(period=bb_period, std_dev=bb_std_dev)
        self.macd = MACD(fast_period=macd_fast, slow_period=macd_slow, signal_period=macd_signal)
        self.rsi = RSI(period=rsi_period)
        self.sharpe_ratio = SharpeRatio(risk_free_rate=risk_free_rate, periods_per_year=periods_per_year)
    
    def analyze(self, data):
        """
        Perform complete technical analysis on price data.
        
        Args:
            data (pd.DataFrame or pd.Series): Price data with close prices
            
        Returns:
            dict: Dictionary containing all indicator results and metrics
        """
        results = {}
        
        # Calculate Bollinger Bands
        bb_data = self.bollinger_bands.calculate(data)
        results['bollinger_bands'] = bb_data
        
        # Calculate MACD
        macd_data = self.macd.calculate(data)
        results['macd'] = macd_data
        
        # Calculate RSI
        rsi_data = self.rsi.calculate(data)
        results['rsi'] = rsi_data
        
        # Calculate Sharpe Ratio
        if isinstance(data, pd.DataFrame):
            prices = data['close'] if 'close' in data.columns else data.iloc[:, 0]
        else:
            prices = data
        
        sharpe = self.sharpe_ratio.calculate_from_prices(prices)
        results['sharpe_ratio'] = sharpe
        
        return results
    
    def generate_signals(self, data):
        """
        Generate trading signals based on technical indicators.
        
        Args:
            data (pd.DataFrame or pd.Series): Price data
            
        Returns:
            pd.DataFrame: DataFrame with trading signals
        """
        if isinstance(data, pd.DataFrame):
            prices = data['close'] if 'close' in data.columns else data.iloc[:, 0]
        else:
            prices = data
        
        # Get indicator data
        bb_data = self.bollinger_bands.calculate(data)
        macd_data = self.macd.calculate(data)
        rsi_data = self.rsi.calculate(data)
        
        signals = pd.DataFrame(index=prices.index)
        
        # Bollinger Bands signals
        # Buy when price touches lower band, sell when price touches upper band
        signals['bb_signal'] = 0
        signals.loc[prices <= bb_data['lower_band'], 'bb_signal'] = 1  # Buy signal
        signals.loc[prices >= bb_data['upper_band'], 'bb_signal'] = -1  # Sell signal
        
        # MACD signals
        # Buy when MACD crosses above signal, sell when MACD crosses below signal
        signals['macd_signal'] = 0
        signals.loc[macd_data['histogram'] > 0, 'macd_signal'] = 1  # Buy signal
        signals.loc[macd_data['histogram'] < 0, 'macd_signal'] = -1  # Sell signal
        
        # RSI signals
        # Buy when RSI < 30 (oversold), sell when RSI > 70 (overbought)
        signals['rsi_signal'] = 0
        signals.loc[rsi_data < 30, 'rsi_signal'] = 1  # Buy signal
        signals.loc[rsi_data > 70, 'rsi_signal'] = -1  # Sell signal
        
        # Combined signal (majority vote)
        signals['combined_signal'] = (
            signals['bb_signal'] + 
            signals['macd_signal'] + 
            signals['rsi_signal']
        )
        
        return signals
    
    def get_summary(self, data):
        """
        Get a comprehensive summary of the analysis.
        
        Args:
            data (pd.DataFrame or pd.Series): Price data
            
        Returns:
            dict: Summary statistics and current indicator values
        """
        results = self.analyze(data)
        
        if isinstance(data, pd.DataFrame):
            prices = data['close'] if 'close' in data.columns else data.iloc[:, 0]
        else:
            prices = data
        
        summary = {
            'current_price': prices.iloc[-1] if len(prices) > 0 else None,
            'sharpe_ratio': results['sharpe_ratio'],
            'bollinger_bands': {
                'upper': results['bollinger_bands']['upper_band'].iloc[-1] if len(results['bollinger_bands']) > 0 else None,
                'middle': results['bollinger_bands']['middle_band'].iloc[-1] if len(results['bollinger_bands']) > 0 else None,
                'lower': results['bollinger_bands']['lower_band'].iloc[-1] if len(results['bollinger_bands']) > 0 else None,
            },
            'macd': {
                'macd_line': results['macd']['macd_line'].iloc[-1] if len(results['macd']) > 0 else None,
                'signal_line': results['macd']['signal_line'].iloc[-1] if len(results['macd']) > 0 else None,
                'histogram': results['macd']['histogram'].iloc[-1] if len(results['macd']) > 0 else None,
            },
            'rsi': results['rsi'].iloc[-1] if len(results['rsi']) > 0 else None,
        }
        
        return summary
