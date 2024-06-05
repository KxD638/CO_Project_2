`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 16:34:02
// Design Name: 
// Module Name: ALU
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

`include "para.vh"
module ALU(
    input [31:0] rs1Data,
    input [31:0] rs2Data,
    input [31:0] imm32,
    input ALUSrc,//1'b1 while select immediate as the operand of ALU, otherwise select rs2Data
    input [2:0] ALUOp,//indicate what type inst is
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] PC,
    output reg [31:0] ALUResult,
    output reg Condition//1'b1 while branch condition is satisfied
    );

    wire [31:0] operand2;
    assign operand2 = (ALUSrc == 1'b0) ? rs2Data : imm32;

    always @ (*)
        case(ALUOp)
            `ALUOpLS: ALUResult = $signed(rs1Data) + $signed(operand2);// Load/Store operations
            `ALUOpB:
                case(funct3)
                    3'h0, 3'h4, 3'h5: ALUResult = $signed(rs1Data) - $signed(operand2);
                    default: ALUResult = rs1Data - operand2; // Unsigned branch conditions
                endcase
            `ALUOpR: // R-type operations
                case(funct3)
                    `fun3addsub:
                        case(funct7)
                            `fun7add: ALUResult = $signed(rs1Data) + $signed(operand2);
                            default: ALUResult = $signed(rs1Data) - $signed(operand2);//sub
                        endcase
                    `fun3or: ALUResult = rs1Data | operand2;
                    `fun3and: ALUResult = rs1Data & operand2;
                    default: ALUResult = rs1Data << operand2; // sll
                endcase
            `ALUOpI: // I-type operations
                case(funct3)
                    `fun3addi: ALUResult = $signed(rs1Data) + $signed(operand2);
                    `fun3slli: ALUResult = rs1Data << operand2;
                    `fun3xori: ALUResult = rs1Data ^ operand2;
                    default: ALUResult = rs1Data >> operand2; // srli
                endcase
            `ALUOpJ: ALUResult = PC + 4; // J-type operations
            `ALUOplui: ALUResult = imm32 << 12; // LUI operation
            `ALUOpauipc: ALUResult = PC + (imm32 << 12); // AUIPC operation
            `ALUOpecall: begin
                ALUResult = 32'd0; // ecall does not need to compute anything
            end
            default: ALUResult = 0; // Default case handles unexpected ALU operations
        endcase

    always @ (*)
        if(ALUOp == `ALUOpB)
            case(funct3)
                3'h0: Condition = ($signed(ALUResult) == 0) ? 1'b1 : 1'b0;
                3'h4: Condition = ($signed(ALUResult) < 0) ? 1'b1 : 1'b0;
                3'h5: Condition = ($signed(ALUResult) >= 0) ? 1'b1 : 1'b0;
                3'h6: Condition = ($signed(ALUResult) < 0) ? 1'b1 : 1'b0;
                3'h7: Condition = ($signed(ALUResult) >= 0) ? 1'b1 : 1'b0;
                default: Condition = 1'b0;
            endcase    
        else
            Condition = 1'b0; // Set condition flag to 0 for non-branch instructions
endmodule
