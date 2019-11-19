`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2019 10:52:32
// Design Name: 
// Module Name: control
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


module control
#(
    parameter NB_OPCODE = 5,
    parameter NB_PC = 11,
    parameter NB_DECODER_SEL_A = 2
)
(
    input i_clk,
    input i_rst,
    input [NB_OPCODE-1:0] i_opcode,
    output [NB_PC-1:0] o_addr,
    output [NB_DECODER_SEL_A-1:0] o_selA,
    output o_selB,
    output o_wrAcc,
    output o_op,
    output o_wrRam,
    output o_rdRam
);

wire wrPc;

    pc
#(
    .NB_PC(NB_PC)
)
    u_pc
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_enable(wrPc),
    .o_addr(o_addr)
);

    instruction_decoder
#(
    .NB_OPCODE(NB_OPCODE),
    .NB_DECODER_SEL_A(NB_DECODER_SEL_A)
)
    u_instruction_decoder
(
    .i_opcode(i_opcode),
    .o_wrPc(wrPc),
    .o_selA(o_selA),
    .o_selB(o_selB),
    .o_wrAcc(o_wrAcc),
    .o_op(o_op),
    .o_wrRam(o_wrRam),
    .o_rdRam(o_rdRam)
);
endmodule
