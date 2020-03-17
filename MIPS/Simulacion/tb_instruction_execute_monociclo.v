`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_execute_monociclo
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


module tb_instruction_execute_monociclo();

localparam LEN=32;
localparam NB_ADDRESS_REGISTROS = 5;
localparam NB_ALU_CONTROL = 4;
localparam NB_CTRL_WB = 2;
localparam NB_CTRL_MEM = 3;
localparam NB_CTRL_EX = 7;

reg clk;
reg rst;
reg [LEN-1:0] adder_id;
reg [LEN-1:0] dato1_id;
reg [LEN-1:0] dato2_id;
reg [LEN-1:0] sign_extend_id;
reg [NB_CTRL_WB-1:0] ctrl_wb_id;
reg [NB_CTRL_MEM-1:0] ctrl_mem_id;
reg [NB_CTRL_EX-1:0] ctrl_ex_id;
reg [NB_ADDRESS_REGISTROS-1:0] rd_id;
reg [NB_ADDRESS_REGISTROS-1:0] rt_id;
wire alu_zero_ex;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_ex;
wire [NB_CTRL_WB-1:0] ctrl_wb_ex;
wire [NB_CTRL_MEM-1:0] ctrl_mem_ex; 
wire [LEN-1:0] branch_dir_ex;
wire [LEN-1:0] result_alu_ex;
wire [LEN-1:0] dato2_ex;

initial
begin
    clk = 1'b0;
    rst = 1'b0;
    adder_id = 32'b0;
    dato1_id = 32'b0;
    dato2_id = 32'b0;
    sign_extend_id = 32'b0;
    ctrl_wb_id = 2'b0;
    ctrl_mem_id = 3'b0;
    ctrl_ex_id = 7'b0;
    rd_id = 5'b0;
    rt_id = 5'b0;
    #10 rst= 1'b1;
    #500 $finish;
end


always #2.5 clk=~clk;

tl_execute
#(
    .LEN(LEN),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX)
)
    u_tl_execute
(
    .i_clk(clk),
    .i_rst(rst),
    .i_adder_id(adder_id),
    .i_dato1(dato1_id),
    .i_dato2(dato2_id),
    .i_sign_extend(sign_extend_id),
    .i_ctrl_wb(ctrl_wb_id),
    .i_ctrl_mem(ctrl_mem_id),
    .i_ctrl_ex(ctrl_ex_id),
    .i_rd(rd_id),
    .i_rt(rt_id),
    .o_alu_zero(alu_zero_ex),
    .o_write_reg(write_reg_ex),
    .o_ctrl_wb(ctrl_wb_ex),
    .o_ctrl_mem(ctrl_mem_ex),
    .o_add_execute(branch_dir_ex),
    .o_alu_result(result_alu_ex),
    .o_dato2(dato2_ex)
);

endmodule
