`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_decode_monociclo
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


module tb_instruction_decode_monociclo();

localparam len=32;
localparam cantidad_registros=32;
localparam NB_address_registros= $clog2(cantidad_registros);
localparam NB_sign_extend = 16;
localparam NB_INSTRUCCION = 6;
localparam NB_ALU_CONTROL = 4;
localparam NB_ALU_OP = 2;
localparam NB_CTRL_WB = 2;
localparam NB_CTRL_MEM = 3;
localparam NB_CTRL_EX = 7;

reg clk;
reg rst;
reg [len-1:0] instr;
reg [len-1:0] write_data_banco_reg;
wire [len-1:0] dato1;
wire [len-1:0] dato2;
wire [len-1:0] sign_extend;
wire [NB_ALU_CONTROL-1:0] alu_control;
wire [NB_address_registros-1:0] write_reg;
wire [len-1:0] adder_pc_if;
wire [len-1:0] adder_pc_id;
wire RegWrite;
wire [NB_address_registros-1:0] rs;
wire [NB_address_registros-1:0] rd;
wire [NB_address_registros-1:0] rt;
wire [NB_address_registros-1:0] shamt;
wire [NB_CTRL_WB-1:0] ctrl_wb;
wire [NB_CTRL_MEM-1:0] ctrl_mem;
wire [NB_CTRL_EX-1:0] ctrl_ex;


initial
begin
    clk = 1'b0;
    rst = 1'b0;
    //instr =32'b00000000001000100001100000100000; //TIPO R suma
    write_data_banco_reg =32'b0;
    #10 rst= 1'b1; //Desactiva el reset
    //#10 instr=32'b00000000100000110010000000100010; //TIPO R resta
    //instr=32'b10001100001000101000000000100000; //TIPO LOAD
    //instr=32'b10101100001000100000000000000000; //TIPO SW
    instr=32'b00010000010000100000000000010000; //TIPO BRANCH
    #500 $finish;
end


always #2.5 clk=~clk;


tl_instruction_decode
#(
    .len(len),
    .cantidad_registros(cantidad_registros),
    .NB_address_registros(NB_address_registros),
    .NB_sign_extend(NB_sign_extend),
    .NB_INSTRUCCION(NB_INSTRUCCION),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX)
)
    u_tl_instruction_decode
(
    .i_clk(clk),
    .i_rst(rst),
    .i_instruccion(instr),
    .i_write_data(write_data_banco_reg),
    .i_write_reg(write_reg),
    .i_adder_pc(adder_pc_if),
    .i_RegWrite(RegWrite),
    .o_adder_pc(adder_pc_id),
    .o_rs(rs),
    .o_rd(rd),
    .o_rt(rt),
    .o_shamt(shamt),
    .o_dato1(dato1),
    .o_dato2(dato2),
    .o_sign_extend(sign_extend),
    .o_ctrl_wb(ctrl_wb),
    .o_ctrl_mem(ctrl_mem),
    .o_ctrl_ex(ctrl_ex)
);

endmodule
