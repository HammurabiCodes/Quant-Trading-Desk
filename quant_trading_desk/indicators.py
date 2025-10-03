"""
Technical Indicators Module
Implements Bollinger Bands, MACD, and RSI indicators.
"""

import numpy as np
import pandas as pd


class BollingerBands:
    """
    Bollinger Bands indicator.
    
    Bollinger Bands consist of a middle band (SMA) and two outer bands
    (standard deviations away from the middle band).
    """
    
    def __init__(self, period=20, std_dev=2):
        """
        Initialize Bollinger Bands parameters.
        
        Args:
            period (int): Moving average period (default: 20)
            std_dev (float): Number of standard deviations (default: 2)
        """
        self.period = period
        self.std_dev = std_dev
    
    def calculate(self, data):
        """
        Calculate Bollinger Bands.
        
        Args:
            data (pd.Series or pd.DataFrame): Price data (close prices)
            
        Returns:
            pd.DataFrame: DataFrame with upper_band, middle_band, and lower_band
        """
        if isinstance(data, pd.DataFrame):
            prices = data['close'] if 'close' in data.columns else data.iloc[:, 0]
        else:
            prices = data
        
        # Calculate middle band (SMA)
        middle_band = prices.rolling(window=self.period).mean()
        
        # Calculate standard deviation
        std = prices.rolling(window=self.period).std()
        
        # Calculate upper and lower bands
        upper_band = middle_band + (std * self.std_dev)
        lower_band = middle_band - (std * self.std_dev)
        
        return pd.DataFrame({
            'upper_band': upper_band,
            'middle_band': middle_band,
            'lower_band': lower_band
        })


class MACD:
    """
    MACD (Moving Average Convergence Divergence) indicator.
    
    MACD shows the relationship between two moving averages of prices.
    """
    
    def __init__(self, fast_period=12, slow_period=26, signal_period=9):
        """
        Initialize MACD parameters.
        
        Args:
            fast_period (int): Fast EMA period (default: 12)
            slow_period (int): Slow EMA period (default: 26)
            signal_period (int): Signal line EMA period (default: 9)
        """
        self.fast_period = fast_period
        self.slow_period = slow_period
        self.signal_period = signal_period
    
    def calculate(self, data):
        """
        Calculate MACD line, signal line, and histogram.
        
        Args:
            data (pd.Series or pd.DataFrame): Price data (close prices)
            
        Returns:
            pd.DataFrame: DataFrame with macd_line, signal_line, and histogram
        """
        if isinstance(data, pd.DataFrame):
            prices = data['close'] if 'close' in data.columns else data.iloc[:, 0]
        else:
            prices = data
        
        # Calculate EMAs
        ema_fast = prices.ewm(span=self.fast_period, adjust=False).mean()
        ema_slow = prices.ewm(span=self.slow_period, adjust=False).mean()
        
        # Calculate MACD line
        macd_line = ema_fast - ema_slow
        
        # Calculate signal line
        signal_line = macd_line.ewm(span=self.signal_period, adjust=False).mean()
        
        # Calculate histogram
        histogram = macd_line - signal_line
        
        return pd.DataFrame({
            'macd_line': macd_line,
            'signal_line': signal_line,
            'histogram': histogram
        })


class RSI:
    """
    RSI (Relative Strength Index) indicator.
    
    RSI measures the magnitude of recent price changes to evaluate
    overbought or oversold conditions.
    """
    
    def __init__(self, period=14):
        """
        Initialize RSI parameters.
        
        Args:
            period (int): RSI period (default: 14)
        """
        self.period = period
    
    def calculate(self, data):
        """
        Calculate RSI.
        
        Args:
            data (pd.Series or pd.DataFrame): Price data (close prices)
            
        Returns:
            pd.Series: RSI values (0-100)
        """
        if isinstance(data, pd.DataFrame):
            prices = data['close'] if 'close' in data.columns else data.iloc[:, 0]
        else:
            prices = data
        
        # Calculate price changes
        delta = prices.diff()
        
        # Separate gains and losses
        gains = delta.where(delta > 0, 0)
        losses = -delta.where(delta < 0, 0)
        
        # Calculate average gains and losses
        avg_gains = gains.rolling(window=self.period).mean()
        avg_losses = losses.rolling(window=self.period).mean()
        
        # Calculate RS and RSI
        rs = avg_gains / avg_losses
        rsi = 100 - (100 / (1 + rs))
        
        return rsi
