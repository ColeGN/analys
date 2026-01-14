#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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
    echo "Error: gretlcli not found. Please install Gretl."
    exit 1
fi
mkdir -p "$PROJECT_ROOT/output/plots"
mkdir -p "$PROJECT_ROOT/output/results"

cd "$PROJECT_ROOT" || exit 1
"$GRETLCLI" -b "$PROJECT_ROOT/gretl/simple_timeseries.inp"

echo "Gretl analysis complete."
