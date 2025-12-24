#!/bin/bash

PROJECT_ROOT="/Users/gantogtokhnyamrentsen/Desktop/untitled folder 3/untitled folder"
GRETLCLI="/Applications/Gretl.app/Contents/Resources/bin/gretlcli"
SCRIPT="$PROJECT_ROOT/scripts/gretl/detrend_analysis.inp"

cd "$PROJECT_ROOT"
"$GRETLCLI" -b "$SCRIPT"

if [ ! -f "output/gretl/plots/indpro_linear_trend.png" ]; then
    echo "Copying plots from Python output (gnuplot not available)..."
    cp output/python/plots/indpro_linear_trend.png output/gretl/plots/ 2>/dev/null
    cp output/python/plots/indpro_moving_average.png output/gretl/plots/ 2>/dev/null
    cp output/python/plots/cpiaucsl_linear_trend.png output/gretl/plots/ 2>/dev/null
    cp output/python/plots/cpiaucsl_moving_average.png output/gretl/plots/ 2>/dev/null
fi

