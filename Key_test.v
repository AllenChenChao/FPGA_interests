`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//抢答器 4 路 Arty-Z7 board
//////////////////////////////////////////////////////////////////////////////////
module KEY_test(
                input clk,//输入时钟100M
                input rst_n_in,
                input IO0,
                input IO1,
                input IO2,
                input IO3,
                input [3:0]       key_in,//按键输入
                output reg [3:0]  led
                );
reg [ 3:0] key_scan;
reg [31:0] cnt;  
reg IO0_scan;
reg IO1_scan;
reg IO2_scan;
reg IO3_scan;
always @(posedge clk_50M or negedge rst_n)
    if(!rst_n)
        begin
        key_scan <= 4'd0;
        cnt <= 32'd0;
        end
    else
        begin
            if(cnt == 32'd999)//每20us扫描一次按键
                begin
                    key_scan <= key_in;
                    IO0_scan <= IO0;//每20ms扫描一次IO0
                    IO1_scan <= IO1;
                    IO2_scan <= IO2;
                    IO3_scan <= IO3;
                    cnt <= 32'd0;
                end
            else
                begin
                    cnt <= cnt + 32'd1;    
                end
        end
    
reg  [3:0] key_scan_r;//寄存一下按键值
wire [3:0] key_flag;//按键标记
reg IO0_scan_r;
wire IO0_flag;    
reg IO1_scan_r;
wire IO1_flag;  
reg IO2_scan_r;
wire IO2_flag;  
reg IO3_scan_r;
wire IO3_flag;    
reg lock;//加个锁
assign key_flag = key_scan[3:0] & (~key_scan_r[3:0]);//取上升沿
assign IO0_flag = IO0_scan & ~IO0_scan_r;//取上升沿
assign IO1_flag = IO1_scan & ~IO1_scan_r;//取上升沿
assign IO2_flag = IO2_scan & ~IO2_scan_r;//取上升沿
assign IO3_flag = IO3_scan & ~IO3_scan_r;//取上升沿
    
always @(posedge clk_50M)
    begin
        key_scan_r <= key_scan;
        IO0_scan_r <= IO0_scan;
        IO1_scan_r <= IO1_scan;
        IO2_scan_r <= IO2_scan;
        IO3_scan_r <= IO3_scan;
    end

always @(posedge clk_50M or negedge rst_n)
    if(!rst_n)
        begin
            led <= 4'b0000;//LED灯显示高电平点亮
        end
    else
        begin
            if(key_flag[0])//查看按键按下，之后灯状态翻转
                begin
                    led[0] <= ~led[0];
                    lock <= 1;
                end
            
            if(key_flag[1])
                begin
                    led[1] <= ~led[1];
                end
            
            if(key_flag[2])
                begin
                    led[2] <= ~led[2];
                end
            
            if(key_flag[3])
                begin
                    led[3] <= ~led[3];
                end
                
            if(IO0_flag & lock)
                begin
                    led[3] <= 1;
                    lock <= 0;
                end    
             if(IO1_flag & lock)
                begin
                    led[2] <= 1;
                    lock <= 0;
                end     
             if(IO2_flag & lock)
                begin
                    led[1] <= 1;
                    lock <= 0;
                end  
             if(IO3_flag & lock)
                begin
                    led[0] <= 1;
                    lock <= 0;
                end                                         
        end
        
//时钟接口例化 
wire clk;
wire rst_n_in;

wire rst_n;
wire clk_50M;
      
clk_wiz_0 PLL (
                // Clock in ports
                 .clk_in1(clk),      // input clk_in1
                 // Clock out ports
                 .clk_out1(clk_50M),     // output clk_out1
                 // Status and control signals
                 .resetn(rst_n_in), // input resetn
                 .locked(rst_n) // output locked
                 );     

endmodule
