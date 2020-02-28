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
    parameter cantidad_registros=32,
    parameter NB=$clog2(cantidad_registros),
    parameter NB_sign_extend = 16
)
(
  input i_clk,
  input i_rst,
  input [len-1:0] i_instruccion
);

//control

//registers
 banco_registros
 #(
    .len(len),
    .cantidad_registros(cantidad_registros),
    .NB_address_registros(NB)
 )
 (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_read_reg_1(i_instruccion[25:21]),
    .i_read_reg_2(i_instruccion[20:16]),
    .i_write_reg(),
    .i_write_data(),
    .o_read_data_1(),
    .o_read_data_2()
 );

endmodule
