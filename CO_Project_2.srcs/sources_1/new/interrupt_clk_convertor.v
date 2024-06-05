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


//�ж�ʱ����DMemory��Writeback�м��жϣ��ָ�ʱҲ��������׶�
//���ڶ�������������Ҫ��Registerд���ݣ���Ҫ��Writeback֮ǰ������д������������Ҫ��IFetch��DMemory����߼������źţ���Ҫ��IFetch֮�󣬲���Ҫ��һ��ʱ�䣬ֱ���ź��ȶ�
//���ڻָ�����Ȼ�Ǵ��ĶϵĴ��Ļָ�������Ҳ������׶�
module interrupt_clk_convertor(
    input cpuclk,
    input cntclk,
    input rst,
    input enter,//ȷ�ϼ�
    input interrupt,//�ж��źţ���Ҫ�ж�ʱ1'b1������MemorIO
    output reg inter_ack//�ж�ȷ���źţ�ֻ����Ϊ1'b1ʱ����Ŵ����ж�״̬
    );
    
    wire enter_out;//�������ȷ�ϼ�
    
    Debounce udb(cntclk, rst, enter, enter_out);
    
    reg active;//��ʵ�Ǹ�ʹ���źţ���interrupt��enter�������ʧЧ����
    
    wire enter_final = enter_out && active;//����ʹ�õ�enter�ź�
    
    reg [31:0] enter_cnt;//��������Ϊ�������루λ��Ӧ���ǳ��ˣ���û��Ҫ���̫�ϸ�
    
    parameter period = 32'd50_000_000;//about 2s����λ����Ҳ���ˣ�
    
    //������
    always @(posedge cpuclk, negedge rst, posedge active) begin
        if(~rst || active)
            enter_cnt <= 32'h0000_0000;
        else if(enter_cnt == 32'hffffffff)
            enter_cnt <= 32'h0000_0000;
        else
            enter_cnt <= enter_cnt + 1;
    end
    
    reg firstTime;//�жϿ��ܳ����ܶ����ڣ���ťҲ���ܰ��ܶ����ڣ�����Ҫ�ж��Ƿ��һ��toggle��������ǵ�һ�ξͲ�Ӧ��toggle
    always @(negedge cntclk, negedge rst) begin
        //��ʱ������պ����е�DMemory��Writeback�м䣬DMemory������߼�����ź�Ӧ���Ѿ��ȶ�
        if(~rst) begin
            inter_ack <= 1'b0;
            firstTime <= 1'b1;
            active <= 1'b1;
        end
        else begin
            if(interrupt && (cpuclk == 1'b0) && firstTime || enter_final && (cpuclk == 1'b0) && ~firstTime) begin//�����Լ���һ������ʱ���źűȽϺ����
                inter_ack <= ~inter_ack;
                firstTime <= ~firstTime;
                active <= 1'b0;
            end
            else begin
                inter_ack <= inter_ack;
                if(enter_cnt >= period) active <= 1'b1;//��������ͼ���active��enter������Ч��
            end
        end
    end
    
endmodule
