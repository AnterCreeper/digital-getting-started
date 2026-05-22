`timescale 1ns / 1ps

module tb_breathing_led;

reg  clk;
reg  rst_n;
reg  mode;
wire pwm_out;

// Small parameters for simulation:
// TRI_WIDTH=4:  16 triangle steps, breathing period = 16*8 = 128 cycles
// PWM_WIDTH=3:  8 carrier levels
// BLINK_WIDTH=4: blink frequency = 100MHz/16 = 6.25MHz (visible in testbench)
breathing_led #(
    .TRI_WIDTH(4),
    .PWM_WIDTH(3),
    .BLINK_WIDTH(4)
) dut (
    .clk     (clk),
    .rst_n   (rst_n),
    .mode    (mode),
    .pwm_out (pwm_out)
);

// 100MHz clock: period 10ns
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test sequence
initial
begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb_breathing_led);
    
    rst_n = 0;
    mode  = 0;
    #200 rst_n = 1;     // release reset after 200ns
    
    #1000;              // observe breathing mode for 1us
    
    // switch to blink mode
    @(posedge clk)
    #1 mode = 1;
    
    #1000;              // observe blink mode for 1us
    
    $finish;
end

endmodule
