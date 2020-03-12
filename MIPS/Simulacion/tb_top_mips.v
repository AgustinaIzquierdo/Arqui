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
localparam len= 32;
localparam cantidad_registros= 32;
localparam NB_address_registros= $clog2(cantidad_registros);
localparam NB_sign_extend=  16;
localparam NB_INSTRUCCION=  6;
localparam NB_SENIAL_CONTROL=  8;
localparam NB_ALU_CONTROL=  4;
localparam NB_ALU_OP=  2;
localparam INIT_FILE_IM= "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/instruction_memory.txt";

reg i_clk;
reg i_rst;
wire [len-1:0] branch_dir;
wire PCScr;
wire [len-1:0] instruccion;
wire [len-1:0] PC_next;
wire [len-1:0] write_data_banco_reg;
wire [len-1:0] dato1;
wire [len-1:0] dato2;
wire [len-1:0] sign_extend;
wire [NB_SENIAL_CONTROL-1:0] senial_control;
wire [NB_ALU_CONTROL-1:0] alu_control;
wire [len-1:0] result_alu;
wire [len-1:0] read_data_memory;


initial
begin
    i_clk = 1'b0;
    i_rst = 1'b0;
    #10 i_rst= 1'b1; //Desactiva el reset
    
    
    #500 $finish;
end

always #2.5 i_clk=~i_clk;

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
    .i_PCSrc(PCScr),
    .o_instruccion(instruccion),
    .o_adder(PC_next)
);

tl_instruction_decode
#(
    .len(len),
    .cantidad_registros(cantidad_registros),
    .NB_address_registros(NB_address_registros),
    .NB_sign_extend(NB_sign_extend),
    .NB_INSTRUCCION(NB_INSTRUCCION),
    .NB_SENIAL_CONTROL(NB_SENIAL_CONTROL),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP)
)
    u_tl_instruction_decode
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_instruccion(instruccion),
    .i_write_data(write_data_banco_reg),
    .o_dato1(dato1),
    .o_dato2(dato2),
    .o_sign_extend(sign_extend),
    .o_senial_control(senial_control),
    .o_alu_control(alu_control)
);

tl_execute
#(
    .len(len),
    .NB_SENIAL_CONTROL(NB_SENIAL_CONTROL),
    .NB_ALU_CONTROL(NB_ALU_CONTROL)
)
    u_tl_execute
(
    .i_adder_if(PC_next),
    .i_dato1(dato1),
    .i_dato2(dato2),
    .i_sign_extend(sign_extend),
    .i_senial_control(senial_control),
    .i_alu_control(alu_control),
    .o_add_excute(branch_dir),
    .o_alu_result(result_alu),
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
    .i_address(result_alu),
    .i_write_data(dato2),
    .i_senial_control(senial_control),
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
    .i_result_alu(result_alu),
    .i_senial_control(senial_control),
    .o_write_data(write_data_banco_reg)
);
endmodule
