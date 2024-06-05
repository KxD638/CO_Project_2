`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 07:33:10
// Design Name: 
// Module Name: light_7seg
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

//把要显示的数字转化为七段数码管各段是否亮起
module light_7seg(
    input [3:0] sw,//要显示的数字
    output reg [7:0] seg_out//七段加一点分别是否亮起
    );
    always @ *
        case(sw)
            4'h0: seg_out = 8'b1111_1100;
            4'h1: seg_out = 8'b0110_0000;
            4'h2: seg_out = 8'b1101_1010;
            4'h3: seg_out = 8'b1111_0010;
            4'h4: seg_out = 8'b0110_0110;
            4'h5: seg_out = 8'b1011_0110;
            4'h6: seg_out = 8'b1011_1110;
            4'h7: seg_out = 8'b1110_0000;
            4'h8: seg_out = 8'b1111_1110;
            4'h9: seg_out = 8'b1110_0110;
            4'ha: seg_out = 8'b1110_1110;
            4'hb: seg_out = 8'b0011_1110;
            4'hc: seg_out = 8'b1001_1100;
            4'hd: seg_out = 8'b0111_1010;
            4'he: seg_out = 8'b1001_1110;
            4'hf: seg_out = 8'b1000_1110;
            default: seg_out = 8'b0000_0000;
        endcase
endmodule
