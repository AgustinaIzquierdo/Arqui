`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 10:15:58
// Design Name: 
// Module Name: top_mips
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

`define len 32
`define cantidad_registros 32
`define NB_address_registros $clog2(cantidad_registros)
`define NB_sign_extend  16
`define NB_INSTRUCCION  6
`define NB_SENIAL_CONTROL  8
`define NB_ALU_CONTROL  4
`define NB_ALU_OP  2
`define INIT_FILE_IM "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/instruction_memory.txt"

module top_mips
(
    i_clk,
    i_rst,
    o_if_id,
    o_id_ex,
    o_ex_mem,
    o_mem_wb
);

parameter len = `len;
parameter cantidad_registros = `cantidad_registros;
parameter NB_address_registros = `NB_address_registros;
parameter NB_sign_extend = `NB_sign_extend;
parameter NB_INSTRUCCION = `NB_INSTRUCCION;
parameter NB_SENIAL_CONTROL = `NB_SENIAL_CONTROL;
parameter NB_ALU_CONTROL = `NB_ALU_CONTROL;
parameter NB_ALU_OP = `NB_ALU_OP;
parameter INIT_FILE_IM = `INIT_FILE_IM;

parameter NB_IF_ID = 64;
parameter NB_ID_EX = 192;
parameter NB_EX_MEM = 128;
parameter NB_MEM_WB = 64;

parameter NB_CTRL_WB = 2;
parameter NB_CTRL_MEM = 3;
parameter NB_CTRL_EX = 7;
 
wire [len-1:0] branch_dir;
wire PCScr;
wire [len-1:0] instruccion;
wire [len-1:0] out_adder_if_id;
wire [len-1:0] out_adder_id_exe;
wire [NB_address_registros-1:0] rs;
wire [NB_address_registros-1:0] rd;
wire [NB_address_registros-1:0] rt;
wire [NB_address_registros-1:0] shamt;
wire [len-1:0] write_data_banco_reg;
wire [len-1:0] dato1;
wire [len-1:0] dato2_if_ex;
wire [len-1:0] dato2_ex_mem;
wire [len-1:0] sign_extend;
wire [NB_SENIAL_CONTROL-1:0] senial_control;
wire [NB_ALU_CONTROL-1:0] alu_control;
wire [len-1:0] result_alu_mem_wb;
wire [len-1:0] result_alu_ex_mem;
wire [len-1:0] read_data_memory;

wire [NB_CTRL_WB-1:0] ctrl_wb_id_ex;
wire [NB_CTRL_MEM-1:0] ctrl_mem_id_ex;
wire [NB_CTRL_EX-1:0] ctrl_ex_id_ex;

input i_clk;
input i_rst;
output [NB_IF_ID-1:0] o_if_id;
output [NB_ID_EX-1:0] o_id_ex;
output [NB_EX_MEM-1:0] o_ex_mem;
output [NB_MEM_WB-1:0] o_mem_wb;

//Latches intermedios
assign o_if_id = {out_adder_if_id, //32 bits
                  instruccion}; //32 bits
//FALTA CONTROL
assign o_id_ex = {out_adder_id_exe, //32 bits 
                   sign_extend, //32 bits
                   dato1,       //32 bits
                   dato2_if_ex,       //32 bits
                   shamt, //5 bits
                   rs,  //5 bits
                   rt,  //5 bits
                   rd};   //5 bits
assign o_ex_mem = {branch_dir,//32 bits
                   result_alu_ex_mem,//32 bits
                   dato2_ex_mem//32 bits
                   };
assign o_mem_wb = {result_alu_mem_wb,//32 bits
                   read_data_memory //32 bits
                   };

tl_instruction_fetch
#(
    .len(len),
    .INIT_FILE_IM(INIT_FILE_IM)
)
    u_tl_instruction_fetch
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_branch_dir(branch_dir),
    .i_PCScr(PCScr),
    .o_instruccion(instruccion),
    .o_adder(out_adder_if_id)
);

tl_instruction_decode
#(
    .len(len),
    .cantidad_registros(cantidad_registros),
    .NB_address_registros(NB_address_registros),
    .NB_sign_extend(NB_sign_extend),
    .NB_INSTRUCCION(NB_INSTRUCCION),    
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP)
)
    u_tl_instruction_decode
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_instruccion(instruccion),
    .i_write_data(write_data_banco_reg),
    .i_write_reg(),//despues vemo
    .i_RegWrite(),
    .i_adder_pc(out_adder_if_id),
    .o_adder_pc(out_adder_id_exe), 
    .o_rs(rs),
    .o_rd(rd),
    .o_rt(rt),    
    .o_shamt(shamt),   
    .o_dato1(dato1),
    .o_dato2(dato2_if_ex),
    .o_sign_extend(sign_extend),
    .o_ctrl_wb(ctrl_wb_id_ex),
    .o_ctrl_mem(ctrl_mem_id_ex),
    .o_ctrl_ex(ctrl_ex_id_ex)
);

tl_execute
#(
    .len(len),
    .NB_SENIAL_CONTROL(NB_SENIAL_CONTROL),
    .NB_ALU_CONTROL(NB_ALU_CONTROL)
)
    u_tl_execute
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_adder_id(out_adder_id_exe),
    .i_dato1(dato1),
    .i_dato2(dato2_if_ex),
    .i_sign_extend(sign_extend),
    .i_senial_control(senial_control),
    .i_alu_control(alu_control),
    .o_add_execute(branch_dir),
    .o_alu_result(result_alu_ex_mem),
    .o_dato2(dato2_ex_mem),
    .o_PCSrc(PCScr)
);

tl_memory
#(
    .len(len),
    .NB_SENIAL_CONTROL(NB_SENIAL_CONTROL)
)
    u_tl_memory
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_address(result_alu_ex_mem),
    .i_write_data(dato2_if_ex),
    .i_senial_control(senial_control),
    .o_address(result_alu_mem_wb),
    .o_read_data(read_data_memory)
);

tl_write_back
#(
    .len(len),
    .NB_SENIAL_CONTROL(NB_SENIAL_CONTROL)
)
    u_tl_write_back
(
    .i_read_data(read_data_memory),
    .i_result_alu(result_alu_mem_wb),
    .i_senial_control(senial_control),
    .o_write_data(write_data_banco_reg)
);
endmodule
