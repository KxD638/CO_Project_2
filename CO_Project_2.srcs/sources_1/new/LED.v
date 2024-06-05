`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 05:26:33
// Design Name: 
// Module Name: LED
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


module LED(
    input clk,
    input rst,
    input LEDCtrl,//1'b1 if LED need to work
    input [31:0] io_wdata,
    output reg [7:0] led
    );
    reg clkout;//Ƶ�ʽ��ͺ��ʱ���ź�
    reg [31:0] cnt;//������
    
    parameter period = 32'd50_000_000;//2s  10_000_000
    //ת�����ʱ���ź�����Ϊ2s
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
    
    reg [1:0] scan_cnt;//չʾ����ѭ��������
    
    always @(posedge clkout, negedge rst, negedge LEDCtrl)
    begin
        if(~rst || ~LEDCtrl) begin
            scan_cnt <= 0;
        end
        else begin
            if(scan_cnt == 2'd3) begin
                scan_cnt <= 0;
            end
            else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end
    
    reg [7:0] con;//��ǰҪ��ʾ�Ĳ���
    always @ (*)
        case(scan_cnt)
            2'b00: con = io_wdata[7:0];
            2'b01: con = io_wdata[15:8];
            2'b10: con = io_wdata[23:16];
            2'b11: con = io_wdata[31:24];
            default: con = 8'h00;
        endcase
    
    always @ (*)
        if(LEDCtrl) led = con;
        else led = 8'h00;
endmodule
