`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 15:33:37
// Design Name: 
// Module Name: FIFO
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


module FIFO(
Write_Clk,write_rst,Read_clk,read_rst,Data_out,w_full,w_empty
    );
    
    input Write_Clk,write_rst;
    input Read_clk,read_rst;
    output [15:0]Data_out;
    output w_full,w_empty;
    
    
    parameter Data_width=16;
    parameter FIFO_Depth_address_lines=5;
    parameter FIFO_Depth_Size=1<<FIFO_Depth_address_lines;
    reg [Data_width-1:0]Write_pointer;
    reg [Data_width-1:0]Read_pointer;
    reg Clk_en,W_Full;
    wire W_inc;
    reg Empty,Full;//for checking Empty and full conditions
    wire [Data_width-1:0]Write_Data;
    //defining Synchronizing Signals
    reg[Data_width-1:0] Transmission_ptr;   
    reg [FIFO_Depth_address_lines:0]Write_pointer_1_Sync,Write_pointer_2_Sync;
    reg [FIFO_Depth_address_lines:0]Read_pointer_1_Sync,Read_pointer_2_Sync,Read_pointer_grey,Write_pointer_grey;
    wire [FIFO_Depth_address_lines:0]Read_pointer_bin;
    wire [FIFO_Depth_address_lines:0]Write_pointer_bin;
    
    reg [Data_width-1:0]FIFO_Mem[FIFO_Depth_Size-1:0];//Fifo memory definition
    //Instatitating the Transmitter Module Over Here
    Transmitter_Module M1( Write_Clk,Transmission_ptr,Full,Write_Data,W_inc);
    
    //write pointer updation and definition is done here
    always@(posedge write_rst, posedge Write_Clk)
       begin
         if(write_rst)
             begin
                 Write_pointer<=0;//reseting the write pointer when given reset signal
                 Transmission_ptr<=0;
              end
         else if(Full==0&&W_inc)
             begin
                 Write_pointer<=Write_pointer+1;
                 Transmission_ptr<=Transmission_ptr+1;
                 FIFO_Mem[Write_pointer[FIFO_Depth_address_lines-1:0]]<=Write_Data;
             end
         end
   //read pointer updation is done here
      always@(posedge read_rst, posedge Read_clk)
       begin
         if(read_rst)
             Read_pointer<=0;//reseting the write pointer when given reset signal
         else
             begin
                 Read_pointer<=Read_pointer+1;
             end
         end
//read 2 bit synchronizer
always@(*)
    begin
        Read_pointer_1_Sync<=Read_pointer_grey;
        Read_pointer_2_Sync<=Read_pointer_1_Sync;
    end
    
    
//write 2 bit synchronizer
always@(*)
    begin
        Write_pointer_1_Sync<=Write_pointer_grey;
        Write_pointer_2_Sync<=Write_pointer_1_Sync;
    end







   //checking for Full condition
   always@(*)
   begin
       if({~Write_pointer[FIFO_Depth_address_lines],Write_pointer[FIFO_Depth_address_lines-1:0]}==Read_pointer_bin)
            Full=1;
        else
            Full=0;
    end
    
       //checking for Empty condition
   always@(*)
   begin
       if(Read_pointer==Write_pointer_bin)
            Empty=1;
        else
            Empty=0;
    end
//for conversion of  binary to grey
   always@(*)
       begin  
           Read_pointer_grey=Read_pointer^(Read_pointer>>1);
           Write_pointer_grey=Write_pointer^(Write_pointer>>1);
        end
   
//    //for_Checking Full condition
//    always@(posedge Write_Clk)
//        if(Write_pointer==Write_pointer_bin)
//            W_Full=1;
//        else
//            W_Full=0;
                  
                  assign w_full=Full;
                  assign w_empty=Empty;
assign Data_out= FIFO_Mem[Read_pointer[FIFO_Depth_address_lines-1:0]];
                  
integer i;   
         
//always@(posedge Write_Clk)//for conversion of grey to binary
//    begin
//        for(i=FIFO_Depth_Size-1;i>0;i=i-1)
//        begin
//            if(i==FIFO_Depth_Size-1)
//                begin
//                     Write_pointer_bin[i]=Write_pointer_2_Sync[i];
//                      Read_pointer_bin[i]=Read_pointer_2_Sync[i];
//                      $monitor(Read_pointer_2_Sync[i]);
//                 end
//             else
//                 begin
//                      Write_pointer_bin[i]=(Write_pointer_2_Sync[i])^Write_pointer_bin[i+1];
//                      Read_pointer_bin[i]=(Read_pointer_2_Sync[i])^Read_pointer_bin[i+1];
////                      $display(Write_pointer_2_Sync[i]);
//                  end
//        end
//    end        
            
            
            
            
            
            
            
            ///Gray to Binary---write pointer
	
	assign Write_pointer_bin[5]=Write_pointer_2_Sync[5];
	assign Write_pointer_bin[4]=Write_pointer_2_Sync[4] ^ Write_pointer_bin[5];
	assign Write_pointer_bin[3]=Write_pointer_2_Sync[3] ^ Write_pointer_bin[4];
	assign Write_pointer_bin[2]=Write_pointer_2_Sync[2] ^ Write_pointer_bin[3];
	assign Write_pointer_bin[1]=Write_pointer_2_Sync[1] ^ Write_pointer_bin[2];
	assign Write_pointer_bin[0]=Write_pointer_2_Sync[0] ^ Write_pointer_bin[1];
	 
	 
	 ////Gray to Binary----Read pointer
	assign Read_pointer_bin[5]=Read_pointer_2_Sync[5];
	assign Read_pointer_bin[4]=Read_pointer_2_Sync[4] ^ Read_pointer_bin[5];
	assign Read_pointer_bin[3]=Read_pointer_2_Sync[3] ^ Read_pointer_bin[4];
	assign Read_pointer_bin[2]=Read_pointer_2_Sync[2] ^ Read_pointer_bin[3];
	assign Read_pointer_bin[1]=Read_pointer_2_Sync[1] ^ Read_pointer_bin[2];
	assign Read_pointer_bin[0]=Read_pointer_2_Sync[0] ^ Read_pointer_bin[1];
            
            
            
            
            
            
endmodule
