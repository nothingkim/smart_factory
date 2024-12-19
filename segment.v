`timescale 1ns / 1ps

module bin2seg(
    input [3:0] bin_data,
    output wire [7:0] seg_data
);
assign seg_data =
    (bin_data==0)?8'b00000011:
    (bin_data==1)?8'b10011111:
    (bin_data==2)?8'b00100101:
    (bin_data==3)?8'b00001101:
    (bin_data==4)?8'b10011001:
    (bin_data==5)?8'b01001001:
    (bin_data==6)?8'b01000001:
    (bin_data==7)?8'b00011011:
    (bin_data==8)?8'b00000001:8'b00001001;

endmodule


module segment(
    input       CLK,
    input       RESET,
    output reg [3:0] FND_COM,
    output reg [7:0] FND_DATA
);

reg [31:0] cnt_time0;
reg sec;
reg [15:0] cnt64k;
reg [1:0] cnt4;
reg [15:0] regseg;

wire [7:0] seg0;
wire [7:0] seg1;
wire [7:0] seg2;
wire [7:0] seg3;

always @(posedge RESET or posedge CLK) begin
    if(RESET)
        cnt_time0 <= 32'd0;
    else if (cnt_time0 < 32'd23999999)
        cnt_time0 <= cnt_time0 + 32'd1;
    else
        cnt_time0 <= 32'd0;
end

always @(posedge RESET or posedge CLK) begin
    if (RESET)
        sec <= 16'd0;
    else if (cnt_time0 == 32'd23999999)
        sec <= 1'b1;
    else
        sec <= 1'b0;
end

always @(posedge RESET or posedge CLK) begin
    if (RESET)
        cnt64k <= 16'd0;
    else begin
        if (cnt64k < 16'hffff)
            cnt64k <= cnt64k + 16'd1;
        else
            cnt64k <= 16'd0;
    end
end

always @(posedge RESET or posedge CLK) begin
    if (RESET)
        cnt4 <= 2'b00;
    else begin
        if (cnt64k == 16'hffff)
            if (cnt4 < 2'b11)
                cnt4 <= cnt4 + 2'b01;
            else
                cnt4 <= 2'b00;
    end
end

always @(posedge RESET or posedge CLK) begin
    if(RESET)
        regseg <= 16'd0;
    else begin
        if(sec)
            if(regseg == 16'h9999)
                regseg <= 16'h0000;
            else if (regseg[11:0] == 12'h999)
                regseg <= {regseg[15:12] + 4'd1, 12'h000};
            else if (regseg[7:0] == 8'h99)
                regseg[11:0] <= {regseg[11:8] + 4'd1, 8'h00};
            else if (regseg[3:0] == 4'h9)
                regseg[7:0] <= {regseg[7:4] + 4'd1, 4'h0};
            else
                regseg[3:0] <= regseg[3:0] + 4'd1;
    end
end

always @(cnt4) begin
    case (cnt4)
        2'b00: FND_COM <= 4'b1000;
        2'b01: FND_COM <= 4'b0100;
        2'b10: FND_COM <= 4'b0010;
        default: FND_COM <= 4'b0001;
    endcase
end

bin2seg u0 (.bin_data(regseg[15:12]), .seg_data(seg0));
bin2seg u1 (.bin_data(regseg[11:8]), .seg_data(seg1));
bin2seg u2 (.bin_data(regseg[7:4]), .seg_data(seg2));
bin2seg u3 (.bin_data(regseg[3:0]), .seg_data(seg3));

always @(FND_COM or seg0 or seg1 or seg2 or seg3) begin
    case (FND_COM)
        4'b1000: FND_DATA <= seg0;
        4'b0100: FND_DATA <= seg1;
        4'b0010: FND_DATA <= seg2;
        default: FND_DATA <= seg3;
    endcase
end

endmodule
