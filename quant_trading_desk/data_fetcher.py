"""
Data Fetcher Module
Provides utilities to fetch historical market data.
"""

import pandas as pd


def fetch_data(ticker, start_date=None, end_date=None, period='1y'):
    """
    Fetch historical market data for a given ticker.
    
    Args:
        ticker (str): Stock ticker symbol (e.g., 'AAPL', 'GOOGL')
        start_date (str): Start date in 'YYYY-MM-DD' format
        end_date (str): End date in 'YYYY-MM-DD' format
        period (str): Period to fetch (e.g., '1y', '6mo', '1mo') if dates not specified
        
    Returns:
        pd.DataFrame: Historical price data with OHLCV columns
    """
    try:
        import yfinance as yf
        
        if start_date and end_date:
            data = yf.download(ticker, start=start_date, end=end_date, progress=False)
        else:
            data = yf.download(ticker, period=period, progress=False)
        
        # Standardize column names to lowercase
        data.columns = [col.lower() for col in data.columns]
        
        return data
    except ImportError:
        raise ImportError(
            "yfinance is required to fetch market data. "
            "Install it with: pip install yfinance"
        )
    except Exception as e:
        raise Exception(f"Error fetching data for {ticker}: {str(e)}")


def load_csv(filepath, date_column='Date'):
    """
    Load market data from a CSV file.
    
    Args:
        filepath (str): Path to CSV file
        date_column (str): Name of the date column (default: 'Date')
        
    Returns:
        pd.DataFrame: Price data with datetime index
    """
    data = pd.read_csv(filepath)
    
    if date_column in data.columns:
        data[date_column] = pd.to_datetime(data[date_column])
        data.set_index(date_column, inplace=True)
    
    # Standardize column names to lowercase
    data.columns = [col.lower() for col in data.columns]
    
    return data
