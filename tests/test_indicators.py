"""
Unit tests for technical indicators.
"""

import unittest
import numpy as np
import pandas as pd
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from quant_trading_desk.indicators import BollingerBands, MACD, RSI


class TestBollingerBands(unittest.TestCase):
    """Test cases for Bollinger Bands indicator."""
    
    def setUp(self):
        """Set up test data."""
        np.random.seed(42)
        dates = pd.date_range(start='2023-01-01', periods=100, freq='D')
        prices = 100 + np.cumsum(np.random.randn(100) * 2)
        self.data = pd.Series(prices, index=dates)
        self.bb = BollingerBands(period=20, std_dev=2)
    
    def test_calculate_returns_dataframe(self):
        """Test that calculate returns a DataFrame."""
        result = self.bb.calculate(self.data)
        self.assertIsInstance(result, pd.DataFrame)
    
    def test_calculate_has_correct_columns(self):
        """Test that result has correct columns."""
        result = self.bb.calculate(self.data)
        self.assertIn('upper_band', result.columns)
        self.assertIn('middle_band', result.columns)
        self.assertIn('lower_band', result.columns)
    
    def test_upper_band_greater_than_lower_band(self):
        """Test that upper band is greater than lower band."""
        result = self.bb.calculate(self.data)
        # Skip NaN values
        valid_data = result.dropna()
        self.assertTrue((valid_data['upper_band'] > valid_data['lower_band']).all())
    
    def test_middle_band_between_bands(self):
        """Test that middle band is between upper and lower bands."""
        result = self.bb.calculate(self.data)
        valid_data = result.dropna()
        self.assertTrue((valid_data['middle_band'] >= valid_data['lower_band']).all())
        self.assertTrue((valid_data['middle_band'] <= valid_data['upper_band']).all())
    
    def test_works_with_dataframe_input(self):
        """Test that it works with DataFrame input."""
        df = pd.DataFrame({'close': self.data})
        result = self.bb.calculate(df)
        self.assertIsInstance(result, pd.DataFrame)


class TestMACD(unittest.TestCase):
    """Test cases for MACD indicator."""
    
    def setUp(self):
        """Set up test data."""
        np.random.seed(42)
        dates = pd.date_range(start='2023-01-01', periods=100, freq='D')
        prices = 100 + np.cumsum(np.random.randn(100) * 2)
        self.data = pd.Series(prices, index=dates)
        self.macd = MACD(fast_period=12, slow_period=26, signal_period=9)
    
    def test_calculate_returns_dataframe(self):
        """Test that calculate returns a DataFrame."""
        result = self.macd.calculate(self.data)
        self.assertIsInstance(result, pd.DataFrame)
    
    def test_calculate_has_correct_columns(self):
        """Test that result has correct columns."""
        result = self.macd.calculate(self.data)
        self.assertIn('macd_line', result.columns)
        self.assertIn('signal_line', result.columns)
        self.assertIn('histogram', result.columns)
    
    def test_histogram_is_difference(self):
        """Test that histogram is difference between MACD and signal."""
        result = self.macd.calculate(self.data)
        valid_data = result.dropna()
        calculated_histogram = valid_data['macd_line'] - valid_data['signal_line']
        np.testing.assert_array_almost_equal(
            valid_data['histogram'].values,
            calculated_histogram.values,
            decimal=10
        )
    
    def test_works_with_dataframe_input(self):
        """Test that it works with DataFrame input."""
        df = pd.DataFrame({'close': self.data})
        result = self.macd.calculate(df)
        self.assertIsInstance(result, pd.DataFrame)


class TestRSI(unittest.TestCase):
    """Test cases for RSI indicator."""
    
    def setUp(self):
        """Set up test data."""
        np.random.seed(42)
        dates = pd.date_range(start='2023-01-01', periods=100, freq='D')
        prices = 100 + np.cumsum(np.random.randn(100) * 2)
        self.data = pd.Series(prices, index=dates)
        self.rsi = RSI(period=14)
    
    def test_calculate_returns_series(self):
        """Test that calculate returns a Series."""
        result = self.rsi.calculate(self.data)
        self.assertIsInstance(result, pd.Series)
    
    def test_rsi_range(self):
        """Test that RSI values are between 0 and 100."""
        result = self.rsi.calculate(self.data)
        valid_data = result.dropna()
        self.assertTrue((valid_data >= 0).all())
        self.assertTrue((valid_data <= 100).all())
    
    def test_works_with_dataframe_input(self):
        """Test that it works with DataFrame input."""
        df = pd.DataFrame({'close': self.data})
        result = self.rsi.calculate(df)
        self.assertIsInstance(result, pd.Series)
    
    def test_extreme_values(self):
        """Test RSI with extreme price movements."""
        # Create data with strong uptrend
        dates = pd.date_range(start='2023-01-01', periods=50, freq='D')
        uptrend = pd.Series(range(100, 150), index=dates)
        rsi_up = self.rsi.calculate(uptrend)
        
        # RSI should be high for uptrend
        self.assertGreater(rsi_up.iloc[-1], 50)


if __name__ == '__main__':
    unittest.main()
