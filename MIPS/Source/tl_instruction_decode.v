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
    parameter LEN = 32,
    parameter CANTIDAD_REGISTROS=32,
    parameter NB_ADDRESS_REGISTROS=$clog2(CANTIDAD_REGISTROS),
    parameter NB_SIGN_EXTEND = 16,
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
  input [LEN-1:0] i_instruccion,
  input [LEN-1:0] i_write_data, //Ver de donde viene
  input [NB_ADDRESS_REGISTROS-1:0] i_write_reg,
  input [LEN-1:0] i_adder_pc,
  input i_RegWrite,
  output reg [LEN-1:0] o_adder_pc,
  output reg [NB_ADDRESS_REGISTROS-1:0] o_rs,
  output reg [NB_ADDRESS_REGISTROS-1:0] o_rd,
  output reg [NB_ADDRESS_REGISTROS-1:0] o_rt,
  output reg [NB_ADDRESS_REGISTROS-1:0] o_shamt,
  output [LEN-1:0] o_dato1,
  output [LEN-1:0] o_dato2,
  output reg [LEN-1:0] o_sign_extend,
  output reg [NB_CTRL_WB-1:0] o_ctrl_wb,//RegWrite Y MemtoReg
  output reg [NB_CTRL_MEM-1:0] o_ctrl_mem,//Branch , MemRead Y MemWrite
  output reg [NB_CTRL_EX-1:0] o_ctrl_ex // RegDst , ALUSrc, Jump y alu_code(4)
);

//Cables-Reg hacia/desde banco de registros 
wire [NB_ADDRESS_REGISTROS-1:0] rs;
wire [NB_ADDRESS_REGISTROS-1:0] rt;

//Cables-Reg hacia/desde unidad de control
wire [NB_INSTRUCCION-1:0] opcode;
wire [NB_INSTRUCCION-1:0] funct;
wire [NB_CTRL_WB-1:0] ctrl_wb;
wire [NB_CTRL_WB-1:0] ctrl_mem;
wire [NB_CTRL_WB-1:0] ctrl_ex;

wire [NB_ADDRESS_REGISTROS-1:0] rd;
wire [NB_SIGN_EXTEND-1:0] address;
wire [LEN-1:0] sign_extend;
wire [NB_ADDRESS_REGISTROS-1:0] shamt;



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
    .LEN(LEN),
    .CANTIDAD_REGISTROS(CANTIDAD_REGISTROS),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)
 )
 u_banco_registros
 (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_read_reg_1(rs),
    .i_read_reg_2(rt),
    .i_write_reg(i_write_reg),
    .i_write_data(i_write_data),
    .i_reg_write_ctrl(i_RegWrite),  
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
