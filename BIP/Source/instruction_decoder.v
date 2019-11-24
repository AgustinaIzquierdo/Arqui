`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2019 10:52:32
// Design Name: 
// Module Name: instruction_decoder
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


module instruction_decoder
#(
    parameter NB_OPCODE = 5,
    parameter NB_DECODER_SEL_A = 2
)
(
    input [NB_OPCODE-1:0] i_opcode,
    output reg o_wrPc,
    output reg [NB_DECODER_SEL_A-1:0] o_selA,
    output reg o_selB,
    output reg o_wrAcc,
    output reg [NB_OPCODE-1:0] o_op,
    output reg o_wrRam,
    output reg o_rdRam
);
always @(*)
begin
    case(i_opcode)
        5'b00000: //Halt
        begin
            o_wrPc = 0;
            o_selA = 0;
            o_selB = 0;
            o_wrAcc = 0;
            o_op = i_opcode;
            o_wrRam = 0;
            o_rdRam = 0;
        end
        5'b00001: //Store Variable
        begin
           o_wrPc = 1; //Aumenta PC
           o_selA = 0; //No interesa dado que no esta habilitado escritura en ACC
           o_selB = 0;
           o_wrAcc = 0; //No se sobreescribe ACC
           o_op = i_opcode; //No realiza operacion
           o_wrRam = 1; 
           o_rdRam = 0;
        end
        5'b00010: //Load variable
        begin
           o_wrPc = 1; //Aumenta PC
           o_selA = 0; //Trae de memoria
           o_selB = 0;
           o_wrAcc = 1; //Sobreescribe ACC
           o_op = i_opcode;
           o_wrRam = 0;
           o_rdRam = 1; 
        end
        5'b00011: //Load immediate
        begin
           o_wrPc = 1; //Aumenta PC
           o_selA = 1; //Operando inmediato
           o_selB = 0;
           o_wrAcc = 1; //Sobreescribe ACC
           o_op = i_opcode;
           o_wrRam = 0;
           o_rdRam = 0;
        end
        5'b00100: //Add variable
        begin
           o_wrPc = 1;
           o_selA = 2; //Resultado operacion
           o_selB = 0; //Trae de memoria 
           o_wrAcc = 1; //Sobreescribe ACC
           o_op = i_opcode;
           o_wrRam = 0;
           o_rdRam = 1; //Leemos ram
        end
        5'b00101: //Add immediate
        begin
            o_wrPc = 1;
            o_selA = 2; //Resultado operacion
            o_selB = 1; //Dato inmediato
            o_wrAcc = 1; //Sobreescribe ACC
            o_op = i_opcode;
            o_wrRam = 0;
            o_rdRam = 0; 
        end
        5'b00110: //Subtract Variable
        begin
            o_wrPc = 1;
            o_selA = 2; //Resultado operacion
            o_selB = 0; //Dato inmediato
            o_wrAcc = 1; //Sobreescribe ACC
            o_op = i_opcode;
            o_wrRam = 0;
            o_rdRam = 1; 
        end
        5'b00111: //Substract immediate
        begin
            o_wrPc = 1;
            o_selA = 2; //Resultado operacion
            o_selB = 1; //Dato inmediato
            o_wrAcc = 1; //Sobreescribe ACC
            o_op = i_opcode;
            o_wrRam = 0;
            o_rdRam = 0; 
        end
        default:
        begin
            o_wrPc = 0;
            o_selA = 0;
            o_selB = 0;
            o_wrAcc = 0;
            o_op = 0;
            o_wrRam= 0;
            o_rdRam= 0;
        end
    endcase
end
endmodule
