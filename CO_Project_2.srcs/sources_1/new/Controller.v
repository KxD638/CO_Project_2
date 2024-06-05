`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 16:31:29
// Design Name: 
// Module Name: Controller
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

//ALUOp: L/S 000, B 001, R 010, I 011, J 100, lui 101, auipc 110
`include "para.vh"
module Controller(
    input [6:0] op,
    output reg Jump,//1'b1 while J-type inst
    output reg Branch,//1'b1 while B-type inst
    output reg MemorIORead,//1'b1 while need to read from Data Memory or IO
    output reg MemorIOtoReg,//1'b1 while send the data from Data Memory or IO to Registers, 0 while send the data from ALU
    output reg [2:0] ALUOp,//indicate what type inst is, different from PPT
    output reg MemorIOWrite,//1'b1 while need to write to Data Memory
    output reg ALUSrc,//1'b1 while select immediate as the operand of ALU, otherwise select rs2Data
    output reg RegWrite//1'b1 while need to write to Registers
    //先注释掉，这根线连到哪去都不知道
    //output reg triggerException // Output to indicate an exception should be triggered
    );
    always @(*)
        case(op)
            `R:begin//`R
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b0;
            ALUOp = `ALUOpR;//3'b010
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            end
            `I:begin
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b0;
            ALUOp = `ALUOpI;//3'b011
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            end
            `L:begin
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b1;
            MemorIOtoReg = 1'b1;
            ALUOp = `ALUOpLS;//3'b000
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            end
            `S:begin
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b0;//doesn't matter
            MemorIOtoReg = 1'b0;//doesn't matter
            ALUOp = `ALUOpLS;//3'b000
            MemorIOWrite = 1'b1;
            ALUSrc = 1'b1;
            RegWrite = 1'b0;
            end
            `B:begin
            Jump = 1'b0;
            Branch = 1'b1;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b0;
            ALUOp = `ALUOpB;
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            end
            `J:begin
            Jump = 1'b1;
            Branch = 1'b0;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b0;
            ALUOp = `ALUOpJ;
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b0;//doen't matter
            RegWrite = 1'b1;
            end
            `lui:begin
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b1;
            ALUOp = `ALUOplui;
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            end
            `auipc:begin
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b1;
            ALUOp = `ALUOpauipc;
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            end
            `SYSTEM: begin//ecall opcode和其他指令都不一样，已经可以区分了
                // 设置 ecall 相关的控制信号
                Jump = 1'b0;
                Branch = 1'b0;
                MemorIORead = 1'b0;
                MemorIOtoReg = 1'b0;
                ALUOp = `ALUOpecall;  // 使用特定的 ALU 操作码
                MemorIOWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                //triggerException = 1'b1;  // 触发异常
            end
            default:begin
            Jump = 1'b0;
            Branch = 1'b0;
            MemorIORead = 1'b0;
            MemorIOtoReg = 1'b0;
            ALUOp = 3'b000;
            MemorIOWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            //triggerException = 1'b0;
            end
        endcase
endmodule

