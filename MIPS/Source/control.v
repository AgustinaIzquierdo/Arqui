`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2020 09:55:36
// Design Name: 
// Module Name: control
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


module control
#(  parameter NB_INSTRUCCION = 6,
    parameter NB_SENIAL_CONTROL = 8,
    parameter NB_ALU_CONTROL = 4,
    parameter NB_ALU_OP = 2
)
(
    input [NB_INSTRUCCION-1:0] i_opcode,
    input [NB_INSTRUCCION-1:0] i_inst_funcion,
    output reg [NB_SENIAL_CONTROL-1:0] o_senial_control,
    output [NB_ALU_CONTROL-1:0] o_alu_control
);
//senial_control[0]=RegDst
//senial_control[1]=Jump
//senial_control[2]=Branch
//senial_control[3]=MemRead
//senial_control[4]=MemtoReg
//senial_control[5]=MemWrite
//senial_control[6]=ALUSrc
//senial_control[7]=RegWrite

reg [NB_ALU_OP-1:0] alu_op;

always @(*)
begin
    case(i_opcode)
        6'b000000: //Tipo-R
        begin
            alu_op = 2'b10;
            o_senial_control = 8'b10000001;
        end
        
        6'b100011: // Tipo-Load
        begin
            alu_op = 2'b00;
            o_senial_control = 8'b11011000;
        end
        
        6'b101011: // Tipo-Store
        begin
            alu_op = 2'b00;
            o_senial_control = 8'b01100000;
        end
        
        6'b000100: // Tipo-branch
        begin
            alu_op = 2'b01;
            o_senial_control = 8'b00000100;
        end
        
        6'b000010: // Tipo-Jump
        begin
            alu_op = 2'b00;
            o_senial_control = 8'b00000010;
        end
    endcase
end

//ALU_CONTROL
alu_control
#(
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP),
    .NB_INSTRUCCION(NB_INSTRUCCION)
)
u_alu_control
(
    .i_inst_funcion(i_inst_funcion),
    .i_alu_op(alu_op),
    .o_alu_code(o_alu_control)
);
endmodule
