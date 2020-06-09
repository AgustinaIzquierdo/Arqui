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

//`define LEN 32
`define CANTIDAD_REGISTROS 32
`define NB_ADDRESS_REGISTROS $clog2(CANTIDAD_REGISTROS)
`define NB_SIGN_EXTEND  16
`define NB_INSTRUCCION  6
`define NB_ALU_CONTROL  4       
`define NB_ALU_OP  2
`define INIT_FILE_IM "" 
//"/home/anij/facu/Arquitectura_de_Computadoras/agus-arqui/Arqui/MIPS/Source/instruction_memory.txt"
//gil:  "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/instruction_memory.txt"

//Tamanio de los latches 
//`define NB_IF_ID  96
//`define NB_ID_EX  160
//`define NB_EX_MEM  128
//`define NB_MEM_WB  96

//Tamanio de los registros de control
`define NB_CTRL_WB  2
`define NB_CTRL_MEM  9
`define NB_CTRL_EX 11

module top_mips
#(
    parameter LEN = 32,
    parameter NB_IF_ID = 96,
    parameter NB_ID_EX = 160,
    parameter NB_EX_MEM = 128,
    parameter NB_MEM_WB = 96,
    parameter CANT_REG = 16,
    parameter CANT_MEM = 8  
)
(
    input i_clk,
    input i_rst,
    input i_debug_flag,
    input [$clog2(CANT_REG)-1:0] i_addr_reg_reco, //Recolector 
    input [$clog2(CANT_MEM)-1:0] i_addr_memdatos_reco, //Recolector
    input [LEN-1:0] dir_mem_instr,
    input wea_mem_instr,
    input [LEN-1:0] addr_mem_inst,
    output [NB_IF_ID-1:0] o_if_id,
    output [NB_ID_EX-1:0] o_id_ex,
    output [NB_EX_MEM-1:0] o_ex_mem,
    output [NB_MEM_WB-1:0] o_mem_wb,
    output [LEN-1:0] o_reg_recolector, //Recolector
    output [LEN-1:0] o_mem_datos_recolector, //Recolector
    output o_debug_halt //Debug
);

//Parametros
//parameter LEN = `LEN;
localparam CANTIDAD_REGISTROS = `CANTIDAD_REGISTROS;
localparam NB_ADDRESS_REGISTROS = `NB_ADDRESS_REGISTROS;
localparam NB_SIGN_EXTEND = `NB_SIGN_EXTEND;
localparam NB_INSTRUCCION = `NB_INSTRUCCION;
localparam NB_ALU_CONTROL = `NB_ALU_CONTROL;
localparam NB_ALU_OP = `NB_ALU_OP;
localparam INIT_FILE_IM = `INIT_FILE_IM;

                                                            //(Ver si realmente son estos los tamanios)
//parameter NB_IF_ID = `NB_IF_ID; 
//parameter NB_ID_EX = `NB_ID_EX; 
//parameter NB_EX_MEM = `NB_EX_MEM; 
//parameter NB_MEM_WB = `NB_MEM_WB; 

                                                           //(Ver si realmente son estos los tamanios)
localparam NB_CTRL_WB = `NB_CTRL_WB; 
localparam NB_CTRL_MEM = `NB_CTRL_MEM; 
localparam NB_CTRL_EX = `NB_CTRL_EX; 

//Cables hacia/desde instruction_fetch 
wire [LEN-1:0] branch_dir;
wire PCSrc;
wire [LEN-1:0] instruccion;
wire [LEN-1:0] out_adder_if_id;
wire [LEN-1:0] contador_programa;
wire flag_halt;

//Cables hacia/desde instruction_decode 
wire [LEN-1:0] write_data_banco_reg;
wire [LEN-1:0] out_adder_id_exe;
wire [NB_ADDRESS_REGISTROS-1:0] rs;
wire [NB_ADDRESS_REGISTROS-1:0] rd;
wire [NB_ADDRESS_REGISTROS-1:0] rt;
wire [NB_ADDRESS_REGISTROS-1:0] shamt;
wire [LEN-1:0] dato1;
wire [LEN-1:0] dato2_if_ex;
wire [LEN-1:0] sign_extend;
wire [NB_CTRL_WB-1:0] ctrl_wb_id_ex;
wire [NB_CTRL_MEM-1:0] ctrl_mem_id_ex;
wire [NB_CTRL_EX-1:0] ctrl_ex_id_ex;
wire flag_stall;
wire [LEN-1:0] dir_jump;
wire flag_jump;

//Cables hacia/desde execute 
wire [LEN-1:0] dato2_ex_mem;
wire [LEN-1:0] result_alu_ex_mem;
wire alu_zero;
wire [NB_CTRL_WB-1:0] ctrl_wb_ex_mem;
wire [NB_CTRL_MEM-1:0] ctrl_mem_ex_mem;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_ex_mem;

//Cables hacia/desde memoria
wire [LEN-1:0] result_alu_mem_wb;
wire [LEN-1:0] read_data_memory;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_mem_wb;
wire [NB_CTRL_WB-1:0] ctrl_wb_mem_wb;

//Cables hacia/desde wb
wire regwrite_wb_id;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_wb_id;

//Cables hacia/desde Unidad de cortocircuito
wire [1:0] ctrl_muxA_corto;
wire [1:0] ctrl_muxB_corto;


assign o_debug_halt = flag_halt;

//Latches intermedios
assign o_if_id = {
                  contador_programa, //32 bits
                  instruccion,//32 bits
                  {31{1'b0}},
                  flag_halt //1bits
                  }; 

assign o_id_ex = { 
                   {10{1'b0}},
                   ctrl_wb_id_ex,  //2bits
                   ctrl_mem_id_ex, //9bits
                   ctrl_ex_id_ex,  //11 bits
                   {12{1'b0}},
                   shamt, //5 bits
                   rs,  //5 bits
                   rt,  //5 bits
                   rd,   //5 bits
                   out_adder_id_exe, //32 bits
                   dir_jump,         //32bits 
                   sign_extend,      //32 bits
                   dato1,            //32 bits
                   dato2_if_ex,       //32 bits
                   flag_stall
                  };   
                   
assign o_ex_mem = {
                   {15{1'b0}},
                   ctrl_wb_ex_mem, //2bits
                   ctrl_mem_ex_mem, //9bits
                   alu_zero, //1 bit
                   write_reg_ex_mem, //5bit
                   branch_dir,//32 bits
                   result_alu_ex_mem,//32 bits
                   dato2_ex_mem //32 bits
                   };

assign o_mem_wb = {
                   {25{1'b0}},
                   ctrl_wb_mem_wb, //2 bits
                   write_reg_mem_wb, //5 bits
                   result_alu_mem_wb,//32 bits
                   read_data_memory //32 bits
                   };

//Instruction fetch
tl_instruction_fetch
#(
    .LEN(LEN),
    .INIT_FILE_IM(INIT_FILE_IM)
)
    u_tl_instruction_fetch
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_branch_dir(branch_dir),
    .i_PCSrc(PCSrc),
    .i_flag_stall(flag_stall),
    .i_flag_jump(flag_jump),
    .i_dir_jump(dir_jump),
    .i_dir_mem_instr(dir_mem_instr),
    .i_wea_mem_instr(wea_mem_instr),
    .i_addr_mem_inst(addr_mem_inst),
    .o_instruccion(instruccion),
    .o_adder(out_adder_if_id),
    .o_contador_programa(contador_programa), //DEBUG_UNIT
    .o_flag_halt(flag_halt)
);

//Instruction decode
tl_instruction_decode
#(
    .LEN(LEN),
    .CANTIDAD_REGISTROS(CANTIDAD_REGISTROS),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS),
    .NB_SIGN_EXTEND(NB_SIGN_EXTEND),
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
    .i_instruccion(i_debug_flag? {{7{1'b0}},i_addr_reg_reco,{21{1'b0}}}: instruccion),
    .i_write_data(write_data_banco_reg),
    .i_write_reg(write_reg_wb_id),
    .i_adder_pc(out_adder_if_id),
    .i_RegWrite(regwrite_wb_id),
    .i_flush(PCSrc), 
    .o_adder_pc(out_adder_id_exe), 
    .o_rs(rs),
    .o_rd(rd),
    .o_rt(rt),    
    .o_shamt(shamt),   
    .o_dato1(dato1),
    .o_dato2(dato2_if_ex),
    .o_sign_extend(sign_extend),
    .o_ctrl_wb(ctrl_wb_id_ex), //RegWrite Y MemtoReg
    .o_ctrl_mem(ctrl_mem_id_ex), //BranchNotEqual, SB, SH, LB, LH, Unsigned , Branch , MemRead Y MemWrite
    .o_ctrl_ex(ctrl_ex_id_ex), //JAL,Jump, JR, JALR,RegDst ,Jump,RegDst ,ALUSrc1(MUX de la entrada A de la ALU), ALUSrc2(MUX de la entrada B de la ALU) y alu_code(4)
    .o_flag_stall(flag_stall),
    .o_dir_jump(dir_jump),
    .o_flag_jump(flag_jump),
    .o_reg_reco(o_reg_recolector)
);

//Execute
tl_execute
#(
    .LEN(LEN),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX)
    
)
    u_tl_execute
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_adder_id(out_adder_id_exe),
    .i_dato1(dato1),
    .i_dato2(dato2_if_ex),
    .i_sign_extend(sign_extend),
    .i_ctrl_wb(ctrl_wb_id_ex),
    .i_ctrl_mem(ctrl_mem_id_ex),
    .i_ctrl_ex(ctrl_ex_id_ex),
    .i_rd(rd),
    .i_rt(rt),
    .i_shamt(shamt),
    .i_ctrl_muxA_corto(ctrl_muxA_corto),
    .i_ctrl_muxB_corto(ctrl_muxB_corto),
    .i_rd_mem_corto(result_alu_ex_mem),
    .i_rd_wb_corto(write_data_banco_reg),
    .i_flush(PCSrc),
    .o_alu_zero(alu_zero),
    .o_write_reg(write_reg_ex_mem),
    .o_ctrl_wb(ctrl_wb_ex_mem),
    .o_ctrl_mem(ctrl_mem_ex_mem),
    .o_pc_branch(branch_dir),
    .o_alu_result(result_alu_ex_mem),
    .o_dato2(dato2_ex_mem)
);

//Memory
tl_memory
#(
    .LEN(LEN),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)

)
    u_tl_memory
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_address(i_debug_flag? {{29{1'b0}},i_addr_memdatos_reco} : result_alu_ex_mem),
    .i_write_data(dato2_ex_mem),
    .i_ctrl_wb(ctrl_wb_ex_mem),
    .i_ctrl_mem(ctrl_mem_ex_mem),
    .i_alu_zero(alu_zero),
    .i_write_reg(write_reg_ex_mem),
    .o_address(result_alu_mem_wb),  
    .o_read_data(read_data_memory),
    .o_write_reg(write_reg_mem_wb),
    .o_ctrl_wb(ctrl_wb_mem_wb),
    .o_PCSrc(PCSrc), //Branch, indica si se hace el flush
    .o_mem_reco(o_mem_datos_recolector) 
);

//Write Back
tl_write_back
#(
    .LEN(LEN),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)
  
)
    u_tl_write_back
(
    .i_read_data(read_data_memory),
    .i_result_alu(result_alu_mem_wb),
    .i_ctrl_wb(ctrl_wb_mem_wb),
    .i_write_reg(write_reg_mem_wb),
    .o_write_data(write_data_banco_reg),
    .o_write_reg(write_reg_wb_id),
    .o_RegWrite(regwrite_wb_id)
);

unidad_cortocircuito
#(
    .LEN(LEN),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)
)
u_unidad_corto
(
   .i_rs_id_ex(rs),
   .i_rt_id_ex(rt),
   .i_write_reg_ex_mem(write_reg_ex_mem),
   .i_write_reg_mem_wb(write_reg_wb_id), 
   .i_reg_write_ex_mem(ctrl_wb_ex_mem[1]),
   .i_reg_write_mem_wb(regwrite_wb_id),
   .o_muxA_alu(ctrl_muxA_corto),
   .o_muxB_alu(ctrl_muxB_corto)
);
endmodule
