`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.02.2020 16:32:10
// Design Name: 
// Module Name: alu
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


module alu
#(
    parameter LEN=32,
    parameter NB_ALU_CONTROL=4
)
(
    input [LEN-1:0] i_datoA,
    input [LEN-1:0] i_datoB,
    input [NB_ALU_CONTROL-1:0] i_opcode,
    output reg [LEN-1:0] o_result,
    output reg o_zero_flag
);

always @(*)
	begin
		o_zero_flag = 0;

		case (i_opcode)
		    4'b 0000: o_result = i_datoB << i_datoA; //SLL SLLV (shift left)
		    4'b 0001: o_result = i_datoB >> i_datoA; //SRL SRLV (right logico)
		    4'b 0010: o_result = i_datoB >>> i_datoA; //SRA SRAV(right aritmetico)
		    4'b 0011: o_result = i_datoB << 16; //LUI //PROBAR QUE NO SEA CIRCULAR SI NO CONCATENAR 00
		    4'b 0110: o_result = i_datoA + i_datoB; //ADDU
			4'b 0111: 
			begin
			     o_result = i_datoA - i_datoB; //SUBU
			     o_zero_flag = (i_datoA==i_datoB) ? 1'b1 : 1'b0; //BRANCH
            end
			4'b 1000: o_result = i_datoA & i_datoB; //AND
			4'b 1001: o_result = i_datoA | i_datoB; //OR
			4'b 1010: o_result = i_datoA ^ i_datoB; // XOR
			4'b 1011: o_result = ~(i_datoA | i_datoB); //NOR		
			4'b 1100: o_result = i_datoA < i_datoB; //SLT
			default: o_result = 0;
		endcase	
	end

    
endmodule
