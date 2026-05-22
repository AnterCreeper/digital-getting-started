# Lab 1: Breathing LED — PWM Counter

## Objective

Run a complete RTL-to-netlist workflow using Icarus Verilog simulation + Yosys synthesis, and understand the difference between simulation behavior and synthesized structure.

## Circuit Overview

A PWM counter controls LED brightness to create a "breathing" effect:

1. **Triangle Wave Generator**: 15-bit counter (32768 steps), outputs 13-bit duty reference (0 to 8191, period ~2.68s)
2. **PWM Carrier**: 13-bit counter (100MHz / 8192 ~ 12.2kHz), compared against triangle value
3. **PWM Comparator**: pwm_out = 1 when carrier < duty. Duty cycle sweeps 0% to 100% and back, creating breathing.

## Prerequisites

- Linux environment (physical / VM / WSL)
- Install Icarus Verilog, GTKWave, Yosys:
  ```bash
  sudo apt install iverilog gtkwave yosys
  ```
- Verify installation:
  ```bash
  which iverilog && which gtkwave && which yosys
  ```
  All three should print their paths.

## Directory Structure

```
lab1-breathing-led/
├── README.md            # This file
├── rtl/
│   ├── breathing_led.v  # PWM breathing LED core
│   └── top.v            # Top-level wrapper for Basys3
├── tb/
│   └── tb_breathing_led.v  # Simulation testbench
├── sim/
│   └── run.sh           # Simulation script
├── synth/
│   └── run.sh           # Synthesis script
└── fpga/
    └── basys3.xdc       # Basys3 pin constraints
```

## Usage

### 1. Simulation

```bash
cd sim
bash run.sh
```

GTKWave will auto-open `tb.vcd` if installed.

### 2. Synthesis (RTL -> Gate-level Netlist)

```bash
cd ../synth
bash run.sh
```

Netlist written to `breathing_led_synth.v`. Open it to see how RTL maps to generic gates.

## Acceptance Criteria (Self-check)

- [ ] `bash sim/run.sh` exits without errors, generates `tb.vcd`
- [ ] GTKWave shows `duty` as triangle wave: 0 up to 8191 then back to 0
- [ ] `pwm_out` duty cycle varies with `duty`: narrow when low, wide when high
- [ ] `bash synth/run.sh` exits without errors, generates `breathing_led_synth.v`
- [ ] Netlist contains `$_DFF_*` cells (e.g. `$_DFF_PN0_`)

## Board Info (Optional)

Target: **Digilent Basys3**

- **FPGA**: `xc7a35t-1cpg236C` (Xilinx Artix-7)
  - `xc7a`: Xilinx 7-series Artix family
  - `35`: ~35K logic cells
  - `t`: integrated high-speed transceiver
  - `-1`: standard speed grade
  - `cpg236`: 236-pin package
  - `C`: commercial temp range (0°C ~ +85°C)
- **Peripherals**: 16 LEDs (LD0–LD15), 4-digit 7-seg, 5 buttons, 16 switches
- **References**:
  - Basys3 homepage: https://digilent.com/reference/programmable-logic/basys-3/start
  - Basys3 reference manual (full XDC constraints)
  - Basys3 GitHub: https://github.com/Digilent/Basys3

`fpga/basys3.xdc` contains pin constraints for clock, reset, and LED. Use Vivado for synthesis, implementation, and download.

### Vivado Path Configuration

The Makefile and TCL scripts assume Vivado is installed at:
```
/opt/Xilinx/Vivado/2019.2/bin/vivado
```

If your installation is elsewhere, update these two locations before running `make fpga` or `make program`:

1. **Makefile** lines 19 and 24: change the hardcoded Vivado path
2. **fpga/run.tcl** and **fpga/program.tcl**: no edits needed (they are called by Makefile)

Alternatively, source Vivado into your shell environment:
```bash
source /opt/Xilinx/Vivado/2019.2/settings64.sh
# Then edit Makefile to use just 'vivado' instead of the full path
```

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| `iverilog: command not found` | Not installed | `sudo apt install iverilog` |
| `gtkwave: command not found` | Not installed | `sudo apt install gtkwave` |
| `yosys: command not found` | Not installed | `sudo apt install yosys` |
| GTKWave blank | VCD not generated | Check `$dumpfile` and `$dumpvars` in testbench |
| No `$_DFF_` in netlist | Yosys version difference | Search for `DFF`, names vary by version |
