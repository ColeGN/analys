
if (!require(corrplot, quietly = TRUE)) {
  tryCatch({
    install.packages("corrplot", repos = "https://cran.rstudio.com/")
    library(corrplot)
  }, error = function(e) {
    cat("Warning: corrplot not available, correlation matrix will not be plotted\n")
    HAS_CORRPLOT <- FALSE
  })
}

if (!require(car, quietly = TRUE)) {
  cat("Note: 'car' package not available, using basic R functions\n")
  HAS_CAR <- FALSE
} else {
  HAS_CAR <- TRUE
}

if (!require(lmtest, quietly = TRUE)) {
  cat("Note: 'lmtest' package not available\n")
  HAS_LMTEST <- FALSE
} else {
  HAS_LMTEST <- TRUE
}

if (!require(e1071, quietly = TRUE)) {
  tryCatch({
    install.packages("e1071", repos = "https://cran.rstudio.com/")
    library(e1071)
  }, error = function(e) {
    cat("Note: e1071 not available, will calculate skewness/kurtosis manually\n")
  })
}

cat("\n")
cat("===============================================\n")
cat("  CROSS-SECTIONAL DATA ANALYSIS (R)\n")
cat("===============================================\n\n")

load_data <- function(file_path = NULL) {
  
  cat("📂 Loading data...\n")
  
  if (!is.null(file_path) && file.exists(file_path)) {
    df <- read.csv(file_path)
    cat(sprintf("✅ Loaded %d observations from %s\n\n", nrow(df), file_path))
    return(df)
  } else {
    cat("⚠️  File not provided or not found. Creating sample data...\n\n")
    return(create_sample_data())
  }
}

create_sample_data <- function() {
  
  set.seed(42)
  n <- 200
  
  df <- data.frame(
    student_id = 1:n,
    study_hours = runif(n, 1, 10),
    previous_grade = runif(n, 50, 95),
    attendance = runif(n, 60, 100),
    sleep_hours = runif(n, 4, 9)
  )
  
  df$final_grade <- (40 + 
                      2.5 * df$study_hours + 
                      0.3 * df$previous_grade + 
                      0.2 * df$attendance + 
                      rnorm(n, 0, 5))
  df$final_grade <- pmax(0, pmin(100, df$final_grade))
  
  cat("✅ Created sample student performance dataset\n")
  cat("   Variables: study_hours, previous_grade, attendance,\n")
  cat("              sleep_hours, final_grade\n\n")
  
  return(df)
}

descriptive_analysis <- function(df, output_dir) {
  
  cat("\n")
  cat("===============================================\n")
  cat("  DESCRIPTIVE STATISTICS\n")
  cat("===============================================\n\n")
  
  numeric_cols <- names(df)[sapply(df, is.numeric)]
  numeric_cols <- numeric_cols[!grepl("id", numeric_cols, ignore.case = TRUE)]
  
  desc_stats <- data.frame(
    Variable = numeric_cols,
    Mean = sapply(df[numeric_cols], mean, na.rm = TRUE),
    Median = sapply(df[numeric_cols], median, na.rm = TRUE),
    SD = sapply(df[numeric_cols], sd, na.rm = TRUE),
    Min = sapply(df[numeric_cols], min, na.rm = TRUE),
    Max = sapply(df[numeric_cols], max, na.rm = TRUE),
    Skewness = sapply(df[numeric_cols], function(x) {
      skewness(x, na.rm = TRUE)
    }),
    Kurtosis = sapply(df[numeric_cols], function(x) {
      kurtosis(x, na.rm = TRUE)
    })
  )
  
  print(desc_stats, row.names = FALSE, digits = 3)
  
  stats_path <- file.path(output_dir, "results", "descriptive_statistics.csv")
  write.csv(desc_stats, stats_path, row.names = FALSE)
  cat("\n✅ Saved to:", stats_path, "\n")
  
  return(desc_stats)
}

correlation_analysis <- function(df, output_dir) {
  
  cat("\n")
  cat("===============================================\n")
  cat("  CORRELATION ANALYSIS\n")
  cat("===============================================\n\n")
  
  numeric_cols <- names(df)[sapply(df, is.numeric)]
  numeric_cols <- numeric_cols[!grepl("id", numeric_cols, ignore.case = TRUE)]
  
  corr_matrix <- cor(df[numeric_cols], use = "complete.obs")
  
  cat("Correlation Matrix:\n")
  print(round(corr_matrix, 3))
  cat("\n")
  
  corr_pairs <- data.frame()
  n_vars <- length(numeric_cols)
  
  for (i in 1:(n_vars-1)) {
    for (j in (i+1):n_vars) {
      corr_pairs <- rbind(corr_pairs, data.frame(
        Variable1 = numeric_cols[i],
        Variable2 = numeric_cols[j],
        Correlation = corr_matrix[i, j]
      ))
    }
  }
  
  corr_pairs <- corr_pairs[order(abs(corr_pairs$Correlation), decreasing = TRUE), ]
  
  cat("Strongest Correlations:\n")
  print(head(corr_pairs, 5), row.names = FALSE, digits = 3)
  cat("\n")
  
  plot_path <- file.path(output_dir, "plots", "correlation_matrix.png")
  png(plot_path, width = 1000, height = 1000, res = 120)
  corrplot(corr_matrix, method = "color", type = "upper",
           addCoef.col = "black", tl.col = "black", tl.srt = 45,
           title = "Correlation Matrix", mar = c(0,0,2,0))
  dev.off()
  
  cat("✅ Saved:", plot_path, "\n")
  
  return(corr_matrix)
}

regression_analysis <- function(df, dependent_var, independent_vars, output_dir) {
  
  cat("\n")
  cat("===============================================\n")
  cat("  MULTIPLE REGRESSION ANALYSIS\n")
cat("===============================================\n\n")

  cat("Dependent Variable:", dependent_var, "\n")
  cat("Independent Variables:", paste(independent_vars, collapse = ", "), "\n\n")
  
  formula_str <- paste(dependent_var, "~", paste(independent_vars, collapse = " + "))
  formula_obj <- as.formula(formula_str)
  
  model <- lm(formula_obj, data = df)
  
  cat("REGRESSION SUMMARY:\n")
  cat(rep("=", 60), "\n")
  print(summary(model))
  cat("\n")
  
  coefs <- coef(model)
  
  cat("REGRESSION EQUATION:\n")
  equation <- sprintf("%s = %.4f", dependent_var, coefs[1])
  for (i in 2:length(coefs)) {
    sign <- ifelse(coefs[i] >= 0, "+", "")
    equation <- paste0(equation, sprintf(" %s %.4f*%s", 
                                          sign, coefs[i], names(coefs)[i]))
  }
  cat(equation, "\n\n")
  
  r_squared <- summary(model)$r.squared
  adj_r_squared <- summary(model)$adj.r.squared
  rmse <- sqrt(mean(model$residuals^2))
  
  cat("MODEL FIT STATISTICS:\n")
  cat(sprintf("  R-squared:          %.4f\n", r_squared))
  cat(sprintf("  Adjusted R-squared: %.4f\n", adj_r_squared))
  cat(sprintf("  RMSE:               %.4f\n", rmse))
  cat(sprintf("  F-statistic:        %.4f\n", summary(model)$fstatistic[1]))
  cat(sprintf("  P-value:            %.4f\n\n", 
              pf(summary(model)$fstatistic[1], 
                 summary(model)$fstatistic[2],
                 summary(model)$fstatistic[3], 
                 lower.tail = FALSE)))
  
  cat("INTERPRETATION:\n")
  coef_abs <- abs(coefs[-1])
  strongest_idx <- which.max(coef_abs) + 1
  strongest_var <- names(coefs)[strongest_idx]
  strongest_coef <- coefs[strongest_idx]
  
  cat(sprintf("  • %s has the strongest effect\n", strongest_var))
  cat(sprintf("  • A 1-unit increase in %s leads to %.4f change in %s\n",
              strongest_var, strongest_coef, dependent_var))
  cat(sprintf("  • The model explains %.1f%% of the variance\n\n", 
              r_squared * 100))
  
  
  plot_path <- file.path(output_dir, "plots", "regression_fit.png")
  png(plot_path, width = 1000, height = 800, res = 120)
  plot(df[[dependent_var]], fitted(model),
       xlab = paste("Actual", dependent_var),
       ylab = paste("Predicted", dependent_var),
       main = sprintf("Actual vs Predicted %s\n(R² = %.3f)", 
                      dependent_var, r_squared),
       pch = 19, col = rgb(0, 0, 1, 0.5))
  abline(a = 0, b = 1, col = "red", lwd = 2, lty = 2)
  grid()
  dev.off()
  cat("✅ Saved:", plot_path, "\n")
  
  plot_path <- file.path(output_dir, "plots", "residuals.png")
  png(plot_path, width = 1000, height = 800, res = 120)
  plot(fitted(model), residuals(model),
       xlab = paste("Predicted", dependent_var),
       ylab = "Residuals",
       main = "Residual Plot",
       pch = 19, col = rgb(0, 0, 1, 0.5))
  abline(h = 0, col = "red", lwd = 2, lty = 2)
  grid()
  dev.off()
  cat("✅ Saved:", plot_path, "\n")
  
  plot_path <- file.path(output_dir, "plots", "regression_diagnostics.png")
  png(plot_path, width = 1400, height = 1400, res = 120)
  par(mfrow = c(2, 2))
  plot(model)
  dev.off()
  cat("✅ Saved:", plot_path, "\n")
  
  results <- data.frame(
    Variable = names(coefs),
    Coefficient = as.numeric(coefs),
    Std_Error = summary(model)$coefficients[, "Std. Error"],
    t_value = summary(model)$coefficients[, "t value"],
    p_value = summary(model)$coefficients[, "Pr(>|t|)"]
  )
  
  results_path <- file.path(output_dir, "results", "regression_results.csv")
  write.csv(results, results_path, row.names = FALSE)
  cat("✅ Saved:", results_path, "\n")
  
  return(model)
}

hypothesis_testing <- function(df, group_var, test_var, output_dir) {
  
  cat("\n")
cat("===============================================\n")
  cat("  HYPOTHESIS TESTING\n")
cat("===============================================\n\n")

  df_test <- df
  
  if (is.numeric(df_test[[group_var]])) {
    median_val <- median(df_test[[group_var]], na.rm = TRUE)
    df_test$group <- ifelse(df_test[[group_var]] > median_val, "High", "Low")
    group_var_used <- "group"
    cat("Created groups based on median split\n\n")
  } else {
    group_var_used <- group_var
  }
  
  groups <- unique(df_test[[group_var_used]])
  
  if (length(groups) == 2) {
    group1 <- df_test[df_test[[group_var_used]] == groups[1], test_var]
    group2 <- df_test[df_test[[group_var_used]] == groups[2], test_var]
    
    group1 <- group1[!is.na(group1)]
    group2 <- group2[!is.na(group2)]
    
    t_test <- t.test(group1, group2)
    
    cat("TWO-SAMPLE T-TEST\n")
    cat(sprintf("Testing: %s across %s groups\n\n", test_var, group_var_used))
    cat(sprintf("Group 1 (%s): Mean = %.3f, SD = %.3f, N = %d\n",
                groups[1], mean(group1), sd(group1), length(group1)))
    cat(sprintf("Group 2 (%s): Mean = %.3f, SD = %.3f, N = %d\n\n",
                groups[2], mean(group2), sd(group2), length(group2)))
    cat(sprintf("T-statistic: %.4f\n", t_test$statistic))
    cat(sprintf("P-value:     %.4f\n\n", t_test$p.value))
    
    if (t_test$p.value < 0.05) {
      cat(sprintf("✅ SIGNIFICANT: %s differs significantly between groups (p < 0.05)\n", 
                  test_var))
    } else {
      cat(sprintf("❌ NOT SIGNIFICANT: No significant difference (p ≥ 0.05)\n"))
    }
    
    plot_path <- file.path(output_dir, "plots", "hypothesis_test.png")
    png(plot_path, width = 1000, height = 800, res = 120)
    boxplot(df_test[[test_var]] ~ df_test[[group_var_used]],
            xlab = group_var_used,
            ylab = test_var,
            main = sprintf("%s by %s\n(p-value = %.4f)", 
                           test_var, group_var_used, t_test$p.value),
            col = c("lightblue", "lightcoral"))
    grid()
    dev.off()
    cat("\n✅ Saved:", plot_path, "\n")
    
  } else {
    formula_obj <- as.formula(paste(test_var, "~", group_var_used))
    anova_result <- aov(formula_obj, data = df_test)
    
    cat("ONE-WAY ANOVA\n")
    cat(sprintf("Testing: %s across %s groups\n\n", test_var, group_var_used))
    
    for (g in groups) {
      group_data <- df_test[df_test[[group_var_used]] == g, test_var]
      group_data <- group_data[!is.na(group_data)]
      cat(sprintf("%s: Mean = %.3f, SD = %.3f, N = %d\n",
                  g, mean(group_data), sd(group_data), length(group_data)))
}

cat("\n")
    print(summary(anova_result))
    
    p_value <- summary(anova_result)[[1]]$`Pr(>F)`[1]
    
    if (p_value < 0.05) {
      cat(sprintf("\n✅ SIGNIFICANT: %s differs significantly across groups (p < 0.05)\n",
                  test_var))
    } else {
      cat("\n❌ NOT SIGNIFICANT: No significant difference (p ≥ 0.05)\n")
    }
  }
}

main <- function() {
  
  current_dir <- getwd()
  
  if (grepl("scripts/r", current_dir, fixed = TRUE)) {
    project_root <- dirname(dirname(dirname(normalizePath(current_dir))))
  } else if (grepl("scripts", current_dir, fixed = TRUE)) {
    project_root <- dirname(dirname(normalizePath(current_dir)))
  } else {
    project_root <- normalizePath(current_dir)
  }
  
  if (!dir.exists(file.path(project_root, "data")) && !dir.exists(file.path(project_root, "output"))) {
    parent_root <- dirname(project_root)
    if (dir.exists(file.path(parent_root, "data")) || dir.exists(file.path(parent_root, "output"))) {
      project_root <- parent_root
    }
  }
  
  output_dir <- file.path(project_root, "output", "r")
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
  if (!dir.exists(file.path(output_dir, "plots"))) dir.create(file.path(output_dir, "plots"), recursive = TRUE)
  if (!dir.exists(file.path(output_dir, "results"))) dir.create(file.path(output_dir, "results"), recursive = TRUE)
  
  data_path <- file.path(project_root, "data", "cross_sectional_data.csv")
  df <- load_data(data_path)
  
  if (!file.exists(data_path)) {
    if (!dir.exists(file.path(project_root, "data"))) dir.create(file.path(project_root, "data"), recursive = TRUE)
    write.csv(df, data_path, row.names = FALSE)
    cat("💾 Sample data saved to:", data_path, "\n")
    cat("   You can replace this with your own cross-sectional dataset!\n\n")
  }
  
  cat("Dataset Preview:\n")
  print(head(df))
  cat("\n")
  
    desc_stats <- descriptive_analysis(df, output_dir)
  
  corr_matrix <- correlation_analysis(df, output_dir)
  
  numeric_cols <- names(df)[sapply(df, is.numeric)]
  numeric_cols <- numeric_cols[!grepl("id", numeric_cols, ignore.case = TRUE)]
  
  if ("final_grade" %in% names(df)) {
    dependent <- "final_grade"
    independent <- c("study_hours", "previous_grade", "attendance")
    independent <- independent[independent %in% names(df) & independent != dependent]
    } else {
    dependent <- numeric_cols[1]
    independent <- numeric_cols[2:min(4, length(numeric_cols))]
  }
  
  if (length(independent) > 0 && dependent %in% names(df)) {
    model <- regression_analysis(df, dependent, independent, output_dir)
    
    if (length(independent) > 0) {
      hypothesis_testing(df, independent[1], dependent, output_dir)
    }
  }
  
  cat("\n")
cat("===============================================\n")
  cat("  ANALYSIS COMPLETE! 🎉\n")
cat("===============================================\n\n")

  cat("📁 Generated files in:", output_dir, "/\n")
  cat("   • plots/correlation_matrix.png\n")
  cat("   • plots/regression_fit.png\n")
  cat("   • plots/residuals.png\n")
  cat("   • plots/regression_diagnostics.png\n")
  cat("   • plots/hypothesis_test.png\n")
  cat("   • results/descriptive_statistics.csv\n")
  cat("   • results/regression_results.csv\n\n")
  
  cat("✨ Ready for your exam!\n\n")
}

main()
