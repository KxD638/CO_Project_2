`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 19:17:00
// Design Name: 
// Module Name: MemOrIO
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

//modified a lot, greatly different from PPT.
module MemOrIO(//Data Memory and IO are both in this module, ������ΪData Memory��IO��һ�����壬���ڲ���������
    input clk,
    input MemorIORead,//1'b1 while need to read from Data Memory or IO
    input MemorIOWrite,//1'b1 while need to write to Data Memory or IO
    
    input [31:0] r_rdata,//data from Registers, rs1Data
    input[31:0] ALUResult,
    input MemorIOtoReg,//1'b1 while send the data from Data Memory or IO to Registers, 0 while send the data from ALU
//    input upg_rst_i, // UPG reset (Active High)
//    input upg_clk_i, // UPG ram_clk_i (10MHz)
//    input upg_wen_i, // UPG write enable
//    input [14:0] upg_adr_i, // UPG write address
//    input [31:0] upg_dat_i, // UPG write data
//    input upg_done_i, // 1 if programming is finished
    output reg [31:0] r_wdata,//the data send to Registers
    
    input [7:0] io_rdata,//IO input
    output [31:0] io_wdata,//IO output
    
    output LEDCtrl, // 1'b1 if LED need to work 
    output segCtrl, //1'b1 if 7seg need to work
    
    output interrupt,
    
    input [2:0] fun3
);

    //wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    wire mRead; // read memory
    wire mWrite; // write memory
    wire ioRead; // read IO
    wire ioWrite; // write IO
    
    //����Controller�ź��Լ���ַȷ��Data Memory��IO�Ķ�д�źţ�PPT���ǽ���Controller���ģ�����ֱ����ģ���ڲ�ȷ��
    assign mRead = (MemorIORead && ALUResult >= 0 && ALUResult < 32'hFFFFFC00) ? 1'b1 : 1'b0;
    assign ioRead = (MemorIORead && ALUResult >= 32'hFFFFFC00 && ALUResult <= 32'hFFFFFFFF) ?1'b1 : 1'b0;
    assign mWrite = (MemorIOWrite && ALUResult >= 0 && ALUResult < 32'hFFFFFC00)  ? 1'b1 : 1'b0;
    assign ioWrite = (MemorIOWrite && ALUResult >= 32'hFFFFFC00 && ALUResult <= 32'hFFFFFFFF)  ? 1'b1 : 1'b0;
    
    wire [31:0] m_rdata;//��DMem����������
    
//    RAM uram(.clka(kickOff ? ~clk:upg_clk_i), .wea(kickOff ? mWrite:upg_wen_i), .addra(kickOff ? ALUResult[16:2]:upg_adr_i),
//     .dina(kickOff ? r_rdata:upg_dat_i), .douta(m_rdata));
    RAM uram(.clka( ~clk), .wea( mWrite), .addra( ALUResult[15:2]), .dina(r_rdata), .douta(m_rdata)); 
    
    //ȷ��д��Register������
    always @(*)
        if(~MemorIOtoReg) r_wdata = ALUResult;//��������ALU
        else
            if(mRead) begin //���ڴ��ȡ
                case(fun3)
                    `fun3lb: r_wdata = (m_rdata[7] == 1'b0) ? {24'h00_0000, m_rdata[7:0]} : {24'hff_ffff, m_rdata[7:0]};
                    `fun3lbu: r_wdata = {24'h00_0000, m_rdata[7:0]};
                    default: r_wdata = m_rdata;//lw
                endcase
            end
            else begin ;//����IO��ȷ����λ���extend
                case(fun3)
                    `fun3lb: r_wdata = (io_rdata[7] == 1'b0) ? {24'h00_0000, io_rdata} : {24'hff_ffff, io_rdata};
                    `fun3lbu: r_wdata = {24'h00_0000, io_rdata};
                    default: r_wdata = {24'h00_0000, io_rdata};
                endcase
            end
            
    assign io_wdata = r_rdata;
    
    //ֻ��LED��0xFFFFFC00 �� 0xFFFFFCFF
    //������0xFFFFFD00 �� 0xFFFFFDFF
    //ֻ��7seg��>= 0xFFFFFE00
    assign LEDCtrl = ioWrite && ALUResult < 32'hFFFF_FE00;//��Ҫ���LED�Ź���
    assign segCtrl = ioWrite && ALUResult >= 32'hFFFF_FD00;//��Ҫ����߶�����ܲŹ��������Ը�����Ҫ����
    
    assign interrupt = ioRead || ioWrite;
endmodule