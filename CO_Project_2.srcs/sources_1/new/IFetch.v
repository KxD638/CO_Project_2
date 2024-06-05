`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/21 15:48:32
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    input clk,
    input rst,
    input inter_ack,
    input [31:0] relative_offset,//branch/jump target relative offset
    input Branch,//1'b1 while B-type inst
    input Condition,//1'b1 while branch condition is satisfied
    input Jump,//1'b1 while J-type inst
    output [31:0] inst,//inst fetched from inst memory
    output reg [31:0] PC
    // UART Programmer Pinouts
    //input upg_rst_i, // UPG reset (Active High)
    //input upg_clk_i, // UPG clock (10MHz)
    //input upg_wen_i, // UPG write enable
    //input[13:0] upg_adr_i, // UPG write address
    //input[31:0] upg_dat_i, // UPG write data
    //input upg_done_i // 1 if program finished
    );
    //wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i );
    
    always @(negedge clk, negedge rst) begin
    if(rst == 1'b0) PC <= 32'h0000_0000;
    else if(inter_ack == 1'b1) PC <= PC;
    else if(Branch == 1'b1 && Condition == 1'b1) PC <= $signed(PC) + $signed(relative_offset);
    else if(Jump == 1'b1) PC <= $signed(PC) + $signed(relative_offset);
    else PC <= PC + 4;
    end
    
    //prgrom urom(.clka(kickOff ? clk:upg_clk_i),.wea(kickOff ? 1'b0:upg_wen_i), .addra(kickOff? PC[15:2]:upg_adr_i),.dina(kickOff?32'h0000_0000:upg_dat_i), .douta(inst));
    prgrom urom(.clka(clk), .addra(PC[15:2]), .douta(inst));
endmodule
