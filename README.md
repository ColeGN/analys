# Cross-Sectional and Time-Series Data Analysis

This project provides comprehensive statistical analysis tools for both cross-sectional and time-series data using Python, R, and Gretl.

## 🚀 Quick Start

### Cross-Sectional Analysis
```bash
# Python
source venv/bin/activate
python scripts/python/detrend_analysis.py

# R
Rscript scripts/r/detrent.analysis.R
```

### Time-Series Analysis (Gretl)
```bash
# Works on any computer - no hardcoded paths!
bash scripts/gretl/run.sh
```

## 📁 Project Structure

```
├── data/
│   ├── EconomicsUSA.gdt          # Time-series data (1948-2025)
│   └── cross_sectional_data.csv  # Cross-sectional student data
├── scripts/
│   ├── python/                   # Cross-sectional analysis
│   ├── r/                        # Cross-sectional analysis  
│   └── gretl/                    # Time-series analysis (PORTABLE!)
└── output/
    ├── python/                   # Cross-sectional results
    ├── r/                        # Cross-sectional results
    └── gretl/                    # Time-series results
```

## 🔧 Setup Instructions

### For Cross-Sectional Analysis

**Python:**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

**R:**
```bash
Rscript scripts/r/install_packages.R
```

### For Time-Series Analysis (Gretl)

**macOS:**
```bash
# Download from: http://gretl.sourceforge.net/
# Or use Homebrew:
brew install --cask gretl
```

**Linux:**
```bash
sudo apt-get install gretl
```

**Windows:**
- Download installer from: http://gretl.sourceforge.net/

## 🎯 What Each Analysis Does

### Cross-Sectional Analysis
- **Multiple Regression**: `final_grade ~ study_hours + previous_grade + attendance`
- **Correlation Analysis**: Correlation matrices and heatmaps
- **Descriptive Statistics**: Mean, median, std dev, skewness, kurtosis
- **Hypothesis Testing**: t-tests comparing groups
- **Visualizations**: Scatter plots, box plots, residual plots

### Time-Series Analysis  
- **Linear Trend Estimation**: `Tt = α + βt`
- **Moving Average Smoothing**: 4-period MA filter
- **Forecast Evaluation**: ME, RMSE, MAE, MPE, MAPE, Theil U
- **Time-Series Plots**: Original data with trend/smoothing overlays

## 📊 Generated Output

### Cross-Sectional Results
- `correlation_matrix.png` - Variable correlations
- `regression_fit.png` - Actual vs predicted scatter
- `hypothesis_test.png` - Group comparison box plots
- `descriptive_statistics.csv` - Summary statistics
- `regression_results.csv` - Model coefficients

### Time-Series Results
- `indpro_linear_trend.png` - Industrial production with trend
- `cpiaucsl_moving_average.png` - CPI with moving average
- `forecast_evaluation.csv` - All forecast metrics

## 🌍 Sharing Your Project

The Gretl scripts are now **100% portable**! Your friends can run them on any computer:

1. **Share the entire project folder**
2. **They just need to install Gretl** (any version)
3. **Run**: `bash scripts/gretl/run.sh`
4. **It works!** No path editing needed

### Test Portability
```bash
bash scripts/gretl/test_portable.sh
```

## 📚 Documentation

- `scripts/gretl/README.md` - Detailed Gretl setup and troubleshooting
- `documentation/README.md` - Additional project documentation

## ✅ Verification

Both analyses have been verified to meet academic requirements:
- ✅ Cross-sectional: Multiple regression, correlation, descriptive stats, hypothesis testing
- ✅ Time-series: Trend estimation, smoothing, forecast evaluation, time-series plots