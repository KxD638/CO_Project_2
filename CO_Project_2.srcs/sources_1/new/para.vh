//how to use��`R
`define R 7'h33
    `define fun3addsub 3'h0
        `define fun7add 7'h00
        `define fun7sub 7'h20
    `define fun3or 3'h6
    `define fun3and 3'h7
    `define fun3sll 3'h1
`define I 7'h13
    `define fun3addi 3'h0
    `define fun3slli 3'h1
    `define fun3xori 3'h4
    `define fun3srli 3'h5
`define L 7'h03
    `define fun3lb 3'h0
    `define fun3lw 3'h2
    `define fun3lbu 3'h4
`define S 7'h23
`define B 7'h63
    `define fun3beq 3'h0
    `define fun3blt 3'h4
    `define fun3bge 3'h5
    `define fun3bltu 3'h6
    `define fun3bgeu 3'h7
`define J 7'h6f
//U type opcode ��ͳһ
`define lui 7'h37
`define auipc 7'h17
`define SYSTEM 7'h73
    `define fun3ecall 3'h0
    
//ALUOp: IL/S 000, B 001, R 010, I 011, J 100, lui 101, auipc 110
`define ALUOpLS 3'b000
`define ALUOpL 3'b000
`define ALUOpS 3'b000
`define ALUOpB 3'b001
`define ALUOpR 3'b010
`define ALUOpI 3'b011
`define ALUOpJ 3'b100
`define ALUOplui 3'b101
`define ALUOpauipc 3'b110
`define ALUOpecall 3'b111