#!/bin/bash
set -e

# Get absolute path of script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LAB_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Lab1 Breathing LED Synthesis ==="
echo ""

# Clean old artifacts
cd "$LAB_DIR"
rm -f synth/breathing_led_synth.v synth/synth.log

# Yosys synthesis
echo "[1/2] Running Yosys synthesis..."
yosys -p "
    read_verilog rtl/breathing_led.v;
    hierarchy -top breathing_led;
    proc;
    opt;
    techmap;
    opt;
    write_verilog synth/breathing_led_synth.v;
    stat;
" > synth/synth.log 2>&1

echo "[2/2] Synthesis complete."
echo ""
echo "  Netlist:    synth/breathing_led_synth.v"
echo "  Log:        synth/synth.log"
echo "  Stats:      grep -A20 '=== breathing_led ===' synth/synth.log"
echo ""
echo "=== Synthesis Complete ==="
echo ""
echo "To inspect the netlist:"
echo "  less synth/breathing_led_synth.v"
echo "  grep 'DFF' synth/breathing_led_synth.v"
