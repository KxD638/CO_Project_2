`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/03 03:31:58
// Design Name: 
// Module Name: interrupt_clk_convertor
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


//中断时会在DMemory和Writeback中间中断，恢复时也是在这个阶段
//对于读操作，由于需要往Register写数据，需要在Writeback之前；对于写操作，由于需要从IFetch到DMemory组合逻辑部分信号，需要在IFetch之后，并且要等一段时间，直至信号稳定
//至于恢复，当然是从哪断的从哪恢复，所以也在这个阶段
module interrupt_clk_convertor(
    input cpuclk,
    input cntclk,
    input rst,
    input enter,//确认键
    input interrupt,//中断信号，需要中断时1'b1，来自MemorIO
    output reg inter_ack//中断确认信号，只有它为1'b1时程序才处于中断状态
    );
    
    wire enter_out;//消抖后的确认键
    
    Debounce udb(cntclk, rst, enter, enter_out);
    
    reg active;//其实是个使能信号，当interrupt或enter触发后会失效两秒
    
    wire enter_final = enter_out && active;//最终使用的enter信号
    
    reg [31:0] enter_cnt;//计数器，为了数两秒（位宽应该是超了，但没必要算的太严格）
    
    parameter period = 32'd50_000_000;//about 2s（这位宽多半也超了）
    
    //数两秒
    always @(posedge cpuclk, negedge rst, posedge active) begin
        if(~rst || active)
            enter_cnt <= 32'h0000_0000;
        else if(enter_cnt == 32'hffffffff)
            enter_cnt <= 32'h0000_0000;
        else
            enter_cnt <= enter_cnt + 1;
    end
    
    reg firstTime;//中断可能持续很多周期，按钮也可能按很多周期，所以要判断是否第一次toggle，如果不是第一次就不应该toggle
    always @(negedge cntclk, negedge rst) begin
        //此时，程序刚好运行到DMemory和Writeback中间，DMemory的组合逻辑输出信号应该已经稳定
        if(~rst) begin
            inter_ack <= 1'b0;
            firstTime <= 1'b1;
            active <= 1'b1;
        end
        else begin
            if(interrupt && (cpuclk == 1'b0) && firstTime || enter_final && (cpuclk == 1'b0) && ~firstTime) begin//这里自己画一下两个时钟信号比较好理解
                inter_ack <= ~inter_ack;
                firstTime <= ~firstTime;
                active <= 1'b0;
            end
            else begin
                inter_ack <= inter_ack;
                if(enter_cnt >= period) active <= 1'b1;//数够两秒就激活active，enter键又有效了
            end
        end
    end
    
endmodule
