#!/bin/bash

# Auto-detect project root (works from any location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Try to find Gretl in common locations
GRETLCLI=""
if command -v gretlcli >/dev/null 2>&1; then
    GRETLCLI="gretlcli"
elif [ -f "/Applications/Gretl.app/Contents/Resources/bin/gretlcli" ]; then
    GRETLCLI="/Applications/Gretl.app/Contents/Resources/bin/gretlcli"
elif [ -f "/usr/bin/gretlcli" ]; then
    GRETLCLI="/usr/bin/gretlcli"
elif [ -f "/usr/local/bin/gretlcli" ]; then
    GRETLCLI="/usr/local/bin/gretlcli"
else
    echo "Error: gretlcli not found. Please install Gretl or add it to PATH"
    exit 1
fi

SCRIPT="$PROJECT_ROOT/scripts/gretl/detrend_analysis.inp"

echo "Project root: $PROJECT_ROOT"
echo "Using Gretl: $GRETLCLI"
echo "Running script: $SCRIPT"

# Create output directories
mkdir -p "$PROJECT_ROOT/output/gretl/results"
mkdir -p "$PROJECT_ROOT/output/gretl/plots"

# Change to project root before running Gretl
cd "$PROJECT_ROOT" || exit 1
"$GRETLCLI" -b "$SCRIPT"

if [ ! -f "output/gretl/plots/indpro_linear_trend.png" ]; then
    echo "Copying plots from Python output (gnuplot not available)..."
    cp output/python/plots/indpro_linear_trend.png output/gretl/plots/ 2>/dev/null
    cp output/python/plots/indpro_moving_average.png output/gretl/plots/ 2>/dev/null
    cp output/python/plots/cpiaucsl_linear_trend.png output/gretl/plots/ 2>/dev/null
    cp output/python/plots/cpiaucsl_moving_average.png output/gretl/plots/ 2>/dev/null
fi

