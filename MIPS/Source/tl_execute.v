`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 10:54:28
// Design Name: 
// Module Name: tl_execute
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


module tl_execute
#(  
    parameter len = 32    
)
(
    input i_clk,
    input i_rst,
    input [len-1:0] i_adder_if,
    input [len-1:0] i_dato1,
    input [len-1:0] i_dato2,
    input [len-1:0] i_sign_extend,
    output [len-1:0] o_add_excute,    
    output [len-1:0] o_alu_result,
    output o_alu_zero
);

// El shift_left_2 deberia ir?
    wire [len-1:0] mux_alu;
    
add_execute
#(  
    .len(len)
)
u_add_execute
(
    .i_add_pc(i_adder_if),
    .i_shift_sign_extend(i_sign_extend),
    .o_data(o_add_excute)
);

mux
#(  
    .len(len)
)
u_mux
(
    .i_a(i_dato2),
    .i_b(i_sign_extend),
    .i_selector(), //Señal de control AluScr
    .o_mux(mux_alu)   
);

alu
#(
    .NB_alu_control(), //Ver que ponemos
    .len(len)
)
u_alu
(
    .i_datoA(i_dato1),
    .i_datoB(mux_alu),
    .i_opcode(), //Control
    .o_result(o_alu_result),
    .o_zero_flag(o_alu_zero)
    
);

endmodule
