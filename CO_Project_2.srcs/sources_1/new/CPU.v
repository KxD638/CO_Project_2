`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 03:19:48
// Design Name: 
// Module Name: CPU
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


module CPU(
    input fpga_clk,//clk
    input rst,//fpga_rst
    input enter,//5个通用按键平常是低电平，按下是高电平，和RST相反
    input [7:0] io_rdata,//IO input
    //input [3:0] test_switch,
    //input start_pg,
    //input rx,
    //output tx,
    output [7:0] led,
    output [7:0] seg_en,//chip select signal 
    output [7:0] seg_out0,//段选信号（七段加一点分别是否亮起）
    output [7:0] seg_out1
    );
    // UART Programmer Pinouts
    //wire upg_clk, upg_clk_o;
    //wire upg_wen_o; //Uart write out enable
    //wire upg_done_o; //Uart rx data have done
        //data to which memory unit of program_rom/dmemory32
    //wire [14:0] upg_adr_o;
        //data to program_rom or dmemory32
    //wire [31:0] upg_dat_o;

    wire [31:0] imm32;
    wire Branch;
    wire Condition;
    wire Jump;
    wire [31:0] inst;
    wire [31:0] PC;
    
    wire MemorIORead;
    wire MemorIOtoReg;
    wire [2:0] ALUOp;
    wire MemorIOWrite;
    wire ALUSrc;
    wire RegWrite;
    
    wire [31:0] writeData;
    wire [31:0] rs1Data;
    wire [31:0] rs2Data;
    
    wire [31:0] ALUResult;
    
    wire cpu_clk;

    
    wire [31:0] io_wdata;
    wire LEDCtrl;
    wire segCtrl;

    //wire spg_bufg;

    //BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    //reg upg_rst;
    //always @ (posedge fpga_clk) begin
    //if (spg_bufg) upg_rst <= 0;
    //if (fpga_rst) upg_rst <= 1;
    //end
    //used for other modules which don't relate to UART
//    wire rst;
//    assign rst = fpga_rst | !upg_rst;

//    uart_bmpg_0 Uart(
//        .upg_clk_i(upg_clk),
//        .upg_rst_i(upg_rst),
//        .upg_rx_i(rx),
//        .upg_clk_o(upg_clk_o),
//        .upg_wen_o(upg_wen_o),
//        .upg_adr_o(upg_adr_o),
//        .upg_dat_o(upg_dat_o),
//        .upg_done_o(upg_done_o),
//        .upg_tx_o(tx)
//    );
    
    //wire db_clk;//clk for Debouncing,100MHz
    wire cntclk;
    
    //cpuclk ucpuclk(.clk_in1(fpga_clk), .clk_out1(cpu_clk),.clk_out2(upg_clk), .clk_out3(cntclk));//, .clk_out3(db_clk)
    cpuclk ucpuclk(.clk_in1(fpga_clk), .clk_out1(cpu_clk), .clk_out2(cntclk));
    
    wire interrupt;
    
    wire inter_ack;
    
    interrupt_clk_convertor uclkconv(.cpuclk(cpu_clk), .cntclk(cntclk), .rst(rst), .enter(enter), .interrupt(interrupt), .inter_ack(inter_ack));
    
    IFetch uIFetch(
        .clk(cpu_clk), 
        .rst(rst), 
        .inter_ack(inter_ack),
        .relative_offset(ALUResult), //由于是伪单周期，这里需要把ALUResult直接拿过来，来不及等MemorIO
        .Branch(Branch), 
        .Condition(Condition), 
        .Jump(Jump), 
        .inst(inst), 
        .PC(PC)
        // UART Programmer Pinouts
//        .upg_rst_i(upg_rst),
//        .upg_clk_i(upg_clk_o),
//        .upg_wen_i(upg_wen_o),
//        .upg_adr_i(upg_adr_o[13:0]), // Assuming the address width matches
//        .upg_dat_i(upg_dat_o),
//        .upg_done_i(upg_done_o)
    );
    
    //wire triggerException;
    
    Controller uController(.op(inst[6:0]), .Jump(Jump), .Branch(Branch), .MemorIORead(MemorIORead), .MemorIOtoReg(MemorIOtoReg), 
    .ALUOp(ALUOp), .MemorIOWrite(MemorIOWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));//, .triggerException(triggerException)
    
    Decoder uDecoder(.clk(cpu_clk), .rst(rst), .inter_ack(inter_ack), .RegWrite(RegWrite), .inst(inst), .writeData(writeData), .rs1Data(rs1Data), .rs2Data(rs2Data), .imm32(imm32));
    
    ALU uALU(.rs1Data(rs1Data), .rs2Data(rs2Data), .imm32(imm32), .ALUSrc(ALUSrc), .ALUOp(ALUOp), .funct3(inst[14:12]), .funct7(inst[31:25]), 
    .PC(PC), .ALUResult(ALUResult), .Condition(Condition));
    
    MemOrIO uMemIO(
        .clk(cpu_clk), 
        .MemorIORead(MemorIORead), 
        .MemorIOWrite(MemorIOWrite), 
        .r_rdata(rs1Data), 
        .ALUResult(ALUResult), 
        .MemorIOtoReg(MemorIOtoReg), 
        .r_wdata(writeData),
        .io_rdata(io_rdata), // 8-bit IO input
        .io_wdata(io_wdata), 
        .LEDCtrl(LEDCtrl), 
        .segCtrl(segCtrl),
        // UART Programmer Pinouts
//        .upg_rst_i(upg_rst),
//        .upg_clk_i(upg_clk_o),
//        .upg_wen_i(upg_wen_o),
//        .upg_adr_i(upg_adr_o),
//        .upg_dat_i(upg_dat_o),
//        .upg_done_i(upg_done_o),
        .interrupt(interrupt),
        .fun3(inst[14:12])
    );
    
    LED uled(.clk(cpu_clk), .rst(rst), .LEDCtrl(LEDCtrl), .io_wdata(io_wdata), .led(led));
    //这俩输出连cpu_clk就行了，中断的时候这俩需要正常的时钟信号
    scan_seg useg(.rst(rst), .clk(cpu_clk), .segCtrl(segCtrl), .content(io_wdata), .seg_en(seg_en), .seg_out0(seg_out0), .seg_out1(seg_out1));
    //这里应该视情况修改模块内部的时钟频率，使得人眼分辨不出来七段数码管实际上同时只亮一个

endmodule
