"""
Performance Metrics Module
Implements Sharpe Ratio and other performance metrics.
"""

import numpy as np
import pandas as pd


class SharpeRatio:
    """
    Sharpe Ratio calculator.
    
    The Sharpe Ratio measures the risk-adjusted return of an investment.
    It's calculated as (return - risk_free_rate) / standard_deviation.
    """
    
    def __init__(self, risk_free_rate=0.02, periods_per_year=252):
        """
        Initialize Sharpe Ratio parameters.
        
        Args:
            risk_free_rate (float): Annual risk-free rate (default: 0.02 or 2%)
            periods_per_year (int): Trading periods per year (default: 252 for daily data)
        """
        self.risk_free_rate = risk_free_rate
        self.periods_per_year = periods_per_year
    
    def calculate(self, returns):
        """
        Calculate Sharpe Ratio.
        
        Args:
            returns (pd.Series or np.array): Return series (can be prices or returns)
            
        Returns:
            float: Annualized Sharpe Ratio
        """
        if isinstance(returns, pd.DataFrame):
            returns = returns.iloc[:, 0]
        
        # Convert to numpy array if needed
        if isinstance(returns, pd.Series):
            returns = returns.values
        
        # Remove NaN values
        returns = returns[~np.isnan(returns)]
        
        if len(returns) == 0:
            return np.nan
        
        # Calculate mean return and standard deviation
        mean_return = np.mean(returns)
        std_return = np.std(returns, ddof=1)
        
        if std_return == 0:
            return np.nan
        
        # Calculate daily risk-free rate
        daily_rf_rate = self.risk_free_rate / self.periods_per_year
        
        # Calculate Sharpe Ratio
        sharpe = (mean_return - daily_rf_rate) / std_return
        
        # Annualize the Sharpe Ratio
        annualized_sharpe = sharpe * np.sqrt(self.periods_per_year)
        
        return annualized_sharpe
    
    def calculate_from_prices(self, prices):
        """
        Calculate Sharpe Ratio from price series.
        
        Args:
            prices (pd.Series or pd.DataFrame): Price series
            
        Returns:
            float: Annualized Sharpe Ratio
        """
        if isinstance(prices, pd.DataFrame):
            prices = prices['close'] if 'close' in prices.columns else prices.iloc[:, 0]
        
        # Calculate returns
        returns = prices.pct_change().dropna()
        
        return self.calculate(returns)
