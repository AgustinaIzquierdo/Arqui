`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2020 16:45:31
// Design Name: 
// Module Name: tb_top_mips
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


module tb_top_mips();
`define LEN 32
`define CANTIDAD_REGISTROS 32
`define NB_ADDRESS_REGISTROS $clog2(CANTIDAD_REGISTROS)
`define NB_SIGN_EXTEND  16
`define NB_INSTRUCCION  6
`define NB_ALU_CONTROL  4       
`define NB_ALU_OP  2
`define INIT_FILE_IM "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/test12.txt"

//Tamanio de los latches 
`define NB_IF_ID  64
`define NB_ID_EX  192
`define NB_EX_MEM  128
`define NB_MEM_WB  64

//Tamanio de los registros de control
`define NB_CTRL_WB  2
`define NB_CTRL_MEM  9
`define NB_CTRL_EX 11 

//Parametros
parameter LEN = `LEN;
parameter CANTIDAD_REGISTROS = `CANTIDAD_REGISTROS;
parameter NB_ADDRESS_REGISTROS = `NB_ADDRESS_REGISTROS;
parameter NB_SIGN_EXTEND = `NB_SIGN_EXTEND;
parameter NB_INSTRUCCION = `NB_INSTRUCCION;
parameter NB_ALU_CONTROL = `NB_ALU_CONTROL;
parameter NB_ALU_OP = `NB_ALU_OP;
parameter INIT_FILE_IM = `INIT_FILE_IM;

                                                            //(Ver si realmente son estos los tamanios)
parameter NB_IF_ID = `NB_IF_ID; 
parameter NB_ID_EX = `NB_ID_EX; 
parameter NB_EX_MEM = `NB_EX_MEM; 
parameter NB_MEM_WB = `NB_MEM_WB; 

                                                           //(Ver si realmente son estos los tamanios)
parameter NB_CTRL_WB = `NB_CTRL_WB; 
parameter NB_CTRL_MEM = `NB_CTRL_MEM; 
parameter NB_CTRL_EX = `NB_CTRL_EX; 

//Cables hacia/desde instruction_fetch 
wire [LEN-1:0] branch_dir;
wire PCSrc;
wire [LEN-1:0] instruccion;
wire [LEN-1:0] out_adder_if_id;

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

reg i_clk, i_rst;

initial
begin
    i_clk = 1'b0;
    i_rst = 1'b0;
    #10 i_rst= 1'b1; //Desactiva el reset
    
    
    #500 $finish;
end

always #2.5 i_clk=~i_clk;

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
    .o_instruccion(instruccion),
    .o_adder(out_adder_if_id)
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
    .i_instruccion(instruccion),
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
    .o_flag_jump(flag_jump)
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
    .i_address(result_alu_ex_mem),
    .i_write_data(dato2_ex_mem),
    .i_ctrl_wb(ctrl_wb_ex_mem),
    .i_ctrl_mem(ctrl_mem_ex_mem),
    .i_alu_zero(alu_zero),
    .i_write_reg(write_reg_ex_mem),
    .o_address(result_alu_mem_wb),  
    .o_read_data(read_data_memory),
    .o_write_reg(write_reg_mem_wb),
    .o_ctrl_wb(ctrl_wb_mem_wb),
    .o_PCSrc(PCSrc) //Branch, indica si se hace el flush
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
