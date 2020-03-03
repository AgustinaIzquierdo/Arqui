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
    parameter NB_address_registros=$clog2(cantidad_registros),
    parameter NB_sign_extend = 16
)
(
  input i_clk,
  input i_rst,
  input [len-1:0] i_instruccion,
  input [len-1:0] i_write_data, //Ver de donde viene
  output [len-1:0] o_dato1,
  output [len-1:0] o_dato2,
  output [len-1:0] o_sign_extend
);

wire [NB_address_registros-1:0] write_reg;

assign o_sign_extend = (i_instruccion[15]==1) ? {{(16){1'b1}},i_instruccion[15:0]}: {{(16){1'b0}},i_instruccion[15:0]};

//control

//registers
 banco_registros
 #(
    .len(len),
    .cantidad_registros(cantidad_registros),
    .NB_address_registros(NB_address_registros)
 )
 (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_read_reg_1(i_instruccion[25:21]),
    .i_read_reg_2(i_instruccion[20:16]),
    .i_write_reg(write_reg),
    .i_write_data(i_write_data),
    .i_reg_write_ctrl(), //Control 
    .o_read_data_1(o_dato1),
    .o_read_data_2(o_dato2)
 );
 
  mux
 #(
    .len(len)
  )
  u_mux
  (
    .i_a(i_instruccion[20:16]),
    .i_b(i_instruccion[15:11]),  
    .i_selector(),  //Aca va la linea de control RegDst
    .o_mux(write_reg)
  );

endmodule
