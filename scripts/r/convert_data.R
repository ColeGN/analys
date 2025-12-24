library(XML)

cat("===============================================\n")
cat("  GRETL TO CSV CONVERTER\n")
cat("===============================================\n\n")


convert_gretl_to_csv <- function(gdt_file, output_csv) {
  
  cat("📂 Reading Gretl file:", gdt_file, "\n")
  
  tryCatch({
    doc <- xmlParse(gdt_file)
    root <- xmlRoot(doc)
    variables_node <- root[["variables"]]
    var_names <- sapply(xmlChildren(variables_node), xmlGetAttr, "name")
    
    cat("   Variables found:", paste(var_names, collapse=", "), "\n")
    
    obs_node <- root[["observations"]]
    obs_list <- xmlChildren(obs_node)
    
    data_list <- lapply(obs_list, function(x) {
      values <- strsplit(xmlValue(x), "\\s+")[[1]]
      as.numeric(values[values != ""])
    })
    
    df <- do.call(rbind, data_list)
    colnames(df) <- var_names
    df <- as.data.frame(df)
    
    n_obs <- nrow(df)
    dates <- seq(as.Date("1948-01-01"), by="month", length.out=n_obs)
    df <- cbind(date=dates, df)
    
    write.csv(df, output_csv, row.names=FALSE)
    
    cat("✅ SUCCESS!\n")
    cat("   Observations:", n_obs, "\n")
    cat("   Saved to:", output_csv, "\n\n")
    
    cat("First 5 rows:\n")
    print(head(df, 5))
    
    return(df)
    
  }, error = function(e) {
    cat("❌ ERROR:", conditionMessage(e), "\n")
    cat("\nTroubleshooting:\n")
    cat("  1. Make sure EconomicsUSA.gdt is in the 'data/' folder\n")
    cat("  2. Check if the file path is correct\n")
    cat("  3. Ensure the XML package is installed\n")
    return(NULL)
  })
}

create_csv_manually <- function() {
  
  cat("\n📝 ALTERNATIVE METHOD: Creating CSV manually\n")
  cat("If you can't read the .gdt file, use this method:\n\n")
  
  cat("To use this method:\n")
  cat("1. Open EconomicsUSA.gdt in a text editor\n")
  cat("2. Copy all the <obs>...</obs> content\n")
  cat("3. Paste it in the 'raw_data' variable below\n")
  cat("4. Run this function\n\n")
  
  cat("⚠️ This method requires manual data entry\n")
}


gdt_file <- "data/EconomicsUSA.gdt"
output_csv <- "data/EconomicsUSA.csv"

if (!dir.exists("data")) {
  dir.create("data")
  cat("📁 Created 'data' folder\n")
}

if (!dir.exists("output")) {
  dir.create("output")
  dir.create("output/r")
  dir.create("output/r/plots")
  dir.create("output/r/results")
  cat("📁 Created 'output/r' folders\n\n")
}

cat("Starting conversion...\n\n")
df <- convert_gretl_to_csv(gdt_file, output_csv)

if (is.null(df)) {
  cat("\n" , rep("=", 50), "\n")
  cat("Conversion failed. Trying alternative method...\n")
  create_csv_manually()
} else {
  cat("\n", rep("=", 50), "\n")
  cat("🎉 Data ready for analysis!\n")
  cat("Next step: Run 02_detrend_analysis.R\n")
  cat(rep("=", 50), "\n")
}

rm(list=c("gdt_file", "output_csv"))
