`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_memory_monociclo
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


module tb_instruction_memory_monociclo();

localparam LEN=32;
localparam NB_ADDRESS_REGISTROS = 5;
localparam NB_CTRL_WB = 2;
localparam NB_CTRL_MEM = 3;

reg clk;
reg rst;
reg [LEN-1:0] address_ex;
reg [LEN-1:0] write_data;
reg [NB_CTRL_WB-1:0] ctrl_wb_ex;
reg [NB_CTRL_MEM-1:0] ctrl_mem_ex;
reg alu_zero_ex;            
reg [NB_ADDRESS_REGISTROS-1:0] write_reg_ex;
wire [LEN-1:0] address_mem;
wire [LEN-1:0] read_data_mem;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_mem;
wire [NB_CTRL_WB-1:0] ctrl_wb_mem;
wire PCSrc;

initial
begin
    clk = 1'b0;
    rst = 1'b1;
    address_ex = 32'b0;
    write_data = 32'b0;
    ctrl_wb_ex = 2'b0;
    ctrl_mem_ex = 3'b0;
    alu_zero_ex = 1'b0;
    write_reg_ex = 5'b0;
    
//    #10 i_address=32'h00000003;    //LOAD
//        i_write_data=32'h00000010;
//        i_senial_control=8'b11011000;
    
//    #10 i_address=32'h00000002;    //STORE
//        i_write_data=32'h00000110;
//        i_senial_control=8'b01100000;
    
    #500 $finish;
end


always #2.5 clk=~clk;


tl_memory
#(
    .LEN(LEN),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM)
)
    u_tl_memory
(
    .i_clk(clk),
    .i_rst(rst),
    .i_address(address_ex),
    .i_write_data(write_data),
    .i_ctrl_wb(ctrl_wb_ex),
    .i_ctrl_mem(ctrl_mem_ex),
    .i_alu_zero(alu_zero_ex),
    .i_write_reg(write_reg_ex),
    .o_address(address_mem),
    .o_read_data(read_data_mem),
    .o_write_reg(write_reg_mem),
    .o_ctrl_wb(ctrl_wb_mem),
    .o_PCSrc(PCSrc)
);

endmodule
