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
			4'b 0000: o_result = i_datoA & i_datoB; //AND
			4'b 0001: o_result = i_datoA | i_datoB; //OR
			4'b 0010: o_result = i_datoA + i_datoB; //ADD
			4'b 0110: 
			begin
			     o_result = i_datoA - i_datoB; //SUBTRACT
			     o_zero_flag = (i_datoA==i_datoB) ? 1'b1 : 1'b0; //BRANCH
            end
			4'b 0111: 
				o_result = i_datoA < i_datoB; //SLT
			default: o_result = 0;
		endcase	
	end

    
endmodule
