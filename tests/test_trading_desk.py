"""
Unit tests for Trading Desk.
"""

import unittest
import numpy as np
import pandas as pd
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from quant_trading_desk import TradingDesk


class TestTradingDesk(unittest.TestCase):
    """Test cases for Trading Desk."""
    
    def setUp(self):
        """Set up test data."""
        np.random.seed(42)
        dates = pd.date_range(start='2023-01-01', periods=100, freq='D')
        prices = 100 + np.cumsum(np.random.randn(100) * 2)
        self.data = pd.DataFrame({'close': prices}, index=dates)
        self.desk = TradingDesk()
    
    def test_analyze_returns_dict(self):
        """Test that analyze returns a dictionary."""
        result = self.desk.analyze(self.data)
        self.assertIsInstance(result, dict)
    
    def test_analyze_contains_all_indicators(self):
        """Test that analyze returns all indicators."""
        result = self.desk.analyze(self.data)
        self.assertIn('bollinger_bands', result)
        self.assertIn('macd', result)
        self.assertIn('rsi', result)
        self.assertIn('sharpe_ratio', result)
    
    def test_generate_signals_returns_dataframe(self):
        """Test that generate_signals returns a DataFrame."""
        result = self.desk.generate_signals(self.data)
        self.assertIsInstance(result, pd.DataFrame)
    
    def test_generate_signals_contains_all_signals(self):
        """Test that generate_signals returns all signal types."""
        result = self.desk.generate_signals(self.data)
        self.assertIn('bb_signal', result.columns)
        self.assertIn('macd_signal', result.columns)
        self.assertIn('rsi_signal', result.columns)
        self.assertIn('combined_signal', result.columns)
    
    def test_signals_are_valid(self):
        """Test that signals are within valid range."""
        result = self.desk.generate_signals(self.data)
        valid_data = result.dropna()
        
        # Individual signals should be -1, 0, or 1
        for col in ['bb_signal', 'macd_signal', 'rsi_signal']:
            self.assertTrue(valid_data[col].isin([-1, 0, 1]).all())
    
    def test_get_summary_returns_dict(self):
        """Test that get_summary returns a dictionary."""
        result = self.desk.get_summary(self.data)
        self.assertIsInstance(result, dict)
    
    def test_get_summary_contains_all_metrics(self):
        """Test that get_summary contains all expected metrics."""
        result = self.desk.get_summary(self.data)
        self.assertIn('current_price', result)
        self.assertIn('sharpe_ratio', result)
        self.assertIn('bollinger_bands', result)
        self.assertIn('macd', result)
        self.assertIn('rsi', result)
    
    def test_works_with_series_input(self):
        """Test that Trading Desk works with Series input."""
        series_data = self.data['close']
        result = self.desk.analyze(series_data)
        self.assertIsInstance(result, dict)


if __name__ == '__main__':
    unittest.main()
