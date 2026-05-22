#!/bin/bash
set -e

# Get absolute path of script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LAB_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Lab1 Breathing LED Simulation ==="
echo ""

# Clean old artifacts
cd "$LAB_DIR"
rm -f sim/tb.vvp sim/tb.vcd

# Compile RTL + testbench
echo "[1/3] Compiling Verilog sources..."
iverilog -o sim/tb.vvp \
    rtl/breathing_led.v \
    tb/tb_breathing_led.v

echo "[2/3] Running simulation..."
cd "$SCRIPT_DIR"
vvp tb.vvp

echo "[3/3] Opening GTKWave..."
if command -v gtkwave > /dev/null 2>&1; then
    gtkwave sim/tb.vcd &
    echo "GTKWave launched. Look for 'pwm_out' and 'duty' signals."
else
    echo "WARNING: gtkwave not found. Waveform saved to sim/tb.vcd"
    echo "Install with: sudo apt install gtkwave"
fi

echo ""
echo "=== Simulation Complete ==="
echo "  Waveform: sim/tb.vcd"
echo "  To reopen: gtkwave sim/tb.vcd"
