module button(
    input  wire clk,
    input  wire rst_n,           // active-low reset
    input  wire btn_n,           // active-low button input
    output wire press_status,    // raw press captured (before debounce)
    output reg  press_valid,     // debounced press released, ready to consume
    input  wire press_done       // consumer acknowledges: "I have acted on this press"
);

reg press_captured;
reg debounce_active;
reg [16:0] debounce_cnt;

assign press_status = press_captured;

// Stage 1: capture button press (asynchronous, active-low)
always @(posedge clk or negedge btn_n)
begin
    if (!btn_n)
    begin
        press_captured <= 1;
    end else
    begin
        if (debounce_active) press_captured <= 0;
    end
end

// Stage 2: debounce + release detection + handshake
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        press_valid      <= 0;
        debounce_active  <= 0;
        debounce_cnt     <= 0;
    end else
    begin
        if (press_captured)
        begin
            if (!debounce_active)
            begin
                debounce_active <= 1;
                debounce_cnt    <= 0;
            end else
            begin
                if(!debounce_cnt[16]) debounce_cnt <= debounce_cnt + 1;
            end
            if (press_done) press_valid <= 0;
        end else
        begin
            if (debounce_active) debounce_active <= 0;
            if (debounce_active && debounce_cnt[16]) press_valid <= 1;
            else if (press_done) press_valid <= 0;
        end
    end
end

endmodule
