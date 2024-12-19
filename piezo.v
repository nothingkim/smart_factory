`timescale 1ns / 1ps

module piezo(
    input       RESET,
    input       CLK,
    input [8:0] KEY,
    output wire BUZZER
);

parameter [15:0] reg_do       = 16'd11659;
parameter [15:0] reg_re       = 16'd10388;
parameter [15:0] reg_mi       = 16'd9253;
parameter [15:0] reg_pa       = 16'd8736;
parameter [15:0] reg_sol      = 16'd7782;
parameter [15:0] reg_ra       = 16'd6929;
parameter [15:0] reg_si       = 16'd6175;
parameter [15:0] reg_high_do  = 16'd5827;
parameter [15:0] reg_high_re  = 16'd5192;

reg [15:0] buzzer_counter_max;
reg [15:0] buzzer_counter;
reg        regBUZZER;

always @(posedge CLK or posedge RESET) begin
    if(RESET)
        buzzer_counter_max <= 16'd0;
    else begin
        if(KEY[0])      buzzer_counter_max <= reg_do;
        else if(KEY[1]) buzzer_counter_max <= reg_re;
        else if(KEY[2]) buzzer_counter_max <= reg_mi;
        else if(KEY[3]) buzzer_counter_max <= reg_pa;
        else if(KEY[4]) buzzer_counter_max <= reg_sol;
        else if(KEY[5]) buzzer_counter_max <= reg_ra;
        else if(KEY[6]) buzzer_counter_max <= reg_si;
        else if(KEY[7]) buzzer_counter_max <= reg_high_do;
        else if(KEY[8]) buzzer_counter_max <= reg_high_re;
        else             buzzer_counter_max <= 16'd0;
    end
end

always @(posedge CLK or posedge RESET) begin
    if(RESET)
        buzzer_counter <= 16'd0;
    else
        if(buzzer_counter > buzzer_counter_max)
            buzzer_counter <= 16'd0;
        else
            buzzer_counter <= buzzer_counter + 1;
end

always @(posedge CLK or posedge RESET) begin
    if(RESET)
        regBUZZER <= 1'b1;
    else begin
        if(KEY[8:0] == 0)
            regBUZZER <= 1'b1;
        else if(buzzer_counter == 16'd1)
            regBUZZER <= ~regBUZZER;
    end
end

assign BUZZER = regBUZZER;

endmodule
