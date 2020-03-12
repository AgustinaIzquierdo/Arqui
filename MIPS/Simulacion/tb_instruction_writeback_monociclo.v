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
localparam NB_SENIAL_CONTROL = 8;

reg [len-1:0] read_data_memory;
reg [len-1:0] result_alu;
reg [NB_SENIAL_CONTROL-1:0] senial_control;
wire [len-1:0] write_data_banco_reg;

initial
begin
    
    #10 read_data_memory=32'h00000003;    //LOAD
        result_alu=32'h00000010;
        senial_control=8'b11011000;
    
    #10 read_data_memory=32'h00000002;    //R
        result_alu=32'h00000110;
        senial_control=8'b10000001;
    
    #500 $finish;
end

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

