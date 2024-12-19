`timescale 1ns / 1ps

module dot(
    input RESET,
    input CLK,
    output [9:0] DOT_COL,
    output [13:0] DOT_RAW
);

reg [12:0] cnt;
reg [3:0] COL_counter;
reg [24:0] DOT_Data_counter;
reg [3:0]  DOT_Data;
reg [9:0] dot_col_reg;
reg [6:0] dot_raw_reg;

always @ (posedge RESET or posedge CLK) begin
    if (RESET)
        cnt <= 13'd0;
    else begin
        if (cnt < 13'd5999)
            cnt <= cnt + 13'd1;
        else
            cnt <= 13'd0;
    end
end

always @ (posedge RESET or posedge CLK) begin
    if (RESET)
        COL_counter <=4'd0;
    else if (cnt == 13'd5999)
        if(COL_counter == 4'd9)
            COL_counter <=4'd0;
        else
            COL_counter <= COL_counter + 1'b1;
end

always @ (posedge RESET or posedge CLK) begin
    if(RESET)
        DOT_Data_counter <=25'd0;
    else if(DOT_Data_counter < 25'd23999999)
        DOT_Data_counter <= DOT_Data_counter + 25'd1;
    else
        DOT_Data_counter <= 25'd0;
end

always @ (posedge RESET or posedge CLK) begin
    if(RESET)
        DOT_Data <=4'd0;
    else if(DOT_Data_counter == 25'd23999999)
        if(DOT_Data == 4'd9)
            DOT_Data <= 4'd0;
        else
            DOT_Data <= DOT_Data + 4'd1;
end

always @ (COL_counter) begin

    if(DOT_Data == 4'd0) begin
        case(COL_counter)
            4'd0:  begin dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~7'b0111110; end
            4'd1:  begin dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~7'b1111111; end
            4'd2:  begin dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~7'b1100011; end
            4'd3:  begin dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~7'b1110011; end
            4'd4:  begin dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~7'b1110011; end
            4'd5:  begin dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~7'b1111111; end
            4'd6:  begin dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~7'b1100111; end
            4'd7:  begin dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~7'b1100011; end
            4'd8:  begin dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~7'b1111111; end
            4'd9:  begin dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~7'b0111110; end
        endcase
    end else if(DOT_Data == 4'd1) begin

        case(COL_counter)
            4'd0:  begin dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~7'b0001100; end
            4'd1:  begin dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~7'b0011100; end
            4'd2:  begin dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~7'b0011100; end
            4'd3:  begin dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~7'b0001100; end
            4'd4:  begin dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~7'b0001100; end
            4'd5:  begin dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~7'b0001100; end
            4'd6:  begin dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~7'b0001100; end
            4'd7:  begin dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~7'b0001100; end
            4'd8:  begin dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~7'b0001100; end
            4'd9:  begin dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~7'b0011110; end
        endcase
    end

    else if(DOT_Data == 4'd2) begin
        case(COL_counter)
            4'd0:  begin dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~7'h7e; end
            4'd1:  begin dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~7'h7f; end
            4'd2:  begin dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~7'h03; end
            4'd3:  begin dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~7'h03; end
            4'd4:  begin dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~7'h3f; end
            4'd5:  begin dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~7'h7e; end
            4'd6:  begin dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~7'h60; end
            4'd7:  begin dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~7'h60; end
            4'd8:  begin dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~7'h7f; end
            4'd9:  begin dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~7'h7f; end
        endcase
    end
    	else if(DOT_Data == 4'd3)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'hfe}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h7f}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h03}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h03}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h7f}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h7f}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h03}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h03}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h7f}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h7e}; end
			endcase
		end
	else if(DOT_Data == 4'd4)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'h60}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h66}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h66}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h66}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h66}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h66}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h7f}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h7f}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h06}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h06}; end
			endcase
		end
	else if(DOT_Data == 4'd5)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'h7f}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h7f}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h60}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h60}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h7e}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h7f}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h03}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h03}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h7f}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h7e}; end
			endcase
		end
	else if(DOT_Data == 4'd6)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'h60}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h60}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h60}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h60}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h7e}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h7f}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h63}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h63}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h7f}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h3e}; end
			endcase
		end
	else if(DOT_Data == 4'd7)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'h7f}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h7f}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h63}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h63}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h03}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h03}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h03}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h03}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h03}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h03}; end
			endcase
		end
	else if(DOT_Data == 4'd8)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'h3e}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h7f}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h63}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h63}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h7f}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h7f}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h63}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h63}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h7f}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h3e}; end
			endcase
		end
	else if(DOT_Data == 4'd9)
		begin
			case(COL_counter)
				4'd0	: begin	dot_col_reg <= 10'b0000000001; dot_raw_reg <= ~{7'h3e}; end
				4'd1	: begin	dot_col_reg <= 10'b0000000010; dot_raw_reg <= ~{7'h7f}; end
				4'd2	: begin	dot_col_reg <= 10'b0000000100; dot_raw_reg <= ~{7'h63}; end
				4'd3	: begin	dot_col_reg <= 10'b0000001000; dot_raw_reg <= ~{7'h63}; end
				4'd4	: begin	dot_col_reg <= 10'b0000010000; dot_raw_reg <= ~{7'h7f}; end
				4'd5	: begin	dot_col_reg <= 10'b0000100000; dot_raw_reg <= ~{7'h3f}; end
				4'd6	: begin	dot_col_reg <= 10'b0001000000; dot_raw_reg <= ~{7'h03}; end
				4'd7	: begin	dot_col_reg <= 10'b0010000000; dot_raw_reg <= ~{7'h03}; end
				4'd8	: begin	dot_col_reg <= 10'b0100000000; dot_raw_reg <= ~{7'h03}; end
				4'd9	: begin	dot_col_reg <= 10'b1000000000; dot_raw_reg <= ~{7'h03}; end
			endcase
		end
end

assign DOT_COL = dot_col_reg;
assign DOT_RAW = {dot_raw_reg, dot_raw_reg};
endmodule
