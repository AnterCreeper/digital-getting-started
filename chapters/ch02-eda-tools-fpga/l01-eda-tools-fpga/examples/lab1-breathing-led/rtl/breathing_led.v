`timescale 1ns / 1ps

module breathing_led #(
    parameter TRI_WIDTH = 15,      // triangle wave counter width
    parameter PWM_WIDTH = 13,      // PWM carrier width
    parameter BLINK_WIDTH = 26     // blink frequency: 100MHz / 2^BLINK_WIDTH
)(
    input  wire clk,
    input  wire rst_n,
    input  wire mode,              // 0 = breathing, 1 = blink
    output wire pwm_out
);

localparam TRI_MIRROR_WIDTH = TRI_WIDTH - 1;
localparam PWM_MAX = (1 << PWM_WIDTH) - 1;

//=========================================================================
// Breathing mode: triangle wave + PWM
//=========================================================================

// triangle wave counter
reg [TRI_WIDTH-1:0] tri_cnt;

// mirror: MSB controls direction
wire [TRI_MIRROR_WIDTH-1:0] tri_mirror;
assign tri_mirror = tri_cnt[TRI_WIDTH-1] ? ~tri_cnt[TRI_MIRROR_WIDTH-1:0]
                                         :  tri_cnt[TRI_MIRROR_WIDTH-1:0];

// duty cycle reference
wire [PWM_WIDTH-1:0] duty;
assign duty = tri_mirror[TRI_MIRROR_WIDTH-1 : TRI_MIRROR_WIDTH-PWM_WIDTH];

// PWM carrier counter
reg [PWM_WIDTH-1:0] pwm_cnt;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        pwm_cnt <= 0;
        tri_cnt <= 0;
    end else
    begin
        if (pwm_cnt == PWM_MAX[PWM_WIDTH-1:0])
        begin
            pwm_cnt <= 0;
            tri_cnt <= tri_cnt + 1;
        end else
        begin
            pwm_cnt <= pwm_cnt + 1;
        end
    end
end

wire breathing_out = (pwm_cnt < duty);

//=========================================================================
// Blink mode: independent slow counter
//=========================================================================

reg [BLINK_WIDTH-1:0] blink_cnt;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
        blink_cnt <= 0;
    else
        blink_cnt <= blink_cnt + 1;
end

wire blink_out = blink_cnt[BLINK_WIDTH-1];

//=========================================================================
// Mode selection
//=========================================================================

assign pwm_out = mode ? blink_out : breathing_out;

endmodule
