## FPGA Implementation Script for Basys3
## Device: xc7a35t-1cpg236C
## Usage: vivado -mode batch -source fpga/run.tcl

set top_module    "top"
set part_number   "xc7a35tcpg236-1"
set rtl_top       "rtl/top.v"
set rtl_core      "rtl/breathing_led.v"
set xdc_file      "fpga/basys3.xdc"
set build_dir     "fpga/build"

# Create build directory
file mkdir $build_dir

# Read sources
read_verilog $rtl_top
read_verilog $rtl_core
read_verilog rtl/button.v
read_xdc $xdc_file

# Synthesis
synth_design -top $top_module -part $part_number
write_checkpoint -force $build_dir/post_synth.dcp
report_utilization -file $build_dir/utilization_synth.rpt

# Implementation
opt_design
place_design
write_checkpoint -force $build_dir/post_place.dcp
phys_opt_design
route_design
write_checkpoint -force $build_dir/post_route.dcp

# Reports
report_timing_summary -file $build_dir/timing_summary.rpt
report_utilization -file $build_dir/utilization_impl.rpt
report_drc -file $build_dir/drc.rpt

# Generate bitstream
write_bitstream -force $build_dir/$top_module.bit

puts "========================================"
puts "FPGA build complete!"
puts "  Bitstream: $build_dir/$top_module.bit"
puts "  Timing:    $build_dir/timing_summary.rpt"
puts "  Utilization: $build_dir/utilization_impl.rpt"
puts "========================================"
