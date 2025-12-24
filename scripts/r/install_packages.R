install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", pkg))
    install.packages(pkg, dependencies = TRUE, repos = "https://cran.rstudio.com/")
    library(pkg, character.only = TRUE)
  } else {
    cat(sprintf("✓ %s is already installed\n", pkg))
  }
}
packages <- c(
  "tidyverse",
  "forecast",
  "zoo",
  "ggplot2",
  "dplyr",
  "readr"
)

cat("\nChecking and installing packages...\n\n")
for (pkg in packages) {
  install_if_missing(pkg)
}

cat("\n===============================================\n")
cat("  ALL PACKAGES READY! 🎉\n")
cat("===============================================\n")
cat("\nYou can now run the analysis scripts!\n\n")

cat("Testing packages...\n")
library(tidyverse)
library(forecast)
library(zoo)

cat("\n✅ All tests passed! You're ready to go!\n")
