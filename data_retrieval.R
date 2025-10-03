# Data Retrieval Module for Quant Trading Desk
# Functions to pull stock data from Yahoo Finance

library(quantmod)
library(xts)

#' Get Stock Data from Yahoo Finance
#'
#' @param symbols Character vector of stock symbols
#' @param start_date Start date in 'YYYY-MM-DD' format
#' @param end_date End date in 'YYYY-MM-DD' format
#' @return List of xts objects containing stock data
#' @export
get_stock_data <- function(symbols, start_date, end_date = Sys.Date()) {
  stock_data <- list()
  
  for (symbol in symbols) {
    tryCatch({
      cat(sprintf("Fetching data for %s...\n", symbol))
      data <- getSymbols(symbol, 
                        src = "yahoo",
                        from = start_date,
                        to = end_date,
                        auto.assign = FALSE)
      stock_data[[symbol]] <- data
      cat(sprintf("Successfully fetched %s\n", symbol))
    }, error = function(e) {
      cat(sprintf("Error fetching %s: %s\n", symbol, e$message))
    })
  }
  
  return(stock_data)
}

#' Get Stock Returns
#'
#' @param stock_data xts object with stock prices
#' @param type Type of return calculation: "arithmetic" or "log"
#' @return xts object with returns
#' @export
calculate_returns <- function(stock_data, type = "arithmetic") {
  if (type == "log") {
    returns <- diff(log(Cl(stock_data)))
  } else {
    returns <- dailyReturn(stock_data, type = "arithmetic")
  }
  
  returns <- na.omit(returns)
  return(returns)
}

#' Get Multiple Stock Prices
#'
#' @param stock_data_list List of xts objects
#' @param price_type Type of price: "Close", "Open", "High", "Low", "Adjusted"
#' @return xts object with prices for all stocks
#' @export
get_prices_matrix <- function(stock_data_list, price_type = "Adjusted") {
  prices <- do.call(merge, lapply(names(stock_data_list), function(symbol) {
    if (price_type == "Adjusted") {
      price <- Ad(stock_data_list[[symbol]])
    } else if (price_type == "Close") {
      price <- Cl(stock_data_list[[symbol]])
    } else if (price_type == "Open") {
      price <- Op(stock_data_list[[symbol]])
    } else if (price_type == "High") {
      price <- Hi(stock_data_list[[symbol]])
    } else if (price_type == "Low") {
      price <- Lo(stock_data_list[[symbol]])
    }
    colnames(price) <- symbol
    return(price)
  }))
  
  return(prices)
}
