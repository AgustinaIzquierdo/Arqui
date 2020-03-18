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
    input [NB_ALU_OP-1:0] i_alu_op,
    output reg [NB_ALU_CONTROL-1:0] o_alu_code
);

always @(*)
begin
    case(i_alu_op)
        2'b00: //ld o sw
        begin
            o_alu_code = 4'b0010;
        end
        
        2'b01: //branch
        begin
            o_alu_code = 4'b0110;
        end
        
        2'b10: //Tipo-R
        begin
            case(i_inst_funcion)
                6'b100000: //add
                begin
                     o_alu_code = 4'b0010;
                end
                
                6'b100010: //subtract
                begin
                     o_alu_code = 4'b0110;
                end
                
                6'b100100: //and
                begin
                     o_alu_code = 4'b0000;
                end
                
                6'b100101: //or
                begin
                     o_alu_code = 4'b0001;
                end
                
                6'b101010: //set on less than
                begin
                     o_alu_code = 4'b0111;
                end
                
                default:
                begin
                    o_alu_code = 4'b0010;
                end
            endcase
        end
    endcase
end

endmodule
