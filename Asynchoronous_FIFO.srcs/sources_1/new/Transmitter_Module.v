`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 15:34:09
// Design Name: 
// Module Name: Transmitter_Module
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


module Transmitter_Module(Write_Clk,Write_Pointer,Write_Full,Write_Data ,W_inc );//this Module send the data to the FIFO basically write data will be sent from here
    input Write_Clk;
    input [15:0]Write_Pointer;//points the location where the data is getting extracted
    input Write_Full;
    output reg[15:0]Write_Data;//Data in the corresponding location
    output reg W_inc=0;
    integer i;
    reg [15:0]input_memory[255:0];//Having input word size of 15 bits and 255 words
initial
    for(i=0;i<255;i=i+1)
    input_memory[i]=i;
    
    always@(posedge Write_Clk)
    if(Write_Full==0&&Write_Pointer<255)
    begin
    Write_Data=input_memory[Write_Pointer];
    W_inc=1;
end
    else
    begin
    W_inc=0;
    Write_Data=0;
    end
endmodule
