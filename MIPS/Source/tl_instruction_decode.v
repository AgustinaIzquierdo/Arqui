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
    parameter NB_sign_extend = 16,
    parameter NB_INSTRUCCION = 6,
    parameter NB_SENIAL_CONTROL = 8,
    parameter NB_ALU_CONTROL = 4,
    parameter NB_ALU_OP = 2,
    parameter NB_CTRL_WB = 2,
    parameter NB_CTRL_MEM = 3,
    parameter NB_CTRL_EX = 7
)
(
  input i_clk,
  input i_rst,
  input [len-1:0] i_instruccion,
  input [len-1:0] i_write_data, //Ver de donde viene
  input [len-1:0] i_adder_pc,
  input i_RegWrite,
  input [NB_address_registros-1:0] i_write_reg,
  output reg [len-1:0] o_adder_pc,
  output reg [NB_address_registros-1:0] o_rs,
  output reg [NB_address_registros-1:0] o_rd,
  output reg [NB_address_registros-1:0] o_rt,
  output reg [NB_address_registros-1:0] o_shamt,
  output [len-1:0] o_dato1,
  output [len-1:0] o_dato2,
  output reg [len-1:0] o_sign_extend,
  output reg [NB_CTRL_WB-1:0] o_ctrl_wb,//RegWrite Y MemtoReg
  output reg [NB_CTRL_MEM-1:0] o_ctrl_mem,//Branch , MemRead Y MemWrite
  output reg [NB_CTRL_EX-1:0] o_ctrl_ex // RegDst , ALUSrc, Jump y alu_code(4)
);

wire [NB_address_registros-1:0] rs;
wire [NB_address_registros-1:0] rd;
wire [NB_address_registros-1:0] rt;
wire [NB_address_registros-1:0] shamt;
wire [len-1:0] sign_extend;

wire [NB_INSTRUCCION-1:0] opcode;
wire [NB_INSTRUCCION-1:0] funct;
wire [NB_sign_extend-1:0] address;

wire [NB_CTRL_WB-1:0] ctrl_wb;
wire [NB_CTRL_WB-1:0] ctrl_mem;
wire [NB_CTRL_WB-1:0] ctrl_ex;

assign opcode = i_instruccion[31:26];

assign rs = i_instruccion[25:21];

assign rt = i_instruccion[20:16];

assign rd = i_instruccion[15:11];

assign shamt = i_instruccion[11:6];

assign funct = i_instruccion[5:0];

assign address = i_instruccion[15:0];

assign sign_extend = (i_instruccion[15]==1) ? {{(16){1'b1}},address}: {{(16){1'b0}},address};

 always @(negedge i_clk)
 begin
    if(!i_rst)
    begin
        o_adder_pc <= 32'b0;
        o_rs <= 5'b0;
        o_rd <= 5'b0;
        o_rt <= 5'b0;
        o_sign_extend <= 32'b0;
        o_shamt <= 5'b0;
    end
    else
    begin
        o_adder_pc <= i_adder_pc;
        o_rs <= rs;
        o_rd <= rd;
        o_rt <= rt;
        o_sign_extend <= sign_extend;
        o_shamt <= shamt;
    end
 end

//registers
 banco_registros
 #(
    .len(len),
    .cantidad_registros(cantidad_registros),
    .NB_address_registros(NB_address_registros)
 )
 u_banco_registros
 (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_read_reg_1(rs),
    .i_read_reg_2(rt),
    .i_write_reg(i_write_reg),
    .i_write_data(i_write_data),
    .i_reg_write_ctrl(i_RegWrite), //RegWrite 
    .o_read_data_1(o_dato1),
    .o_read_data_2(o_dato2)
 );
 
// mux
// #(
//    .len(NB_address_registros)
//  )
//  u_mux_decode
//  (
//    .i_a(rt),
//    .i_b(rd),  
//    .i_selector(o_senial_control[0]),  //RegDst
//    .o_mux(write_reg)
//  );
  
control
#(
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP),
    .NB_INSTRUCCION(NB_INSTRUCCION),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX)
)
u_control
(
    .i_inst_funcion(funct),
    .i_opcode(opcode),
    .o_ctrl_wb(ctrl_wb),
    .o_ctrl_mem(ctrl_mem),
    .o_ctrl_ex(ctrl_ex)
);

endmodule
