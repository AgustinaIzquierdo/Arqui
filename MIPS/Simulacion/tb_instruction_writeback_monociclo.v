`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_writeback_monociclo
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


module tb_instruction_writeback_monociclo();

localparam len=32;
localparam NB_CTRL_WB = 2;
localparam NB_ADDRESS_REGISTROS = 5; 

reg [len-1:0] read_data_memory;
reg [len-1:0] result_alu;
reg [NB_CTRL_WB-1:0] ctrl_wb;
reg [NB_ADDRESS_REGISTROS-1:0] write_reg_mem;
wire [len-1:0] write_data_banco_reg;
wire [len-1:0] write_reg_wb;
wire RegWrite;

initial
begin
    
//    #10 read_data_memory=32'h00000003;    //LOAD
//        result_alu=32'h00000010;
//        senial_control=8'b11011000;
    
//    #10 read_data_memory=32'h00000002;    //R
//        result_alu=32'h00000110;
//        senial_control=8'b10000001;
    
    #500 $finish;
end

tl_write_back
#(
    .len(len),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)
)
    u_tl_write_back
(
    .i_read_data(read_data_memory),
    .i_result_alu(result_alu),
    .i_ctrl_wb(ctrl_wb),
    .i_write_reg(write_reg_mem),
    .o_write_data(write_data_banco_reg),
    .o_write_reg(write_reg_wb),
    .o_RegWrite(RegWrite)
);


endmodule

