library(zoo)
library(forecast)

cat("\n")
cat("===============================================\n")
cat("  TIME SERIES DETRENDING ANALYSIS (R)\n")
cat("===============================================\n\n")
estimate_params <- function(y) {
  T <- length(y)
  t <- 1:T
  m_T <- (T + 1) / 2
  v_T <- T * (T + 1) / 12
  c_T <- (sum(t * y) - T * (mean(y) * (T + 1) / 2)) / (T - 1)
  
  beta <- c_T / v_T
  alpha <- mean(y) - beta * m_T
  
  return(c(alpha=alpha, beta=beta))
}

ME <- function(actual, forecast) {
  mean(actual - forecast, na.rm=TRUE)
}

RMSE <- function(actual, forecast) {
  sqrt(mean((actual - forecast)^2, na.rm=TRUE))
}

MAE <- function(actual, forecast) {
  mean(abs(actual - forecast), na.rm=TRUE)
}

MPE <- function(actual, forecast) {
  mean(100 * (actual - forecast) / actual, na.rm=TRUE)
}

MAPE <- function(actual, forecast) {
  mean(100 * abs((actual - forecast) / actual), na.rm=TRUE)
}

TheilU <- function(actual, forecast) {
  n <- length(actual)
  if (n <= 1) return(NA)
  
  actual_shifted <- actual[2:n]
  forecast_shifted <- forecast[1:(n-1)]
  actual_current <- actual[1:(n-1)]
  
  numerator <- mean(((forecast_shifted - actual_shifted) / actual_current)^2, na.rm=TRUE)
  denominator <- mean(((actual_shifted - actual_current) / actual_current)^2, na.rm=TRUE)
  
  if (is.na(denominator) || denominator == 0) return(NA)
  return(numerator / denominator)
}

MSE_decomposition <- function(actual, forecast) {
  T <- length(actual)
  scale <- (T - 1) / T
  
  y_mean <- mean(actual, na.rm=TRUE)
  f_mean <- mean(forecast, na.rm=TRUE)
  sy <- sqrt(scale * var(actual, na.rm=TRUE))
  sf <- sqrt(scale * var(forecast, na.rm=TRUE))
  
  r <- tryCatch({
    cor(actual, forecast, use="complete.obs")
  }, error = function(e) {
    if (length(actual) == length(forecast) && sum(!is.na(actual) & !is.na(forecast)) > 0) {
      cor(actual, forecast, use="pairwise.complete.obs")
    } else {
      0
    }
  })
  
  if (is.na(r)) r <- 0
  
  bias <- (y_mean - f_mean)^2
  regression <- (sf - r * sy)^2
  disturbance <- (1 - r^2) * sy^2
  
  MSE_total <- bias + regression + disturbance
  
  if (MSE_total == 0 || is.na(MSE_total)) {
    return(list(MSE=0, UM=0, UR=0, UD=0))
  }
  
  UM <- bias / MSE_total
  UR <- regression / MSE_total
  UD <- disturbance / MSE_total
  
  return(list(MSE=MSE_total, UM=UM, UR=UR, UD=UD))
}

if (!dir.exists("output")) dir.create("output")
if (!dir.exists("output/r")) dir.create("output/r")
if (!dir.exists("output/r/plots")) dir.create("output/r/plots")
if (!dir.exists("output/r/results")) dir.create("output/r/results")

cat("📂 Loading data...\n")

df <- read.csv("data/EconomicsUSA.csv")
df$date <- as.Date(df$date)

cat("   Observations:", nrow(df), "\n")
cat("   Variables:", paste(names(df), collapse=", "), "\n\n")

variables <- c("indpro", "cpiaucsl")

forecasts <- list()
results <- data.frame()

cat("===============================================\n")
cat("METHOD 1: LINEAR TREND ESTIMATION\n")
cat("===============================================\n\n")

for (i in seq_along(variables)) {
  var_name <- variables[i]
  y <- df[[var_name]]
  
    params <- estimate_params(y)
  alpha <- params["alpha"]
  beta <- params["beta"]
  
  t <- 1:length(y)
  trend <- alpha + beta * t
  
  forecasts[[paste0("TREND_", i)]] <- trend
  
  cat(sprintf("%s:\n", toupper(var_name)))
  cat(sprintf("  Trend equation: TT = %.6f + %.6f*t\n", alpha, beta))
  cat(sprintf("  Interpretation: %s trend by %.6f per period\n\n", 
              ifelse(beta > 0, "Increasing", "Decreasing"), abs(beta)))
  
  png(sprintf("output/r/plots/%s_linear_trend.png", var_name), 
      width=1200, height=600, res=120)
  plot(y, type="l", lwd=2, col="blue",
       main=sprintf("%s - Linear Trend", toupper(var_name)),
       xlab="Time Period", ylab="Value")
  lines(trend, lwd=2, col="red", lty=2)
  legend("topleft", legend=c("Original", "Linear Trend"),
         col=c("blue", "red"), lty=c(1,2), lwd=2)
  grid()
  dev.off()
  
  cat(sprintf("  ✅ Saved: output/r/plots/%s_linear_trend.png\n\n", var_name))
}

cat("===============================================\n")
cat("METHOD 2: MOVING AVERAGE (ORDER=4)\n")
cat("===============================================\n\n")

for (i in seq_along(variables)) {
  var_name <- variables[i]
  y <- df[[var_name]]
  
  ma <- rollmean(y, k=4, fill=NA, align="right")
  
  forecasts[[paste0("MA_", i)]] <- ma
  
  cat(sprintf("%s:\n", toupper(var_name)))
  cat("  Moving average window: 4 periods\n")
  cat("  First 3 values are NA (not enough data)\n\n")
  
  png(sprintf("output/r/plots/%s_moving_average.png", var_name), 
      width=1200, height=600, res=120)
  plot(y, type="l", lwd=2, col="blue",
       main=sprintf("%s - Moving Average", toupper(var_name)),
       xlab="Time Period", ylab="Value")
  lines(ma, lwd=2, col="green")
  legend("topleft", legend=c("Original", "Moving Average (4)"),
         col=c("blue", "green"), lty=1, lwd=2)
  grid()
  dev.off()
  
  cat(sprintf("  ✅ Saved: output/r/plots/%s_moving_average.png\n\n", var_name))
}

cat("===============================================\n")
cat("FORECAST EVALUATION STATISTICS\n")
cat("===============================================\n\n")

X <- c(df$indpro, df$cpiaucsl, df$indpro, df$cpiaucsl)

for (j in seq_along(forecasts)) {
  forecast_name <- names(forecasts)[j]
  forecast_values <- forecasts[[j]]
  actual <- X[[j]]
  
  valid_idx <- !is.na(forecast_values) & !is.na(actual)
  actual_clean <- actual[valid_idx]
  forecast_clean <- forecast_values[valid_idx]
  
  if (length(actual_clean) > 1) {
    mse_result <- MSE_decomposition(actual_clean, forecast_clean)
    
    result_row <- data.frame(
      Model = forecast_name,
      ME = ME(actual_clean, forecast_clean),
      RMSE = RMSE(actual_clean, forecast_clean),
      MAE = MAE(actual_clean, forecast_clean),
      MPE = MPE(actual_clean, forecast_clean),
      MAPE = MAPE(actual_clean, forecast_clean),
      Theil_U = TheilU(actual_clean, forecast_clean),
      MSE = mse_result$MSE,
      UM = mse_result$UM,
      UR = mse_result$UR,
      UD = mse_result$UD
    )
    
    results <- rbind(results, result_row)
  }
}

cat("\n")
print(results, row.names=FALSE, digits=4)

write.csv(results, "output/r/results/forecast_evaluation.csv", row.names=FALSE)
cat("\n✅ Results saved to: output/r/results/forecast_evaluation.csv\n")

cat("\n")
cat("===============================================\n")
cat("INTERPRETATION GUIDE\n")
cat("===============================================\n\n")

cat("Lower values = Better forecast accuracy\n\n")
cat("• ME (Mean Error): Measures bias (closer to 0 = better)\n")
cat("• RMSE: Penalizes large errors, good overall measure\n")
cat("• MAE: Average error magnitude\n")
cat("• MAPE: Percentage error (easy to interpret)\n")
cat("• Theil's U: Normalized accuracy (< 1 = better than naive forecast)\n\n")

cat("MSE Decomposition:\n")
cat("• UM: Bias proportion (systematic over/under prediction)\n")
cat("• UR: Regression proportion (different variation)\n")
cat("• UD: Disturbance proportion (unexplained randomness)\n\n")
        
best_trend <- results[results$Model %in% c("TREND_1", "TREND_2"),]
best_ma <- results[results$Model %in% c("MA_1", "MA_2"),]

cat("===============================================\n")
cat("SUMMARY\n")
cat("===============================================\n\n")

for (var in variables) {
  cat(sprintf("%s:\n", toupper(var)))
  idx <- grep(toupper(substr(var, 1, 3)), c("INDPRO", "CPIAUCSL"))
  
  trend_rmse <- results[results$Model == paste0("TREND_", idx), "RMSE"]
  ma_rmse <- results[results$Model == paste0("MA_", idx), "RMSE"]
  
  if (length(trend_rmse) > 0 && length(ma_rmse) > 0 && 
      !is.na(trend_rmse) && !is.na(ma_rmse)) {
    if (trend_rmse < ma_rmse) {
      cat("  → Linear Trend performs better (lower RMSE)\n")
    } else {
      cat("  → Moving Average performs better (lower RMSE)\n")
    }
  } else {
    cat("  → Cannot compare (missing RMSE values)\n")
  }
  cat("\n")
}

cat("===============================================\n")
cat("ANALYSIS COMPLETE! 🎉\n")
cat("===============================================\n\n")

cat("📁 Check your output folder:\n")
cat("   output/r/plots/     - All visualizations\n")
cat("   output/r/results/   - Forecast evaluation CSV\n\n")

cat("✨ You're ready for your exam!\n\n")
