`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2019 20:34:50
// Design Name: 
// Module Name: ALU_toplevel
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

`define NB_DATA 6
`define NB_OPERADOR 6
`define N_BOTON 3

module ALU_toplevel(
    clk,
    sw,
    btnL,
    btnC,
    btnR,
    led
);

/// PARAMETERS
parameter NB_DATA              = `NB_DATA;
parameter NB_OPERADOR          = `NB_OPERADOR;

/// PORTS
input [NB_DATA-1:0] sw;
input clk;
input btnL;
input btnC;
input btnR;
output [NB_DATA-1:0] led;

/// VARIABLES
reg [NB_DATA-1 : 0] dato_a;
reg [NB_DATA-1 : 0] dato_b;
reg [NB_OPERADOR-1 : 0] operador;

always @(posedge clk)
begin
    if(btnL==1'b1)
    begin
        dato_a<=sw;
    end
    else if(btnC==1'b1)
    begin
        dato_b<=sw;
    end
    else if(btnR==1'b1)
    begin
        operador<=sw[NB_OPERADOR-1 : 0];
    end
    else
    begin
        dato_a<=dato_a;
        dato_b<=dato_b;
        operador<=operador;
    end
end


ALU
#(`NB_DATA,`NB_OPERADOR)
u_ALU
(.i_dato_a(dato_a),
 .i_dato_b(dato_b),
 .i_operador(operador),
 .o_resultado(led)
);



endmodule
