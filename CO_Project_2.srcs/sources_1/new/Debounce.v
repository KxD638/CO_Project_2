`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/03 01:47:37
// Design Name: 
// Module Name: Debounce
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


module Debounce(
    input clk,//较快的时钟信号
    input rst,
    input signal_in,
    output reg signal_out
    );
    
    reg last_signal;
    
    always @(posedge clk, negedge rst) begin
        if(~rst) begin
            last_signal <= 1'b0;
            signal_out <= 1'b0;
        end
        else begin
            if(signal_in && !last_signal) begin
                signal_out <= 1'b1;
            end
            else if(!signal_in && last_signal) begin
                signal_out <= 1'b0;
            end
            last_signal <= signal_in;
        end
    end
endmodule
