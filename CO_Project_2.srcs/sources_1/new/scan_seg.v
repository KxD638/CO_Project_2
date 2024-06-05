`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 07:34:20
// Design Name: 
// Module Name: scan_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module scan_seg(
    input rst,
    input clk,
    input segCtrl,//1'b1 if 7seg need to work
    input [31:0] content,//要显示的内容
    output reg [7:0] seg_en,//chip select signal
    output [7:0] seg_out0,//段选信号（//七段加一点分别是否亮起）
    output [7:0] seg_out1
    );
    
    reg clkout;//频率降低后的时间信号
    reg [31:0] cnt;//计数器
    
    parameter period = 32'd20000;//删了个0，周期缩短至1/10， 不知道会多还是少，看情况调一下
    
    always @(posedge clk, negedge rst)
    begin
        if(!rst) begin
            cnt <= 0;
            clkout <= 0;
        end
        else begin
            if(cnt == (period >> 1) - 1)
            begin
                clkout <= ~clkout;
                cnt <= 0;
            end
            else
                cnt <= cnt + 1;
        end
    end
    
    reg [2:0] scan_cnt;//片选信号循环计数器
    
    always @(posedge clkout, negedge rst)
    begin
        if(~rst) begin
            scan_cnt <= 0;
        end
        else begin
            if(scan_cnt == 3'd7) begin
                scan_cnt <= 0;
            end
            else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end
    
    //scan_cnt大小对应哪一个片选信号为1
    always @ (*)
    begin
        if(~segCtrl) seg_en = 8'b0000_0000;
        else
        case(scan_cnt)
            3'b000: seg_en = 8'b0000_0001;//8'h01;
            3'b001: seg_en = 8'b0000_0010;//8'h02;
            3'b010: seg_en = 8'b0000_0100;//8'h04;
            3'b011: seg_en = 8'b0000_1000;//8'h08;
            3'b100: seg_en = 8'b0001_0000;//8'h10;
            3'b101: seg_en = 8'b0010_0000;//8'h20;
            3'b110: seg_en = 8'b0100_0000;//8'h40;
            3'b111: seg_en = 8'b1000_0000;//8'h80;
            default: seg_en = 8'b0000_0000;//8'h00;
        endcase
    end
    
    reg [3:0] con;//当前要显示的数字
    always @ (*)
        case(scan_cnt)
            3'b000: con = content[3:0];
            3'b001: con = content[7:4];
            3'b010: con = content[11:8];
            3'b011: con = content[15:12];
            3'b100: con = content[19:16];
            3'b101: con = content[23:20];
            3'b110: con = content[27:24];
            3'b111: con = content[31:28];
            default: con = 4'hZ;
        endcase
    
    light_7seg useg0(con, seg_out0);
    light_7seg useg1(con, seg_out1);
endmodule