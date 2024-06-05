`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 17:34:32
// Design Name: 
// Module Name: Decoder
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

module Decoder(
    input clk,
    input rst,
    input inter_ack,
    input RegWrite,       // 1'b1 while need to write to Registers
    input [31:0] inst,
    input [31:0] writeData, // the data to be written to the specified register
    output [31:0] rs1Data,
    output [31:0] rs2Data,
    output [31:0] imm32
);

    reg [31:0] Register [31:0];

    wire [4:0] rd = inst[11:7];
    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];

    assign rs1Data = Register[rs1];
    assign rs2Data = Register[rs2];
    
    integer i = 0;
    always @(posedge clk, negedge rst) begin
        if(~rst) begin
            Register[0] <= 32'h0000_0000;
            Register[1] <= 32'h0000_0000;
            Register[2] <= 32'h7fff_effc;//有两个初始化不是0
            Register[3] <= 32'h1000_8000;
            for (i = 4; i < 32; i = i + 1) begin
                Register[i] <= 32'h0000_0000;
            end
        end
        else if(inter_ack == 1'b1) begin
        Register[0] <= 32'h0000_0000;
        end
        else if(RegWrite && rd > 0) Register[rd] <= writeData;
        else begin
        Register[0] <= 32'h0000_0000;
        end
    end
    
    // ImmGen
    ImmGen uImmGen(inst, imm32);

endmodule

