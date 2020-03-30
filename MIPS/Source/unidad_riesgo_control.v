`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2020 09:24:54
// Design Name: 
// Module Name: unidad_riesgo_control
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


module unidad_riesgo_control
#(
        parameter LEN = 32,
        parameter NB_ADDRESS_REGISTROS=5
)
(
    input [LEN-1:0] i_sign_extend,
    input [LEN-1:0] i_adder_pc,
    input [NB_ADDRESS_REGISTROS-1:0] i_rs,
    input [NB_ADDRESS_REGISTROS-1:0] i_rt,
    input [1:0] i_enable_branch,  //BranchNotEqual-BranchEqual
    output o_flag_branch, //flush
    output [LEN-1:0] o_branch
);

//Cables-Reg hacia/desde adder
wire [LEN-1:0] add_execute;

wire flag_zero;

assign flag_zero = (i_rs==i_rt) ? 1'b1 : 1'b0;

assign o_flag_branch = i_enable_branch[0] && ((i_enable_branch[1]) ? (~flag_zero) : (flag_zero));

adder
#(  
    .LEN(LEN)
)
u_add
(
    .i_a(i_adder_pc),
    .i_b(i_sign_extend),
    .o_adder(o_branch)
);

endmodule
