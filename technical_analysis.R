# Technical Analysis Module for Quant Trading Desk
# Functions for calculating technical indicators

library(TTR)
library(quantmod)

#' Calculate Simple Moving Average
#'
#' @param prices xts object with prices
#' @param n Number of periods
#' @return xts object with SMA
#' @export
calculate_sma <- function(prices, n = 20) {
  sma <- SMA(prices, n = n)
  return(sma)
}

#' Calculate Exponential Moving Average
#'
#' @param prices xts object with prices
#' @param n Number of periods
#' @return xts object with EMA
#' @export
calculate_ema <- function(prices, n = 20) {
  ema <- EMA(prices, n = n)
  return(ema)
}

#' Calculate Relative Strength Index
#'
#' @param prices xts object with prices
#' @param n Number of periods (default 14)
#' @return xts object with RSI
#' @export
calculate_rsi <- function(prices, n = 14) {
  rsi <- RSI(prices, n = n)
  return(rsi)
}

#' Calculate MACD
#'
#' @param prices xts object with prices
#' @param nFast Fast period (default 12)
#' @param nSlow Slow period (default 26)
#' @param nSig Signal period (default 9)
#' @return xts object with MACD
#' @export
calculate_macd <- function(prices, nFast = 12, nSlow = 26, nSig = 9) {
  macd <- MACD(prices, nFast = nFast, nSlow = nSlow, nSig = nSig, 
               maType = "EMA")
  return(macd)
}

#' Calculate Bollinger Bands
#'
#' @param prices xts object with prices
#' @param n Number of periods (default 20)
#' @param sd Number of standard deviations (default 2)
#' @return xts object with Bollinger Bands
#' @export
calculate_bbands <- function(prices, n = 20, sd = 2) {
  bbands <- BBands(prices, n = n, sd = sd)
  return(bbands)
}

#' Calculate Average True Range
#'
#' @param stock_data xts object with OHLC data
#' @param n Number of periods (default 14)
#' @return xts object with ATR
#' @export
calculate_atr <- function(stock_data, n = 14) {
  atr <- ATR(HLC(stock_data), n = n)
  return(atr)
}

#' Calculate Stochastic Oscillator
#'
#' @param stock_data xts object with OHLC data
#' @param nFastK Fast %K period (default 14)
#' @param nFastD Fast %D period (default 3)
#' @param nSlowD Slow %D period (default 3)
#' @return xts object with Stochastic
#' @export
calculate_stochastic <- function(stock_data, nFastK = 14, nFastD = 3, nSlowD = 3) {
  stoch <- stoch(HLC(stock_data), nFastK = nFastK, nFastD = nFastD, 
                 nSlowD = nSlowD)
  return(stoch)
}

#' Calculate Volume-Weighted Average Price
#'
#' @param stock_data xts object with OHLC and volume data
#' @return xts object with VWAP
#' @export
calculate_vwap <- function(stock_data) {
  typical_price <- (Hi(stock_data) + Lo(stock_data) + Cl(stock_data)) / 3
  vwap <- cumsum(typical_price * Vo(stock_data)) / cumsum(Vo(stock_data))
  colnames(vwap) <- "VWAP"
  return(vwap)
}

#' Generate Trading Signals based on Moving Average Crossover
#'
#' @param prices xts object with prices
#' @param short_period Short moving average period (default 50)
#' @param long_period Long moving average period (default 200)
#' @return xts object with signals (1 = buy, -1 = sell, 0 = hold)
#' @export
ma_crossover_signal <- function(prices, short_period = 50, long_period = 200) {
  short_ma <- SMA(prices, n = short_period)
  long_ma <- SMA(prices, n = long_period)
  
  signal <- ifelse(short_ma > long_ma, 1, -1)
  signal <- na.locf(signal, na.rm = FALSE)
  
  colnames(signal) <- "Signal"
  return(signal)
}
