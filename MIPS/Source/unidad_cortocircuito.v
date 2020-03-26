`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2020 11:05:14
// Design Name: 
// Module Name: unidad_cortocircuito
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


module unidad_cortocircuito
#(
    parameter LEN = 32,
    parameter NB_ADDRESS_REGISTROS=5  
)
(
    input [NB_ADDRESS_REGISTROS-1:0] i_rs_id_ex,
    input [NB_ADDRESS_REGISTROS-1:0] i_rt_id_ex,
    input [NB_ADDRESS_REGISTROS-1:0] i_write_reg_ex_mem,
    input [NB_ADDRESS_REGISTROS-1:0] i_write_reg_mem_wb, 
    input i_reg_write_ex_mem,
    input i_reg_write_mem_wb,
    output reg [1:0] o_muxA_alu,
    output reg [1:0] o_muxB_alu
);

    always @(*)
    begin
        if((i_reg_write_mem_wb==1'b1) & (i_rs_id_ex==i_write_reg_mem_wb) & (i_reg_write_ex_mem==1'b0 | i_write_reg_ex_mem!=i_rs_id_ex))
            o_muxA_alu = 2'b10;
        else if(i_reg_write_ex_mem==1'b1 & (i_rs_id_ex==i_write_reg_ex_mem))
            o_muxA_alu = 2'b01;
        else
            o_muxA_alu = 2'b00;
            
        if((i_reg_write_mem_wb==1'b1) & (i_rt_id_ex==i_write_reg_mem_wb) & (i_reg_write_ex_mem==1'b0 | i_write_reg_ex_mem!=i_rt_id_ex))
            o_muxB_alu = 2'b10;
        else if(i_reg_write_ex_mem==1'b1 & (i_rt_id_ex==i_write_reg_ex_mem))
            o_muxB_alu = 2'b01;
        else
            o_muxB_alu = 2'b00;
    end

endmodule
