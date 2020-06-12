`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2020 10:14:20
// Design Name: 
// Module Name: top_gral
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

//Tamanio de los latches 
`define NB_IF_ID  65
`define NB_ID_EX  204
`define NB_EX_MEM  112
`define NB_MEM_WB  72

`define LEN 32
`define CANT_REG 16
`define CANT_MEM 8


parameter LEN = `LEN;
parameter CANT_REG = `CANT_REG;
parameter CANT_MEM = `CANT_MEM;
parameter NB_IF_ID = `NB_IF_ID; 
parameter NB_ID_EX = `NB_ID_EX; 
parameter NB_EX_MEM = `NB_EX_MEM; 
parameter NB_MEM_WB = `NB_MEM_WB; 


module top_gral
(

);

top_mips 
#(
   .LEN(LEN),
   .NB_IF_ID(NB_IF_ID),
   .NB_ID_EX(NB_ID_EX),
   .NB_EX_MEM(NB_EX_MEM),
   .NB_MEM_WB(NB_MEM_WB),
   .CANT_REG(CANT_REG),
   .CANT_MEM(CANT_MEM)
   
)
    u_top_mips
(
    .i_clk(),
    .i_rst(),
    .dir_mem_instr(),
    .wea_mem_instr(),
    .addr_mem_inst(),
    .o_if_id(),
    .o_id_ex(),
    .o_ex_mem(),
    .o_mem_wb()
);

endmodule
