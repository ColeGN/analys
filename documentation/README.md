# Time Series Analysis Project - Complete Guide

Complete documentation for **Python**, **R**, and **Gretl** implementations of time series detrending analysis.

---

## 📁 Project Structure

```
project/
├── data/                    # Shared data files (.gdt and .csv)
├── scripts/
│   ├── python/            # Python scripts (separate project)
│   │   ├── convert_data.py
│   │   └── detrend_analysis.py
│   └── r/                  # R scripts (separate project)
│       ├── convert_data.R
│       ├── detrent.analysis.R
│       ├── install_packages.R
│       └── visualization.R
│   └── gretl/              # Gretl scripts
│       ├── detrend_analysis.inp
│       ├── run.sh
│       └── verify.sh
├── output/
│   ├── python/            # Python outputs ONLY
│   │   ├── plots/         # Python visualizations
│   │   └── results/       # Python results CSV
│   ├── r/                 # R outputs ONLY
│   │   ├── plots/         # R visualizations
│   │   └── results/       # R results CSV
│   └── gretl/             # Gretl outputs
│       ├── plots/         # Gretl visualizations
│       └── results/       # Gretl results CSV
├── documentation/          # This folder - all documentation
├── requirements.txt       # Python dependencies
└── venv/                  # Python virtual environment (if created)
```

---

## 🚀 Quick Start

### Python Version

```bash
# 1. Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# 2. Install packages
pip install -r requirements.txt

# 3. Convert data
python3 scripts/python/convert_data.py

# 4. Run analysis
python3 scripts/python/detrend_analysis.py

# Outputs: output/python/plots/ and output/python/results/
```

### R Version

```bash
# 1. Install R packages (first time only)
Rscript scripts/r/install_packages.R

# 2. Convert data
Rscript scripts/r/convert_data.R

# 3. Run analysis
Rscript scripts/r/detrent.analysis.R

# Outputs: output/r/plots/ and output/r/results/
```

### Gretl Version

```bash
# Run the analysis script
./scripts/gretl/run.sh

# Verify outputs
./scripts/gretl/verify.sh

# Outputs: output/gretl/plots/ and output/gretl/results/
```

---

## 📋 Detailed Setup Instructions

### Python Setup

#### Step 1: Check Python Installation

```bash
python3 --version  # Should be 3.8 or higher
pip3 --version
```

#### Step 2: Create Virtual Environment (Recommended)

```bash
python3 -m venv venv
source venv/bin/activate  # On macOS/Linux
# venv\Scripts\activate   # On Windows
```

#### Step 3: Install Required Packages

```bash
# Install from requirements.txt
pip install -r requirements.txt

# Or install individually
pip install pandas numpy matplotlib scipy
```

**Required packages:**
- `pandas` - Data manipulation and CSV handling
- `numpy` - Numerical computations
- `matplotlib` - Plotting and visualization
- `scipy` - Statistical functions

#### Step 4: Run Python Scripts

```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Convert Gretl data to CSV
python3 scripts/python/convert_data.py

# Run detrending analysis
python3 scripts/python/detrend_analysis.py
```

---

### R Setup

#### Step 1: Install R

```bash
# On macOS with Homebrew
brew install r

# Verify installation
which R
R --version
```

#### Step 2: Install Required R Packages

```bash
# Run the installation script
Rscript scripts/r/install_packages.R

# Or install manually
Rscript -e "install.packages(c('XML', 'zoo', 'forecast'), repos='https://cran.rstudio.com/')"
```

**Required packages:**
- `XML` - For reading Gretl .gdt files
- `zoo` - Time series objects
- `forecast` - Forecasting functions

#### Step 3: Run R Scripts

```bash
# Convert Gretl data to CSV
Rscript scripts/r/convert_data.R

# Run detrending analysis
Rscript scripts/r/detrent.analysis.R
```

---

### Gretl Setup

#### Step 1: Install Gretl

```bash
# On macOS with Homebrew
brew install gretl

# Or download from: https://gretl.sourceforge.net/
```

Gretl is already installed if you see it in Applications.

#### Step 2: Run Gretl Script

```bash
# Run the analysis script
./scripts/gretl/run.sh

# Or manually:
/Applications/Gretl.app/Contents/Resources/bin/gretlcli -b scripts/gretl/detrend_analysis.inp

# Verify outputs
./scripts/gretl/verify.sh
```

**Note:** The script uses the native .gdt data format directly (no conversion needed).

**Outputs:** `output/gretl/plots/` and `output/gretl/results/`

---

## 📊 What Each Script Does

### Data Conversion (`convert_data.py` / `convert_data.R`)

- **Input:** `data/EconomicsUSA.gdt` (Gretl format)
- **Output:** `data/EconomicsUSA.csv` (CSV format)
- **Process:**
  - Parses XML structure of .gdt file
  - Extracts variable names and observations
  - Creates date column (monthly data from 1948-01)
  - Saves as CSV for analysis

**Note:** Gretl script uses the .gdt file directly (no conversion needed).

### Detrending Analysis (`detrend_analysis.py` / `detrent.analysis.R` / `detrend_analysis.inp`)

- **Input:** `data/EconomicsUSA.csv` (Python/R) or `data/EconomicsUSA.gdt` (Gretl)
- **Output:** 
  - Plots: Linear trend and moving average visualizations
  - Results: Forecast evaluation metrics CSV

**Methods:**
1. **Linear Trend Estimation**
   - Estimates trend equation: TT = α + β*t
   - Calculates trend line for each variable
   - Generates trend plots

2. **Moving Average (Order 4)**
   - Calculates 4-period moving average
   - Smooths time series data
   - Generates moving average plots

3. **Forecast Evaluation**
   - Calculates multiple metrics:
     - ME (Mean Error)
     - RMSE (Root Mean Squared Error)
     - MAE (Mean Absolute Error)
     - MPE (Mean Percentage Error)
     - MAPE (Mean Absolute Percentage Error)
     - Theil's U statistic
     - MSE Decomposition (UM, UR, UD)

---

## 📈 Output Files

### Python Outputs (`output/python/`)

**Plots:**
- `indpro_linear_trend.png` - Industrial Production linear trend
- `indpro_moving_average.png` - Industrial Production moving average
- `cpiaucsl_linear_trend.png` - CPI linear trend
- `cpiaucsl_moving_average.png` - CPI moving average

**Results:**
- `forecast_evaluation.csv` - All forecast metrics for both methods

### R Outputs (`output/r/`)

**Plots:**
- `indpro_linear_trend.png` - Industrial Production linear trend
- `indpro_moving_average.png` - Industrial Production moving average
- `cpiaucsl_linear_trend.png` - CPI linear trend
- `cpiaucsl_moving_average.png` - CPI moving average

**Results:**
- `forecast_evaluation.csv` - All forecast metrics for both methods

### Gretl Outputs (`output/gretl/`)

**Plots:**
- `indpro_linear_trend.png` - Industrial Production linear trend
- `indpro_moving_average.png` - Industrial Production moving average
- `cpiaucsl_linear_trend.png` - CPI linear trend
- `cpiaucsl_moving_average.png` - CPI moving average

**Results:**
- `forecast_evaluation.csv` - All forecast metrics for both methods

---

## 🔧 Troubleshooting

### Python Issues

**Problem:** `ModuleNotFoundError: No module named 'pandas'`
```bash
# Solution: Activate virtual environment and install
source venv/bin/activate
pip install -r requirements.txt
```

**Problem:** `python3: command not found`
```bash
# Solution: Install Python via Homebrew (macOS)
brew install python3
```

**Problem:** Permission errors when installing packages
```bash
# Solution: Use --user flag or virtual environment
pip install --user pandas
# OR
python3 -m venv venv && source venv/bin/activate
```

### R Issues

**Problem:** `R not found`
```bash
# Solution: Install R
brew install r
# Add to PATH if needed
export PATH="/opt/homebrew/bin:$PATH"
```

**Problem:** `there is no package called 'XML'`
```bash
# Solution: Install packages
Rscript -e "install.packages('XML', repos='https://cran.rstudio.com/')"
```

**Problem:** `zsh: event not found` (when running R code directly)
```bash
# Solution: Always use R script files (.R) instead of running code directly
# Or disable history expansion: set +H
```

---

## 📝 Understanding the Results

### Forecast Evaluation Metrics

- **ME (Mean Error):** Measures bias - closer to 0 is better
- **RMSE (Root Mean Squared Error):** Penalizes large errors - lower is better
- **MAE (Mean Absolute Error):** Average error magnitude - lower is better
- **MAPE (Mean Absolute Percentage Error):** Percentage error - easier to interpret
- **Theil's U:** Normalized accuracy - < 1 means better than naive forecast

### MSE Decomposition

- **UM (Bias Proportion):** Systematic over/under prediction
- **UR (Regression Proportion):** Different variation between actual and forecast
- **UD (Disturbance Proportion):** Unexplained randomness

---

## 🔄 Python vs R Comparison

| Feature | Python | R |
|---------|--------|---|
| **Data Reading** | `pd.read_csv()` | `read.csv()` |
| **Data Manipulation** | `pandas` | Base R / `dplyr` |
| **Plotting** | `matplotlib` | Base R graphics |
| **Statistics** | `scipy`, `numpy` | Base R / `stats` |
| **Time Series** | `pandas` | `zoo`, `forecast` |
| **Output Location** | `output/python/` | `output/r/` |

**Both produce identical results!** Choose based on your preference.

---

## 📚 Additional Resources

### Python Documentation
- See: `documentation/PYTHON_SETUP_GUIDE.md`
- Quick commands: `documentation/PYTHON_COMMANDS.md`

### R Documentation
- See: `documentation/SETUP_GUIDE.md`
- Quick commands: `documentation/COMMANDS_QUICK_REFERENCE.md`

---

## ✅ Verification

To verify both projects are working:

```bash
# Python
source venv/bin/activate
python3 scripts/python/detrend_analysis.py

# R
Rscript scripts/r/detrent.analysis.R

# Check outputs
ls output/python/plots/
ls output/r/plots/
```

Both should generate 4 plots each and 1 results CSV file.

---

## 🎯 Key Points

1. **Separate Projects:** Python and R are completely independent
2. **Separate Outputs:** Each language has its own output folder
3. **Same Data:** Both use the same input data (`data/EconomicsUSA.csv`)
4. **Same Methods:** Both implement identical detrending methods
5. **Same Results:** Both produce equivalent analysis results

---

**Last Updated:** December 2024  
**Project:** Time Series Detrending Analysis  
**Languages:** Python 3.8+ and R 4.0+

