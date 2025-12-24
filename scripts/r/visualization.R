library(tidyverse)
library(gridExtra)
library(zoo)

cat("\n")
cat("===============================================\n")
cat("  CREATING EXTRA VISUALIZATIONS\n")
cat("===============================================\n\n")

df <- read.csv("data/EconomicsUSA.csv")
df$date <- as.Date(df$date)

cat("📊 Creating comparison plot...\n")

create_comparison_plot <- function(var_name) {
  y <- df[[var_name]]
  t <- 1:length(y)
  
  T <- length(y)
  m_T <- (T + 1) / 2
  v_T <- T * (T + 1) / 12
  c_T <- (sum(t * y) - T * (mean(y) * (T + 1) / 2)) / (T - 1)
  beta <- c_T / v_T
  alpha <- mean(y) - beta * m_T
  trend <- alpha + beta * t
  ma <- rollmean(y, k=4, fill=NA, align="right")
  
  detrended_linear <- y - trend
  detrended_ma <- y - ma
  
    png(sprintf("output/r/plots/%s_comparison.png", var_name), 
      width=1600, height=1200, res=120)
  
  par(mfrow=c(2,2), mar=c(4,4,3,2))
  
  plot(y, type="l", lwd=2, col="black",
       main=paste(toupper(var_name), "- Original with Trends"),
       xlab="Time", ylab="Value")
  lines(trend, col="red", lwd=2, lty=2)
  lines(ma, col="green", lwd=2, lty=2)
  legend("topleft", legend=c("Original", "Linear Trend", "MA(4)"),
         col=c("black", "red", "green"), lty=c(1,2,2), lwd=2, cex=0.8)
  grid()
  
  plot(detrended_linear, type="l", lwd=1.5, col="blue",
       main="Detrended Series (Linear Trend Removed)",
       xlab="Time", ylab="Deviation from Trend")
  abline(h=0, col="red", lty=2)
  grid()
  
  plot(detrended_ma, type="l", lwd=1.5, col="darkgreen",
       main="Detrended Series (MA Removed)",
       xlab="Time", ylab="Deviation from Trend")
  abline(h=0, col="red", lty=2)
  grid()
  
  boxplot(list(Linear=detrended_linear, MA=detrended_ma[!is.na(detrended_ma)]),
          main="Residuals Distribution",
          ylab="Residuals",
          col=c("lightblue", "lightgreen"))
  abline(h=0, col="red", lty=2)
  grid()
  
  dev.off()
  
  cat(sprintf("  ✅ Saved: output/r/plots/%s_comparison.png\n", var_name))
}

create_comparison_plot("indpro")
create_comparison_plot("cpiaucsl")

cat("\n📊 Creating decomposition plots...\n")

for (var in c("indpro", "cpiaucsl")) {
  y <- df[[var]]
  
  ts_data <- ts(y, start=c(1948, 1), frequency=12)
  
  decomp <- decompose(ts_data, type="additive")
  
  png(sprintf("output/r/plots/%s_decomposition.png", var), 
      width=1200, height=1000, res=120)
  plot(decomp, col="blue")
  dev.off()
  
  cat(sprintf("  ✅ Saved: output/r/plots/%s_decomposition.png\n", var))
}

cat("\n📊 Creating accuracy comparison chart...\n")

results <- read.csv("output/r/results/forecast_evaluation.csv")

png("output/r/plots/rmse_comparison.png", width=1000, height=600, res=120)

par(mar=c(8,5,4,2))
barplot(results$RMSE, 
        names.arg=results$Model,
        col=c("steelblue", "steelblue", "darkgreen", "darkgreen"),
        main="RMSE Comparison: Linear Trend vs Moving Average",
        ylab="Root Mean Squared Error (RMSE)",
        las=2,
        ylim=c(0, max(results$RMSE)*1.2))
grid()
text(x=1:nrow(results)*1.2-0.5, 
     y=results$RMSE+max(results$RMSE)*0.05, 
     labels=round(results$RMSE, 2), 
     pos=3, cex=0.9)

dev.off()

cat("  ✅ Saved: output/r/plots/rmse_comparison.png\n")

cat("\n📊 Creating correlation plot...\n")

png("output/r/plots/variables_correlation.png", width=800, height=800, res=120)

pairs(df[,c("indpro", "cpiaucsl", "unrate", "temp")],
      main="Correlation Matrix of All Variables",
      pch=19,
      col=rgb(0,0,1,0.3),
      cex=0.5)

dev.off()

cat("  ✅ Saved: output/r/plots/variables_correlation.png\n")

cat("\n")
cat("===============================================\n")
cat("ALL VISUALIZATIONS COMPLETE! 🎨\n")
cat("===============================================\n\n")

cat("📁 Generated files:\n")
list.files("output/r/plots", full.names=FALSE) %>%
  paste("   •", .) %>%
  cat(sep="\n")

cat("\n✨ Your analysis is presentation-ready!\n\n")
