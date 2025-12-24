# Time Series Analysis Project

This project contains **Python**, **R**, and **Gretl** implementations for time series detrending analysis.

## 📖 Complete Documentation

**👉 See `documentation/README.md` for the complete guide covering Python, R, and Gretl!**

The documentation includes:
- Detailed setup instructions for Python, R, and Gretl
- Step-by-step guides
- Troubleshooting
- Understanding results
- Complete command reference

## Quick Start

### Python
```bash
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python3 scripts/python/convert_data.py
python3 scripts/python/detrend_analysis.py
```

### R
```bash
Rscript scripts/r/install_packages.R
Rscript scripts/r/convert_data.R
Rscript scripts/r/detrent.analysis.R
```

### Gretl
```bash
./scripts/gretl/run.sh
```

## Project Structure

```
├── data/              # Shared data files
├── scripts/
│   ├── python/       # Python scripts
│   ├── r/            # R scripts
│   └── gretl/        # Gretl scripts
├── output/
│   ├── python/       # Python outputs
│   ├── r/           # R outputs
│   └── gretl/       # Gretl outputs
└── documentation/    # Complete documentation
```

**For full documentation, see: `documentation/README.md`**
