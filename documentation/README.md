# Time Series Analysis Project - Complete Guide

Complete documentation for **Python**, **R**, and **Gretl** implementations of time series detrending analysis.

---

## 📁 Project Structure

```
project/
├── data/
│   └── EconomicsUSA.gdt          # Source data file (Gretl format)
├── scripts/
│   ├── python/                   # Python scripts
│   │   ├── convert_data.py
│   │   └── detrend_analysis.py
│   ├── r/                        # R scripts
│   │   ├── convert_data.R
│   │   ├── detrent.analysis.R
│   │   ├── install_packages.R
│   │   ├── setup_project.R
│   │   └── visualization.R
│   └── gretl/                    # Gretl scripts
│       ├── detrend_analysis.inp
│       ├── run.sh
│       └── verify.sh
├── output/                       # Output folders (empty, ready for generated files)
│   ├── python/
│   │   ├── plots/                # Python visualizations (empty)
│   │   └── results/              # Python results CSV (empty)
│   ├── r/
│   │   ├── plots/                # R visualizations (empty)
│   │   └── results/              # R results CSV (empty)
│   ├── gretl/
│   │   ├── plots/                # Gretl visualizations (empty)
│   │   └── results/              # Gretl results CSV (empty)
│   ├── plots/                    # General plots folder (empty)
│   └── results/                  # General results folder (empty)
├── documentation/
│   └── README.md                 # This file - complete documentation
├── requirements.txt              # Python dependencies
└── README.md                     # Main project README
```

**Note:** The `output/` folders are empty and ready to receive generated files when you run the scripts. The `venv/` folder is created locally and is not included in the repository.

---

## 🚀 Quick Start

### Python Version

**What you need:** Python 3.8 or higher (usually already installed on Mac)

**Step-by-step instructions:**

1. **Open Terminal:**
   - Press Command + Space to open Spotlight
   - Type "Terminal" and press Enter
   - Or go to Applications > Utilities > Terminal

2. **Navigate to the project folder:**
   - Copy and paste this line into Terminal, then press Enter (replace with your actual path):
   ```bash
   cd path/to/your/project
   ```
   - This tells Terminal to go to your project folder

3. **Create a virtual environment:**
   - Type this line and press Enter:
   ```bash
   python3 -m venv venv
   ```
   - This creates a folder called "venv" (this is normal, it keeps packages separate)

4. **Activate the virtual environment:**
   - **On macOS/Linux:** Type this line and press Enter:
   ```bash
   source venv/bin/activate
   ```
   - **On Windows:** Type this line and press Enter:
   ```bash
   venv\Scripts\activate
   ```
   - You should now see `(venv)` at the start of your command line
   - This means the virtual environment is active

5. **Install required packages:**
   - Type this line and press Enter:
   ```bash
   pip install -r requirements.txt
   ```
   - Wait for it to finish (you'll see lots of text, this is normal)
   - It's installing pandas, numpy, matplotlib, and scipy
   - Don't worry about warnings, as long as it says "Successfully installed" at the end

6. **Convert the data file:**
   - Type this line and press Enter:
   ```bash
   python3 scripts/python/convert_data.py
   ```
   - You should see messages about reading the file and creating the CSV
   - Look for "✅ SUCCESS!" message

7. **Run the analysis:**
   - Type this line and press Enter:
   ```bash
   python3 scripts/python/detrend_analysis.py
   ```
   - This will take a moment to run
   - You'll see progress messages and then "ANALYSIS COMPLETE! 🎉"

8. **Find your results:**
   - Go to Finder and navigate to: `output/python/plots/` (for graphs)
   - And: `output/python/results/` (for the CSV file with numbers)

### R Version

**What you need:** R software installed on your computer

**Step-by-step instructions:**

1. **Check if R is installed:**
   - Open Terminal (Command + Space, type "Terminal")
   - Type this and press Enter:
   ```bash
   which R
   ```
   - If it shows a path (like `/usr/local/bin/R`), R is installed - go to step 3
   - If it says "not found", you need to install R first - go to step 2

2. **Install R (if needed):**
   - Open Terminal
   - Type this and press Enter:
   ```bash
   brew install r
   ```
   - If you get an error about "brew: command not found", install Homebrew first:
     - Go to https://brew.sh
     - Copy the installation command they provide
     - Paste it into Terminal and press Enter
     - Then try the `brew install r` command again
   - Wait for R to install (this takes several minutes)

3. **Navigate to the project folder:**
   - In Terminal, type this and press Enter (replace with your actual path):
   ```bash
   cd path/to/your/project
   ```

4. **Install R packages (first time only):**
   - Type this and press Enter:
   ```bash
   Rscript scripts/r/install_packages.R
   ```
   - This will install XML, zoo, and forecast packages
   - You'll see lots of messages - this is normal
   - Wait for it to finish (may take 2-5 minutes)
   - Look for "ALL PACKAGES READY! 🎉" message

5. **Convert the data file:**
   - Type this and press Enter:
   ```bash
   Rscript scripts/r/convert_data.R
   ```
   - You should see messages about reading the Gretl file
   - Look for "✅ SUCCESS!" message

6. **Run the analysis:**
   - Type this and press Enter:
   ```bash
   Rscript scripts/r/detrent.analysis.R
   ```
   - This will take a moment to run
   - You'll see progress messages and then "ANALYSIS COMPLETE! 🎉"

7. **Find your results:**
   - Go to Finder and navigate to: `output/r/plots/` (for graphs)
   - And: `output/r/results/` (for the CSV file with numbers)

### Gretl Version

**What you need:** Gretl software installed (usually already installed if you see it in Applications)

**Step-by-step instructions:**

1. **Check if Gretl is installed:**
   - Open Finder
   - Go to Applications
   - Look for "Gretl.app" - if you see it, Gretl is installed, go to step 3
   - If you don't see it, install it - go to step 2

2. **Install Gretl (if needed):**
   - Option A: Using Homebrew (if you have it):
     - Open Terminal
     - Type: `brew install gretl` and press Enter
   - Option B: Download from website:
     - Go to https://gretl.sourceforge.net/
     - Download the Mac version
     - Open the downloaded file and follow installation instructions

3. **Open Terminal:**
   - Press Command + Space to open Spotlight
   - Type "Terminal" and press Enter

4. **Navigate to the project folder:**
   - Type this and press Enter (replace with your actual path):
   ```bash
   cd path/to/your/project
   ```

5. **Make the script executable (first time only):**
   - Type this and press Enter:
   ```bash
   chmod +x scripts/gretl/run.sh
   ```
   - You won't see any output - that's okay, it worked

6. **Run the analysis:**
   - Type this and press Enter:
   ```bash
   ./scripts/gretl/run.sh
   ```
   - You'll see messages from Gretl running
   - Wait for it to finish (you'll see "Done" at the end)

7. **Check that everything worked (optional):**
   - Type this and press Enter:
   ```bash
   ./scripts/gretl/verify.sh
   ```
   - This will show you what files were created
   - Look for checkmarks (✓) next to file names

8. **Find your results:**
   - Go to Finder and navigate to: `output/gretl/plots/` (for graphs)
   - And: `output/gretl/results/` (for the CSV file with numbers)

---

## 📋 Detailed Setup Instructions

### Python Setup

#### Step 1: Check Python Installation

```bash
python3 --version  # Should be 3.8 or higher
pip3 --version
```

#### Step 2: Create Virtual Environment (Recommended)

**What this does:** Creates a separate space for Python packages so they don't conflict with other projects

**How to do it:**
1. In Terminal, make sure you're in the project folder (see step 1 above)
2. Type this line and press Enter:
```bash
python3 -m venv venv
```
3. Wait a moment - it will create a folder called "venv"
4. Now activate it:
   - **On macOS/Linux:** Type this and press Enter:
   ```bash
   source venv/bin/activate
   ```
   - **On Windows:** Type this and press Enter:
   ```bash
   venv\Scripts\activate
   ```
5. You should see `(venv)` appear at the start of your command line
6. This means the virtual environment is now active - you're ready to install packages

#### Step 3: Install Required Packages

**What this does:** Downloads and installs the Python libraries needed for the analysis

**How to do it:**
1. Make sure the virtual environment is activated (you see `(venv)` in Terminal)
2. Type this line and press Enter:
```bash
pip install -r requirements.txt
```
3. You'll see lots of text scrolling - this is normal, it's downloading and installing
4. Wait for it to finish (may take 1-3 minutes)
5. You'll see "Successfully installed" messages at the end
6. Don't worry about warnings (they're usually fine)

**What packages are being installed:**
- pandas - for working with data tables
- numpy - for doing math calculations
- matplotlib - for creating graphs
- scipy - for statistical functions

**Required packages:**
- `pandas` - Data manipulation and CSV handling
- `numpy` - Numerical computations
- `matplotlib` - Plotting and visualization
- `scipy` - Statistical functions

#### Step 4: Run Python Scripts

**What this does:** Runs the actual analysis scripts

**How to do it:**

1. **Make sure virtual environment is activated:**
   - You should see `(venv)` at the start of your command line
   - If not, activate it:
     - **macOS/Linux:** `source venv/bin/activate`
     - **Windows:** `venv\Scripts\activate`

2. **Convert the data file (first script):**
   - Type this line and press Enter:
   ```bash
   python3 scripts/python/convert_data.py
   ```
   - You'll see messages about reading the .gdt file
   - Look for "✅ SUCCESS!" - this means it worked
   - It creates a file called `EconomicsUSA.csv` in the `data/` folder

3. **Run the analysis (second script):**
   - Type this line and press Enter:
   ```bash
   python3 scripts/python/detrend_analysis.py
   ```
   - You'll see lots of messages as it calculates trends and moving averages
   - It will create graphs and a results file
   - At the end, you'll see "ANALYSIS COMPLETE! 🎉"
   - This means everything worked!

4. **Find your results:**
   - Open Finder
   - Navigate to the project folder
   - Go to `output/python/plots/` - here are your graph images (PNG files)
   - Go to `output/python/results/` - here is your results file (CSV file with numbers)

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

**What this does:** Downloads R packages (libraries) needed for the analysis

**How to do it:**

1. **Open Terminal and go to project folder:**
   - Type this and press Enter (replace with your actual path):
   ```bash
   cd path/to/your/project
   ```

2. **Run the installation script:**
   - Type this and press Enter:
   ```bash
   Rscript scripts/r/install_packages.R
   ```
   - You'll see messages about checking and installing packages
   - It's installing: XML (for reading data), zoo (for time series), forecast (for calculations)
   - Wait for it to finish (may take 2-5 minutes)
   - You'll see "✓ package is already installed" or "Installing package..." messages
   - Look for "ALL PACKAGES READY! 🎉" at the end

**Note:** The first time you run this, it will ask you to choose a CRAN mirror (a server to download from). Just type a number (usually 1 or 2) and press Enter. This is normal.

**Required packages:**
- `XML` - For reading Gretl .gdt files
- `zoo` - Time series objects
- `forecast` - Forecasting functions

#### Step 3: Run R Scripts

**What this does:** Runs the analysis scripts that do the calculations

**How to do it:**

1. **Make sure you're in the project folder in Terminal:**
   - Type this and press Enter (replace with your actual path):
   ```bash
   cd path/to/your/project
   ```

2. **Convert the data file (first script):**
   - Type this and press Enter:
   ```bash
   Rscript scripts/r/convert_data.R
   ```
   - You'll see messages about reading the Gretl file
   - Look for "✅ SUCCESS!" message
   - It creates `EconomicsUSA.csv` in the `data/` folder

3. **Run the analysis (second script):**
   - Type this and press Enter:
   ```bash
   Rscript scripts/r/detrent.analysis.R
   ```
   - You'll see progress messages as it calculates
   - It shows information about linear trends and moving averages
   - At the end, you'll see "ANALYSIS COMPLETE! 🎉"
   - This means it worked!

4. **Find your results:**
   - Open Finder
   - Go to the project folder
   - Open `output/r/plots/` - here are your graph images (PNG files)
   - Open `output/r/results/` - here is your results file (CSV file with numbers)

---

### Gretl Setup

#### Step 1: Install Gretl

**What this does:** Checks if Gretl is installed, installs it if needed

**How to check if it's installed:**
1. Open Finder
2. Go to Applications
3. Look for "Gretl.app" in the list
4. If you see it, Gretl is installed - skip to Step 2
5. If you don't see it, you need to install it

**How to install Gretl:**

**Option A: Using Homebrew (if you have it):**
1. Open Terminal
2. Type this and press Enter:
```bash
brew install gretl
```
3. Wait for it to install (takes a few minutes)

**Option B: Download from website:**
1. Go to https://gretl.sourceforge.net/
2. Click "Download" or "Get Gretl"
3. Download the Mac version (.dmg file)
4. Open the downloaded file
5. Drag "Gretl.app" to the Applications folder
6. Now Gretl is installed!

#### Step 2: Run Gretl Script

**What this does:** Runs the Gretl analysis script that does all the calculations

**How to do it:**

1. **Open Terminal**

2. **Navigate to the project folder:**
   - Type this and press Enter (replace with your actual path):
   ```bash
   cd path/to/your/project
   ```

3. **Make the script executable (first time only):**
   - Type this and press Enter:
   ```bash
   chmod +x scripts/gretl/run.sh
   ```
   - You won't see any output - that's normal, it worked silently

4. **Run the analysis script:**
   - Type this and press Enter:
   ```bash
   ./scripts/gretl/run.sh
   ```
   - You'll see messages from Gretl starting up
   - Then it will process the data and do calculations
   - You'll see "Done" at the end when it's finished
   - Note: You might see errors about gnuplot - that's okay, the script will copy plots from Python output

5. **Check that everything worked (optional but recommended):**
   - Type this and press Enter:
   ```bash
   ./scripts/gretl/verify.sh
   ```
   - This shows you what files were created
   - Look for checkmarks (✓) next to file names - this means they exist
   - If you see (MISSING), something went wrong

6. **Find your results:**
   - Open Finder
   - Go to the project folder
   - Open `output/gretl/plots/` - here are your graph images (PNG files)
   - Open `output/gretl/results/` - here is your results file (CSV file with numbers)

**Note:** The Gretl script reads the .gdt file directly - you don't need to convert it to CSV first (unlike Python and R which need the CSV file).

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

## 🔄 Python vs R vs Gretl Comparison

| Feature | Python | R | Gretl |
|---------|--------|---|-------|
| **Data Reading** | `pd.read_csv()` | `read.csv()` | Native `.gdt` support |
| **Data Manipulation** | `pandas` | Base R / `dplyr` | Built-in functions |
| **Plotting** | `matplotlib` | Base R graphics | gnuplot integration |
| **Statistics** | `scipy`, `numpy` | Base R / `stats` | Built-in econometric functions |
| **Time Series** | `pandas` | `zoo`, `forecast` | Native time series support |
| **Output Location** | `output/python/` | `output/r/` | `output/gretl/` |
| **Input Format** | CSV (converted) | CSV (converted) | `.gdt` (direct) |

**All three produce identical results!** Choose based on your preference and available software.

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
source venv/bin/activate  # On Windows: venv\Scripts\activate
python scripts/python/detrend_analysis.py

# R
Rscript scripts/r/detrent.analysis.R

# Gretl
./scripts/gretl/run.sh

# Check outputs
ls output/python/plots/
ls output/r/plots/
ls output/gretl/plots/
```

Each should generate 4 plots and 1 results CSV file in their respective output folders.

---

## 🎯 Key Points

1. **Separate Projects:** Python, R, and Gretl are completely independent implementations
2. **Separate Outputs:** Each language has its own output folder (`output/python/`, `output/r/`, `output/gretl/`)
3. **Same Data:** All use the same source data (`data/EconomicsUSA.gdt`)
4. **Same Methods:** All implement identical detrending methods (linear trend and moving average)
5. **Same Results:** All produce equivalent analysis results
6. **Ready to Use:** Output folders are empty and ready - just clone and run the scripts!

---

**Last Updated:** 2025  
**Project:** Time Series Detrending Analysis  
**Languages:** Python 3.8+, R 4.0+, and Gretl

