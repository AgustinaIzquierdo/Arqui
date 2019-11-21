`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2019 11:08:40
// Design Name: 
// Module Name: cpu
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

`define NB_OPCODE 5
`define NB_DECODER_SEL_A 2

// PARAMETERS
parameter NB_OPCODE          = `NB_OPCODE;
parameter NB_DECODER_SEL_A          = `NB_DECODER_SEL_A;

module cpu
#(
    parameter NB_ADDR = 11,
    parameter NB_OPERANDO = 11,
    parameter RAM_WIDTH = 16
)
(
    i_clk,
    i_rst,
    i_instruction_pm, //Program Memory
    o_addr_pm
);

//PUERTOS
input i_clk;
input i_rst;
input [RAM_WIDTH-1:0] i_instruction_pm;
output [NB_ADDR-1:0] o_addr_pm;

// VARIABLES
wire [NB_DECODER_SEL_A-1:0] selA;
wire selB;
wire wrAcc;
wire op;
wire wrRam;
wire rdRam;

    control
#(
    .NB_OPCODE(NB_OPCODE),
    .NB_ADDR(NB_ADDR),
    .NB_DECODER_SEL_A(NB_DECODER_SEL_A)
)
    u_control
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_opcode(i_instruction_pm [ (RAM_WIDTH-1) -: NB_OPCODE]), 
    .o_addr(o_addr_pm),
    .o_selA(selA),
    .o_selB(selB),
    .o_wrAcc(wrAcc),
    .o_op(op),
    .o_wrRam(wrRam),
    .o_rdRam(rdRam)
);

    datapath
#(

)
    u_datapath
(

);
endmodule