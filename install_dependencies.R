# Installation Script for Quant Trading Desk Dependencies
# Run this script to install all required R packages

cat("========================================\n")
cat("Quant Trading Desk - Dependency Installer\n")
cat("========================================\n\n")

# List of required packages
required_packages <- c(
  "quantmod",           # For fetching stock data from Yahoo Finance
  "TTR",                # Technical Trading Rules and indicators
  "PerformanceAnalytics", # Performance and risk analytics
  "PortfolioAnalytics", # Portfolio optimization
  "xts",                # Extensible time series
  "zoo",                # Time series infrastructure
  "ROI",                # R Optimization Infrastructure
  "ROI.plugin.glpk",    # Linear programming solver
  "ROI.plugin.quadprog", # Quadratic programming solver
  "ggplot2",            # Data visualization
  "gridExtra"           # Arrange multiple plots
)

cat("Checking and installing required packages...\n\n")

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", package))
    install.packages(package, dependencies = TRUE, repos = "http://cran.rstudio.com/")
    
    # Verify installation
    if (require(package, character.only = TRUE, quietly = TRUE)) {
      cat(sprintf("✓ %s installed successfully\n", package))
      return(TRUE)
    } else {
      cat(sprintf("✗ Failed to install %s\n", package))
      return(FALSE)
    }
  } else {
    cat(sprintf("✓ %s already installed\n", package))
    return(TRUE)
  }
}

# Install all packages
installation_results <- sapply(required_packages, install_if_missing)

# Summary
cat("\n========================================\n")
cat("Installation Summary\n")
cat("========================================\n")
cat(sprintf("Total packages: %d\n", length(required_packages)))
cat(sprintf("Successfully installed/verified: %d\n", sum(installation_results)))
cat(sprintf("Failed: %d\n", sum(!installation_results)))

if (all(installation_results)) {
  cat("\n✓ All dependencies installed successfully!\n")
  cat("You can now run the trading desk scripts.\n")
} else {
  cat("\n✗ Some packages failed to install.\n")
  cat("Please install them manually using:\n")
  cat("install.packages(c(\"", paste(names(installation_results[!installation_results]), 
                                      collapse = "\", \""), "\"))\n", sep = "")
}

cat("\n========================================\n")
