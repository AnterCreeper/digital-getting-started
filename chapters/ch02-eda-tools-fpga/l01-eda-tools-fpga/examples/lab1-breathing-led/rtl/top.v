module top(
    input  wire clk,          // W5, 100MHz
    input  wire btn_rst,      // U18, BTNC, active-high when pressed
    input  wire btn_mode,     // T17, BTNR, active-high when pressed
    output wire led_pwm       // U16, LD0
);

// Basys3 buttons are active-high when pressed.
// Internal reset: active-low (release = running, press = reset)
wire rst_n = ~btn_rst;

// Mode button: active-high external -> active-low for button module
wire mode_btn_n = ~btn_mode;

wire press_valid;
reg  press_done;

// Button debounce + handshake
button u_btn_mode (
    .clk           (clk),
    .rst_n         (rst_n),
    .btn_n         (mode_btn_n),
    .press_status  (),
    .press_valid   (press_valid),
    .press_done    (press_done)
);

// Simple consumer: toggle mode on each validated press
reg mode;
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        mode       <= 1'b0;
        press_done <= 1'b0;
    end else
    begin
        if (press_valid && !press_done)
        begin
            mode       <= ~mode;
            press_done <= 1'b1;
        end else
        if (!press_valid)
        begin
            press_done <= 1'b0;
        end
    end
end

breathing_led #(
    .TRI_WIDTH(15),
    .PWM_WIDTH(13)
) u_led (
    .clk     (clk),
    .rst_n   (rst_n),
    .mode    (mode),
    .pwm_out (led_pwm)
);

endmodule
