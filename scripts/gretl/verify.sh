#!/bin/bash

echo "Checking Gretl script output..."
echo ""

PLOTS_DIR="output/gretl/plots"
RESULTS_DIR="output/gretl/results"

echo "Checking for plots in $PLOTS_DIR:"
expected_plots=("indpro_linear_trend.png" "indpro_moving_average.png" "cpiaucsl_linear_trend.png" "cpiaucsl_moving_average.png")
missing_plots=0
for plot in "${expected_plots[@]}"; do
    if [ -f "$PLOTS_DIR/$plot" ]; then
        size=$(stat -f%z "$PLOTS_DIR/$plot" 2>/dev/null || stat -c%s "$PLOTS_DIR/$plot" 2>/dev/null)
        echo "  ✓ $plot ($(numfmt --to=iec-i --suffix=B $size 2>/dev/null || echo "$size bytes"))"
    else
        echo "  ✗ $plot (MISSING)"
        missing_plots=$((missing_plots + 1))
    fi
done

echo ""
echo "Checking for results in $RESULTS_DIR:"
if [ -f "$RESULTS_DIR/forecast_evaluation.csv" ]; then
    echo "  ✓ forecast_evaluation.csv"
    echo ""
    echo "First few lines of results:"
    head -5 "$RESULTS_DIR/forecast_evaluation.csv"
    echo ""
    line_count=$(wc -l < "$RESULTS_DIR/forecast_evaluation.csv")
    echo "Total lines: $line_count (should be 5: header + 4 models)"
else
    echo "  ✗ forecast_evaluation.csv (MISSING)"
fi

echo ""
if [ $missing_plots -eq 0 ] && [ -f "$RESULTS_DIR/forecast_evaluation.csv" ]; then
    echo "✅ All outputs found! Script appears to be working."
else
    echo "⚠️  Some outputs are missing. Run the Gretl script first."
    echo ""
    echo "To run:"
    echo "  gretlcli -b scripts/gretl/detrend_analysis.inp"
fi

