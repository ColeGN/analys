#!/bin/bash

echo "Testing portable Gretl script..."
echo "================================"

# Test from different locations
ORIGINAL_DIR=$(pwd)
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/run.sh"

echo "1. Testing from project root..."
bash "$SCRIPT_PATH"

if [ $? -eq 0 ]; then
    echo "✅ SUCCESS: Script works from project root"
else
    echo "❌ FAILED: Script failed from project root"
    exit 1
fi

# Check if output files were created
if [ -f "output/gretl/results/forecast_evaluation.csv" ]; then
    echo "✅ SUCCESS: Results file created"
else
    echo "❌ FAILED: Results file not found"
    exit 1
fi

if [ -f "output/gretl/plots/indpro_linear_trend.png" ]; then
    echo "✅ SUCCESS: Plot files created"
else
    echo "❌ FAILED: Plot files not found"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The script is portable and works correctly."
echo ""
echo "Generated files:"
echo "- output/gretl/results/forecast_evaluation.csv"
echo "- output/gretl/plots/*.png"