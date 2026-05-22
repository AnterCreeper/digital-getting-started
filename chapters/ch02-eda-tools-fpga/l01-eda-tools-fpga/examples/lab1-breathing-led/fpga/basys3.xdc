## Basys3 XDC Constraints for Breathing LED
## Device: xc7a35t-1cpg236C
##
## Reference: https://github.com/Digilent/Basys3/blob/master/constraint/xdc/Basys3_Master.xdc

## Clock (100 MHz onboard oscillator)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]

## Button BTNC (center, active-high when pressed) -> Reset
set_property PACKAGE_PIN U18 [get_ports btn_rst]
set_property IOSTANDARD LVCMOS33 [get_ports btn_rst]

## Button BTNR (right, active-high when pressed) -> Mode toggle
set_property PACKAGE_PIN T17 [get_ports btn_mode]
set_property IOSTANDARD LVCMOS33 [get_ports btn_mode]

## LED LD0 driven by PWM
set_property PACKAGE_PIN U16 [get_ports led_pwm]
set_property IOSTANDARD LVCMOS33 [get_ports led_pwm]
