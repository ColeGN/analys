# Gretl Time-Series Analysis

This directory contains portable Gretl scripts for time-series detrending analysis.

## Setup Instructions

### 1. Install Gretl

**macOS:**
```bash
# Option 1: Download from official website
# Visit: http://gretl.sourceforge.net/
# Download and install Gretl.app

# Option 2: Using Homebrew
brew install --cask gretl
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install gretl
```

**Windows:**
- Download installer from: http://gretl.sourceforge.net/
- Run the installer and follow instructions

### 2. Run the Analysis

The script automatically detects your system and Gretl installation:

```bash
# From project root directory
bash scripts/gretl/run.sh
```

Or run from any location:
```bash
# Navigate to the gretl scripts directory first
cd scripts/gretl
bash run.sh
```

### 3. Output Files

The analysis generates:
- `output/gretl/results/forecast_evaluation.csv` - Forecast metrics
- `output/gretl/plots/*.png` - Time-series plots

## Troubleshooting

**Error: "gretlcli not found"**
- Make sure Gretl is installed
- On macOS, the script looks for Gretl.app in `/Applications/`
- On Linux, make sure `gretlcli` is in your PATH

**Permission denied:**
```bash
chmod +x scripts/gretl/run.sh
```

**Missing output directories:**
The script automatically creates them, but you can manually create:
```bash
mkdir -p output/gretl/results output/gretl/plots
```

## What the Analysis Does

1. **Loads time-series data** from `data/EconomicsUSA.gdt`
2. **Estimates linear trends** for Industrial Production and CPI
3. **Applies moving average smoothing** (4-period MA)
4. **Calculates forecast metrics**: ME, RMSE, MAE, MPE, MAPE, Theil U
5. **Generates time-series plots** showing original data with trends/smoothing
6. **Exports results** to CSV and PNG files

## Files

- `detrend_analysis.inp` - Main Gretl script (portable, no hardcoded paths)
- `run.sh` - Cross-platform runner script
- `verify.sh` - Verification script for checking results