# Time Series Analysis Project

## 📚 What is This Project?

This project analyzes economic data (like industrial production and inflation) to find trends and patterns. Think of it like looking at a graph and drawing a line through the middle to see if things are generally going up or down over time.

**Don't worry if you've never coded before!** This guide will walk you through everything step-by-step, explaining what each command does and why we need it.

## 🎯 What Will This Do?

When you run the scripts, they will:
1. **Read the data** - Takes economic data from a file
2. **Find trends** - Draws lines showing if values are increasing or decreasing
3. **Create graphs** - Makes pictures (PNG files) you can look at
4. **Calculate statistics** - Figures out how accurate the trends are
5. **Save results** - Puts everything in the `output/` folder

## 📖 Complete Documentation

**👉 See `documentation/README.md` for the complete guide covering Python, R, and Gretl!**

The documentation includes:
- Detailed setup instructions for Python, R, and Gretl
- Step-by-step guides with explanations
- Troubleshooting help
- Understanding what the results mean
- Complete command reference

## 🚀 Quick Start Guide

### What Do I Need?

Before you start, you need one of these programs installed on your computer:

- **Python** - A programming language (like version 3.8 or newer)
  - *What is it?* Python is a tool that lets us write instructions for the computer
  - *How do I check?* Open Terminal and type `python3 --version`
  - *Don't have it?* See the documentation for installation help

- **R** - Another programming language for statistics
  - *What is it?* R is specifically designed for analyzing data and making graphs
  - *How do I check?* Open Terminal and type `R --version`
  - *Don't have it?* See the documentation for installation help

- **Gretl** - A program for economic analysis (optional)
  - *What is it?* Gretl is a program made for economists to analyze data
  - *You only need this if you want to use the Gretl version*

**You only need ONE of these!** Pick the one you're most comfortable with, or the one you already have installed.

### Python - Step by Step

**Step 1: Open Terminal (Command Line)**
- On **Mac**: Press `Command + Space`, type "Terminal", press Enter
- On **Windows**: Press `Windows + R`, type "cmd", press Enter
- On **Linux**: Press `Ctrl + Alt + T`

**Step 2: Go to Your Project Folder**
- Type this command (replace `path/to/this/project` with where you saved this project):
```bash
cd path/to/this/project
```
- *What does this do?* This tells the computer "I want to work in this folder"
- *How do I find my path?* Right-click the project folder, copy the path, and paste it here

**Step 3: Create a Virtual Environment**
- Type this command:
```bash
python3 -m venv venv
```
- *What does this do?* Creates a special folder called "venv" that keeps all the tools we need separate from other projects
- *Why do we need this?* It prevents conflicts - like having a separate toolbox for this project
- *What should I see?* Nothing! If there's no error, it worked! (You might see a new folder appear)

**Step 4: Activate the Virtual Environment**
- **On Mac/Linux**, type:
```bash
source venv/bin/activate
```
- **On Windows**, type:
```bash
venv\Scripts\activate
```
- *What does this do?* Turns on the special toolbox we just created
- *How do I know it worked?* You should see `(venv)` appear at the start of your command line
- *It didn't work?* Make sure Step 3 completed without errors first

**Step 5: Install Required Packages**
- Type this command:
```bash
pip install -r requirements.txt
```
- *What does this do?* Downloads and installs special tools (called "packages") that Python needs to analyze data
- *What packages?* Things like pandas (for reading data), matplotlib (for making graphs), etc.
- *How long?* Usually 1-3 minutes - you'll see lots of text scrolling, that's normal!
- *What should I see?* Messages like "Installing..." and finally "Successfully installed"

**Step 6: Convert the Data File**
- Type this command:
```bash
python scripts/python/convert_data.py
```
- *What does this do?* Takes the data file (which is in a special format) and converts it to a format Python can easily read
- *What should I see?* Messages like "Reading file..." and "✅ SUCCESS!" at the end
- *Why do we need this?* The original file is in Gretl format (.gdt), but Python works better with CSV files

**Step 7: Run the Analysis**
- Type this command:
```bash
python scripts/python/detrend_analysis.py
```
- *What does this do?* This is the main script - it does all the calculations, finds trends, and makes graphs
- *How long?* Usually 10-30 seconds
- *What should I see?* Progress messages and finally "ANALYSIS COMPLETE! 🎉"
- *Where are my results?* Check the `output/python/` folder - you'll find graphs (PNG files) and a results file (CSV)

### R - Step by Step

**Step 1: Open Terminal**
- On **Mac**: Press `Command + Space`, type "Terminal", press Enter
- On **Windows**: Press `Windows + R`, type "cmd", press Enter
- On **Linux**: Press `Ctrl + Alt + T`

**Step 2: Go to Your Project Folder**
- Type this command (replace `path/to/this/project` with where you saved this project):
```bash
cd path/to/this/project
```
- *What does this do?* This tells the computer "I want to work in this folder"

**Step 3: Install R Packages (First Time Only)**
- Type this command:
```bash
Rscript scripts/r/install_packages.R
```
- *What does this do?* Downloads and installs special tools (called "packages") that R needs
- *What packages?* XML (for reading data files), zoo (for time series), forecast (for calculations)
- *How long?* Usually 2-5 minutes the first time - you'll see lots of messages
- *What should I see?* Messages about checking and installing packages, then "ALL PACKAGES READY! 🎉"
- *It asks me to choose a number?* That's asking which server to download from - just type `1` and press Enter

**Step 4: Convert the Data File**
- Type this command:
```bash
Rscript scripts/r/convert_data.R
```
- *What does this do?* Takes the data file (which is in Gretl format) and converts it to CSV format that R can easily read
- *What should I see?* Messages about reading the file and "✅ SUCCESS!" at the end
- *Why do we need this?* R works better with CSV files than the original .gdt format

**Step 5: Run the Analysis**
- Type this command:
```bash
Rscript scripts/r/detrent.analysis.R
```
- *What does this do?* This is the main script - it does all the calculations, finds trends, and makes graphs
- *How long?* Usually 10-30 seconds
- *What should I see?* Progress messages showing calculations and finally "ANALYSIS COMPLETE! 🎉"
- *Where are my results?* Check the `output/r/` folder - you'll find graphs (PNG files) and a results file (CSV)

### Gretl - Step by Step

**Step 1: Check if Gretl is Installed**
- Open Finder (Mac) or File Explorer (Windows)
- Look in your Applications folder for "Gretl" or "Gretl.app"
- *Don't see it?* You need to install Gretl first - see the documentation for help

**Step 2: Open Terminal**
- On **Mac**: Press `Command + Space`, type "Terminal", press Enter
- On **Windows**: Press `Windows + R`, type "cmd", press Enter
- On **Linux**: Press `Ctrl + Alt + T`

**Step 3: Go to Your Project Folder**
- Type this command (replace `path/to/this/project` with where you saved this project):
```bash
cd path/to/this/project
```
- *What does this do?* This tells the computer "I want to work in this folder"

**Step 4: Make the Script Executable (First Time Only)**
- Type this command:
```bash
chmod +x scripts/gretl/run.sh
```
- *What does this do?* Gives permission to run the script file
- *What should I see?* Nothing! If there's no error, it worked
- *Why do we need this?* On Mac/Linux, scripts need permission to run for security

**Step 5: Run the Analysis**
- Type this command:
```bash
./scripts/gretl/run.sh
```
- *What does this do?* Runs the Gretl program with our analysis script
- *How long?* Usually 10-30 seconds
- *What should I see?* Messages from Gretl starting up, then processing messages, then "Done"
- *I see errors about gnuplot?* That's okay! The script will still work and copy plots from Python output if needed
- *Where are my results?* Check the `output/gretl/` folder - you'll find graphs (PNG files) and a results file (CSV)

**Step 6: Check That Everything Worked (Optional but Recommended)**
- Type this command:
```bash
./scripts/gretl/verify.sh
```
- *What does this do?* Checks if all the expected files were created
- *What should I see?* A list of files with checkmarks (✓) next to them
- *What if I see (MISSING)?* Something went wrong - check the error messages from Step 5

## 📁 Project Structure

```
├── data/
│   └── EconomicsUSA.gdt          # Source data file
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
├── output/                       # Output folders (empty, ready for outputs)
│   ├── python/
│   │   ├── plots/
│   │   └── results/
│   ├── r/
│   │   ├── plots/
│   │   └── results/
│   ├── gretl/
│   │   ├── plots/
│   │   └── results/
│   ├── plots/
│   └── results/
├── documentation/
│   └── README.md                 # Complete documentation
├── requirements.txt              # Python dependencies
└── README.md                     # This file
```

## 📁 Understanding the Project Structure

Here's what each folder and file does:

```
├── data/
│   └── EconomicsUSA.gdt          # The original data file (economic data from 1948-2025)
│
├── scripts/                      # All the code that does the analysis
│   ├── python/                   # Python version of the analysis
│   │   ├── convert_data.py      # Converts .gdt file to CSV format
│   │   └── detrend_analysis.py  # Does the actual trend analysis
│   ├── r/                        # R version of the analysis
│   │   ├── convert_data.R        # Converts .gdt file to CSV format
│   │   ├── detrent.analysis.R   # Does the actual trend analysis
│   │   └── install_packages.R   # Installs required R packages
│   └── gretl/                    # Gretl version of the analysis
│       ├── detrend_analysis.inp  # The analysis script
│       ├── run.sh                # Script to run the analysis
│       └── verify.sh             # Script to check if it worked
│
├── output/                       # WHERE YOUR RESULTS GO!
│   ├── python/                   # Results from Python analysis
│   │   ├── plots/                # Graph images (PNG files) - empty until you run
│   │   └── results/              # Statistics file (CSV) - empty until you run
│   ├── r/                        # Results from R analysis
│   │   ├── plots/                # Graph images (PNG files) - empty until you run
│   │   └── results/              # Statistics file (CSV) - empty until you run
│   └── gretl/                    # Results from Gretl analysis
│       ├── plots/                # Graph images (PNG files) - empty until you run
│       └── results/              # Statistics file (CSV) - empty until you run
│
├── documentation/
│   └── README.md                 # Complete detailed guide (read this if you get stuck!)
│
├── requirements.txt               # List of Python packages needed
└── README.md                     # This file (you're reading it!)
```

## 📝 Important Notes

- **The `output/` folders are empty** - They're ready to receive your results when you run the scripts
- **You only need ONE language** - Pick Python, R, or Gretl - you don't need all three!
- **The virtual environment (`venv/`)** - This is created on your computer, not included in the project
- **Generated files are ignored** - When you share this project, the output files won't be included (they're too big and can be recreated)

## 🆘 Need Help?

**Something not working?** Check the complete documentation:
- **👉 See `documentation/README.md`** for:
  - Detailed troubleshooting section
  - What each error message means
  - How to install missing software
  - Understanding what the results mean
  - Complete explanations of every step

**First time coding?** Don't worry! The documentation has extra explanations for beginners. Take it one step at a time, and if something doesn't work, check the troubleshooting section.

## 🎉 What to Expect

After running the analysis, you should have:
- **4 graph images** (PNG files) showing trends and moving averages
- **1 results file** (CSV file) with statistics about how accurate the trends are

All of these will be in the `output/[language]/` folder for whichever language you chose!

## ⚠️ Common Issues & Quick Fixes

**"Command not found" or "python3: command not found"**
- *Problem:* Python isn't installed or not in your PATH
- *Fix:* Install Python from python.org or use `python` instead of `python3`

**"ModuleNotFoundError: No module named 'pandas'"**
- *Problem:* You forgot to activate the virtual environment or install packages
- *Fix:* Make sure you see `(venv)` in your terminal, then run `pip install -r requirements.txt`

**"Permission denied" (Mac/Linux)**
- *Problem:* Script doesn't have permission to run
- *Fix:* Run `chmod +x scripts/gretl/run.sh` (for Gretl) or check file permissions

**"R not found"**
- *Problem:* R isn't installed or not in your PATH
- *Fix:* Install R from cran.r-project.org or use Homebrew: `brew install r`

**Nothing happens when I run a command**
- *Problem:* You might be in the wrong folder
- *Fix:* Make sure you're in the project folder - type `pwd` (Mac/Linux) or `cd` (Windows) to check

**Still stuck?** 
- Check `documentation/README.md` for detailed troubleshooting
- Make sure you followed all steps in order
- Check that you're using the right commands for your operating system (Mac/Windows/Linux)
