`timescale 1ns / 1ps

module led_ctrl(
    input RESET,
    input CLK,
    input Mode_Switch,
    input [8:0] KEY,
    output wire [7:0] LED
);

reg [2:0] status_led;
reg [24:0] cnt;
reg [7:0] regLED;

always @ (posedge CLK or posedge RESET) begin
    if (RESET)
        cnt <= 25'd0;
    else begin
        if (cnt < 25'd23999999)
            cnt <= cnt + 25'd1;
        else
            cnt <= 25'd0;
    end
end

always @ (posedge CLK or posedge RESET) begin
    if (RESET)
        status_led <= 3'd0;
    else begin
        if (cnt == 25'd23999999)
            status_led <= status_led + 3'd1;
    end
end

always @ (status_led) begin
    case (status_led)
        3'd1: regLED <= 8'b11111110;
        3'd2: regLED <= 8'b11111101;
        3'd3: regLED <= 8'b11111011;
        3'd4: regLED <= 8'b11110111;
        3'd5: regLED <= 8'b11101111;
        3'd6: regLED <= 8'b11011111;
        3'd7: regLED <= 8'b10111111;
        default: regLED <= 8'b01111111;
    endcase
end

assign LED = (!Mode_Switch) ? regLED : (KEY[8]) ? 8'h0 : (8'hff ^ KEY[7:0]);

endmodule
