`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.02.2020 16:32:10
// Design Name: 
// Module Name: alu
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


module alu
#(
    parameter len=32,
    parameter NB_alu_control=4 //VER QUE NUMERO
)
(
    input [len-1:0] i_datoA,
    input [len-1:0] i_datoB,
    input [NB_alu_control-1:0] i_opcode,
    output [len-1:0] o_result,
    output o_zero_flag
);
endmodule
