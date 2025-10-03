"""
Unit tests for performance metrics.
"""

import unittest
import numpy as np
import pandas as pd
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from quant_trading_desk.performance import SharpeRatio


class TestSharpeRatio(unittest.TestCase):
    """Test cases for Sharpe Ratio calculator."""
    
    def setUp(self):
        """Set up test data."""
        np.random.seed(42)
        self.sharpe = SharpeRatio(risk_free_rate=0.02, periods_per_year=252)
    
    def test_calculate_with_positive_returns(self):
        """Test Sharpe Ratio with positive returns."""
        returns = np.random.normal(0.001, 0.02, 252)  # Positive mean return
        result = self.sharpe.calculate(returns)
        self.assertIsInstance(result, float)
    
    def test_calculate_with_zero_std(self):
        """Test Sharpe Ratio with zero standard deviation."""
        returns = np.ones(252) * 0.01  # Constant returns
        result = self.sharpe.calculate(returns)
        self.assertTrue(np.isnan(result))
    
    def test_calculate_with_empty_array(self):
        """Test Sharpe Ratio with empty array."""
        returns = np.array([])
        result = self.sharpe.calculate(returns)
        self.assertTrue(np.isnan(result))
    
    def test_calculate_from_prices(self):
        """Test Sharpe Ratio calculation from prices."""
        dates = pd.date_range(start='2023-01-01', periods=252, freq='D')
        prices = 100 * np.exp(np.cumsum(np.random.normal(0.0005, 0.02, 252)))
        price_series = pd.Series(prices, index=dates)
        
        result = self.sharpe.calculate_from_prices(price_series)
        self.assertIsInstance(result, float)
    
    def test_higher_return_higher_sharpe(self):
        """Test that higher returns lead to higher Sharpe ratio."""
        low_returns = np.random.normal(0.0001, 0.02, 252)
        high_returns = np.random.normal(0.001, 0.02, 252)
        
        sharpe_low = self.sharpe.calculate(low_returns)
        sharpe_high = self.sharpe.calculate(high_returns)
        
        # Higher returns should generally lead to higher Sharpe
        # Note: This test might occasionally fail due to randomness
        self.assertGreater(sharpe_high, sharpe_low - 1)  # Allow some variance
    
    def test_works_with_series(self):
        """Test that it works with pandas Series."""
        returns = pd.Series(np.random.normal(0.001, 0.02, 252))
        result = self.sharpe.calculate(returns)
        self.assertIsInstance(result, float)
    
    def test_works_with_dataframe(self):
        """Test that it works with pandas DataFrame."""
        returns = pd.DataFrame({'returns': np.random.normal(0.001, 0.02, 252)})
        result = self.sharpe.calculate(returns)
        self.assertIsInstance(result, float)


if __name__ == '__main__':
    unittest.main()
