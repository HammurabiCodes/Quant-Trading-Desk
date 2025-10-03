"""
Quant Trading Desk - Financial Analytics Package
Provides technical indicators for quantitative trading analysis.
"""

from .indicators import BollingerBands, MACD, RSI
from .performance import SharpeRatio
from .trading_desk import TradingDesk

__version__ = "1.0.0"
__all__ = ["BollingerBands", "MACD", "RSI", "SharpeRatio", "TradingDesk"]
