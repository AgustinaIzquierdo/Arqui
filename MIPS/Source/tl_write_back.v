`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 11:51:14
// Design Name: 
// Module Name: tl_write_back
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

module tl_write_back
    #(
        parameter LEN = 32,
        parameter NB_CTRL_WB = 2,
        parameter NB_ADDRESS_REGISTROS = 5
    )
    (
        input [LEN-1:0] i_read_data,
        input [LEN-1:0] i_result_alu,
        input [NB_CTRL_WB-1:0] i_ctrl_wb,//RegWrite Y MemtoReg
        input [NB_ADDRESS_REGISTROS-1:0] i_write_reg,
        output [LEN-1:0] o_write_data,
        output [NB_ADDRESS_REGISTROS-1:0] o_write_reg,
        output o_RegWrite
    );

//Cables de la senial de control mem
wire memtoReg;

assign memtoReg = i_ctrl_wb[0];

assign o_write_reg = i_write_reg;
assign o_RegWrite = i_ctrl_wb[1];

//Cables-Reg hacia/desde mux    
mux
#(
    .LEN(LEN)
)
u_mux
(
    .i_a(i_result_alu),
    .i_b(i_read_data),
    .i_selector(memtoReg), //i_ctrl_wb[0]
    .o_mux(o_write_data)
);
endmodule
