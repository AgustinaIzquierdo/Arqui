`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 09:57:16
// Design Name: 
// Module Name: tl_instruction_decode
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


module tl_instruction_decode
#(
    parameter len = 32,
    parameter NB = 5,
    parameter NB_sign_extend = 16
)
(
  input i_clk,
  input i_rst,
  input [NB-1:0] i_read1,
  input [NB-1:0] i_read2,
  input [NB-1:0] i_write,
  input [NB_sign_extend-1:0] i_sign_extend,
  input [len-1:0] i_write_data,
  output [len-1:0] o_read_data1,
  output [len-1:0] o_read_data2,
  output [len-1:0] o_sign_extend 
);

//ver creo que irian 2 submodulos, registers y eso
endmodule
