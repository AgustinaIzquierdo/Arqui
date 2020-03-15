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
    parameter len = 32,
    parameter NB_SENIAL_CONTROL = 8,
    parameter NB_ALU_CONTROL = 4    
)
(
    input i_clk,
    input i_rst,
    input [len-1:0] i_adder_id,
    input [len-1:0] i_dato1,
    input [len-1:0] i_dato2,
    input [len-1:0] i_sign_extend,
    input [NB_SENIAL_CONTROL-1:0] i_senial_control, //En un futuro no salen todas estas, va depender de la segmentacion
    input [NB_ALU_CONTROL-1:0] i_alu_control,
    output reg [len-1:0] o_add_execute,    
    output reg [len-1:0] o_alu_result,
    output reg [len-1:0] o_dato2,
    output o_PCSrc
); //Falta el cero flag y el mux, y el control//////////////////////////////////!!!

// El shift_left_2 deberia ir?
    wire [len-1:0] mux_alu;
    wire alu_zero;
    wire [len-1:0] add_execute;
    wire [len-1:0] alu_result;
    
assign o_PCSrc = i_senial_control[2] && alu_zero;

always @(negedge i_clk)
begin
    if(!i_rst)
    begin
        o_add_execute <= 32'b0;
        o_alu_result <= 32'b0;
        o_dato2 <= 32'b0;
    end
    else
    begin
        o_add_execute <= add_execute;
        o_alu_result <= alu_result;
        o_dato2 <= i_dato2;
    end  
end
    
adder
#(  
    .len(len)
)
u_add
(
    .i_a(i_adder_id),
    .i_b(i_sign_extend),
    .o_adder(add_execute)
);

mux
#(  
    .len(len)
)
u_mux
(
    .i_a(i_dato2),
    .i_b(i_sign_extend),
    .i_selector(i_senial_control[6]), //AluScr
    .o_mux(mux_alu)   
);

alu
#(
    .NB_alu_control(NB_ALU_CONTROL), //Ver que ponemos
    .len(len)
)
u_alu
(
    .i_datoA(i_dato1),
    .i_datoB(mux_alu),
    .i_opcode(i_alu_control), //Control
    .o_result(alu_result),
    .o_zero_flag(alu_zero) //Con el controool
    
);

endmodule
