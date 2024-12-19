`timescale 1ns / 1ps

module motor(
    input         RESET,
    input         CLK,
    input         MOTOR_DIR,
    input         MOTOR_ON,
    output reg [3:0] MOTOR_OUT
);

reg [31:0] cnt_motor;
reg sw_dir;
reg sw_on;
reg reg_MOTOR_DIR;
reg reg_MOTOR_ON;

wire [31:0] motor_speed = 32'd960000;

always @(posedge RESET or posedge CLK) begin
    if(RESET) begin
        reg_MOTOR_DIR <= 1'b0;
        reg_MOTOR_ON  <= 1'b0;
        sw_dir <= 1'b0;
        sw_on  <= 1'b0;
    end else begin
        reg_MOTOR_DIR <= MOTOR_DIR;
        reg_MOTOR_ON  <= MOTOR_ON;

        if(MOTOR_DIR == 1'b1 & reg_MOTOR_DIR == 1'b0)
            sw_dir <= ~sw_dir;

        if(MOTOR_ON == 1'b1 & reg_MOTOR_ON == 1'b0)
            sw_on <= ~sw_on;
    end
end

always @(posedge RESET or posedge CLK) begin
    if(RESET) begin
        cnt_motor <= 32'd0;
        MOTOR_OUT <= 4'b1001;
    end else begin
        if(!sw_on)
            cnt_motor <= 32'd0;
        else if(cnt_motor < (motor_speed-1))
            cnt_motor <= cnt_motor + 32'd1;
        else
            cnt_motor <= 32'd0;

        case (cnt_motor)
            0: 
                if(sw_dir)
                    MOTOR_OUT <= 4'b0101;
                else
                    MOTOR_OUT <= 4'b1001;
            (motor_speed/4):
                if(sw_dir)
                    MOTOR_OUT <= 4'b0110;
                else
                    MOTOR_OUT <= 4'b1010;
            (motor_speed/4)*2:
                if(sw_dir)
                    MOTOR_OUT <= 4'b1010;
                else
                    MOTOR_OUT <= 4'b0110;
            (motor_speed/4)*3:
                if(sw_dir)
                    MOTOR_OUT <= 4'b1001;
                else
                    MOTOR_OUT <= 4'b0101;
        endcase
    end
end

endmodule
