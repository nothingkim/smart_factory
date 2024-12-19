`timescale 1ns / 1ps

module textlcd(
    input       RESET,
    input       CLK,
    output wire LCD_RS,
    output wire LCD_RW,
    output reg  LCD_EN,
    output wire [7:0] LCD_DATA
);

reg [31:0] cnt;
reg [1:0]  status;
reg [10:0] delay_lcdclk;
reg [5:0]  count_lcd;

reg [127:0] line_1;
reg [127:0] line_2;
reg [8:0]    set_data;

always @(posedge CLK or posedge RESET) begin
    if(RESET)
        cnt <= 25'd0;
    else begin
        if (cnt < 25'd23999999)       
            cnt <= cnt + 25'd1;
        else
            cnt <= 25'd0;
    end
end

always @(posedge CLK or posedge RESET) begin
    if(RESET)
        status <= 3'd0;
    else begin
        if (cnt == 25'd23999999)
            status <= status + 3'd1;
    end
end

always @(posedge RESET or posedge CLK) begin
    if(RESET) begin
        delay_lcdclk <= 11'd0;
        count_lcd <= 6'd0; 
        LCD_EN <= 1'b0;
    end else begin
        if (delay_lcdclk < 11'd1800)
            delay_lcdclk <= delay_lcdclk + 11'd1;
        else
            delay_lcdclk <= 11'd0;

        if (delay_lcdclk == 11'd0) begin
            if (count_lcd < 6'd39)
                count_lcd <= count_lcd + 6'd1;
            else
                count_lcd <= 6'd6;
        end

        if (delay_lcdclk == 11'd200)
            LCD_EN <= 1'b1;
        else if (delay_lcdclk == 11'd1800)
            LCD_EN <= 1'b0;
    end
end

initial begin
    line_1 <= {"I'm student     "};
    line_2 <= {"status is init  "};
end

always @(status) begin
    case(status)
        3'd0 : begin line_1 <= {"smart factory project"}; line_2 <= {"status is no. 0"}; end
        3'd1 : begin line_1 <= {"              "}; line_2 <= {"status is no. 1"}; end 
        3'd2 : begin line_1 <= {"              "}; line_2 <= {"status is no. 2"}; end 
        default: begin line_1 <= {"               "}; line_2 <= {"status is no. 3"}; end
    endcase
end

always @(posedge RESET or posedge CLK) begin
    if (RESET)
        set_data <= 9'd0;
    else begin
        case (count_lcd)
            0      : set_data <= {1'b0, 8'h38};
            1      : set_data <= {1'b0, 8'h38};
            2      : set_data <= {1'b0, 8'h0e};
            3      : set_data <= {1'b0, 8'h06};
            4      : set_data <= {1'b0, 8'h02};
            5      : set_data <= {1'b0, 8'h01};
            6      : set_data <= {1'b0, 8'h80};
            7      : set_data <= {1'b1, line_1[127:120]};
            8      : set_data <= {1'b1, line_1[119:112]};
            9      : set_data <= {1'b1, line_1[111:104]};
            10     : set_data <= {1'b1, line_1[103:96]};
            11     : set_data <= {1'b1, line_1[95:88]};
            12     : set_data <= {1'b1, line_1[87:80]};
            13     : set_data <= {1'b1, line_1[79:72]};
            14     : set_data <= {1'b1, line_1[71:64]};
            15     : set_data <= {1'b1, line_1[63:56]};
            16     : set_data <= {1'b1, line_1[55:48]};
            17     : set_data <= {1'b1, line_1[47:40]};
            18     : set_data <= {1'b1, line_1[39:32]};
            19     : set_data <= {1'b1, line_1[31:24]};
            20     : set_data <= {1'b1, line_1[23:16]};
            21     : set_data <= {1'b1, line_1[15:8]};
            22     : set_data <= {1'b1, line_1[7:0]};
            23     : set_data <= {1'b0, 8'hc0};
            24     : set_data <= {1'b1, line_2[127:120]};
            25     : set_data <= {1'b1, line_2[119:112]};
            26     : set_data <= {1'b1, line_2[111:104]};
            27     : set_data <= {1'b1, line_2[103:96]};
            28     : set_data <= {1'b1, line_2[95:88]};
            29     : set_data <= {1'b1, line_2[87:80]};
            30     : set_data <= {1'b1, line_2[79:72]};
            31     : set_data <= {1'b1, line_2[71:64]};
            32     : set_data <= {1'b1, line_2[63:56]};
            33     : set_data <= {1'b1, line_2[55:48]};
            34     : set_data <= {1'b1, line_2[47:40]};
            35     : set_data <= {1'b1, line_2[39:32]};
            36     : set_data <= {1'b1, line_2[31:24]};
            37     : set_data <= {1'b1, line_2[23:16]};
            38     : set_data <= {1'b1, line_2[15:8]};
            39     : set_data <= {1'b1, line_2[7:0]};
            40     : set_data <= {1'b0, 8'h02};
            41     : set_data <= {1'b0, 8'h02};
            default: ;
        endcase
    end
end

assign LCD_RS = set_data[8];
assign LCD_RW = 1'b0;
assign LCD_DATA = set_data[7:0];

endmodule
