`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 22:20:35
// Design Name: 
// Module Name: Test_fifo
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


module Test_fifo(  );
    reg Write_Clk,write_rst;
    reg Read_clk,read_rst;
//    reg [15:0]Read_Data;
    wire [15:0]Data_out;
    wire w_full,w_empty;
FIFO F1(Write_Clk,write_rst,Read_clk,read_rst,Data_out,w_full,w_empty);

initial begin
		// Initialize Inputs
		Read_clk = 0;
		Write_Clk = 0;
		write_rst = 1;read_rst=1;
		#4write_rst = 0;read_rst=0;
		#3000 $finish;
	end
		
		always begin
		#5 Write_Clk = ~Write_Clk;
		end
		always begin
		#10 Read_clk = ~Read_clk;
		end


endmodule
