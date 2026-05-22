# Lab1 Breathing LED — Makefile
# Supports: make sim / make synth / make fpga / make all / make clean

.PHONY: all sim synth fpga program clean

all: sim synth

sim:
	@echo "=== Running Simulation ==="
	bash sim/run.sh

synth:
	@echo "=== Running Synthesis ==="
	bash synth/run.sh

fpga:
	@echo "=== Running FPGA Implementation ==="
	@echo "Requires Vivado. Edit fpga/basys3.xdc with pin constraints first."
	/opt/Xilinx/Vivado/2019.2/bin/vivado -mode batch -source fpga/run.tcl

program:
	@echo "=== Programming Basys3 ==="
	@echo "Requires Basys3 board connected via USB."
	/opt/Xilinx/Vivado/2019.2/bin/vivado -mode batch -source fpga/program.tcl

clean:
	rm -f sim/tb.vvp sim/tb.vcd
	rm -f synth/breathing_led_synth.v synth/synth.log
	rm -rf fpga/build/
	@echo "Cleaned generated files."

# Quick check if tools are installed
check-tools:
	@echo "Checking EDA tools..."
	@which iverilog && echo "  [OK] iverilog" || echo "  [MISSING] iverilog"
	@which vvp && echo "  [OK] vvp" || echo "  [MISSING] vvp"
	@which gtkwave && echo "  [OK] gtkwave" || echo "  [MISSING] gtkwave"
	@which yosys && echo "  [OK] yosys" || echo "  [MISSING] yosys"
	@which vivado && echo "  [OK] vivado" || echo "  [MISSING] vivado"
