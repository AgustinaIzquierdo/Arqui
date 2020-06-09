`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2020 09:59:13
// Design Name: 
// Module Name: alu_control
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


module alu_control
#(
    parameter NB_ALU_CONTROL = 4,
    parameter NB_ALU_OP = 2,
    parameter NB_INSTRUCCION = 6
)
(
    input [NB_INSTRUCCION-1:0] i_inst_funcion,
    input [NB_INSTRUCCION-1:0] i_opcode,
    input [NB_ALU_OP-1:0] i_alu_op,
    output reg [NB_ALU_CONTROL-1:0] o_alu_code
);

always @(*)
begin
    case(i_alu_op)
        2'b00: //ld o sw
        begin
            o_alu_code = 4'b0110; //addu
        end
        
        2'b01: //branch
        begin
            o_alu_code = 4'b0111; //subu
        end
        
        2'b10: //Tipo-R
        begin
            case(i_inst_funcion)
                6'b000000: o_alu_code = 4'b0000; //sll
                6'b000010: o_alu_code = 4'b0001; //srl
                6'b000011: o_alu_code = 4'b0010; //sra
                6'b000100: o_alu_code = 4'b0000; //sllv
                6'b000110: o_alu_code = 4'b0001; //srlv
                6'b000111: o_alu_code = 4'b0010; //srav
                6'b100001: o_alu_code = 4'b0110; //addu
                6'b100011: o_alu_code = 4'b0111; //subu
                6'b100100: o_alu_code = 4'b1000; //and
                6'b100101: o_alu_code = 4'b1001; //or
                6'b100110: o_alu_code = 4'b1010; //xor
                6'b100111: o_alu_code = 4'b1011; //nor
                6'b101010: o_alu_code = 4'b1100; //slt
                default: o_alu_code = 4'b0110;
            endcase
        end
        2'b11:
        begin
            case(i_opcode)
                6'b001000: o_alu_code=4'b0100; //addi
                6'b001100: o_alu_code=4'b1000; //andi
                6'b001101: o_alu_code=4'b1001; //ori
                6'b001110: o_alu_code=4'b1010; //xori
                6'b001111: o_alu_code=4'b0011; //lui
                6'b001010: o_alu_code=4'b1100; //slti
                default: o_alu_code = 4'b1000; 
            endcase
        end
        default: o_alu_code = 4'b0110;
    endcase
end

endmodule
