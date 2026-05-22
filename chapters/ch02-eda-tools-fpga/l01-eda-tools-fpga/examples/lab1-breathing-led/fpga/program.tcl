## Program Basys3 with generated bitstream
## Usage: vivado -mode batch -source fpga/program.tcl

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target

# Find the device
set hw_device [get_hw_devices xc7a35t_0]

# Set bitstream file
set_property PROGRAM.FILE {fpga/build/top.bit} $hw_device

# Program the device
program_hw_devices $hw_device

puts "========================================"
puts "Device programmed successfully!"
puts "LED LD0 should show breathing effect"
puts "========================================"

close_hw_target
disconnect_hw_server
close_hw_manager
