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

`define NB_DATA_IN 6
`define NB_DATA_OUT 7
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
parameter NB_DATA_IN              = `NB_DATA_IN;
parameter NB_DATA_OUT              = `NB_DATA_OUT;
parameter NB_OPERADOR          = `NB_OPERADOR;
parameter N_BOTON          = `N_BOTON;

/// PORTS
input [NB_DATA_IN-1:0] sw;
input clk;
//input [N_BOTON-1:0] i_btn;
input btnL;
input btnC;
input btnR;
output [NB_DATA_OUT-1:0] led;

/// VARIABLES
reg [NB_DATA_IN-1 : 0] dato_a;
reg [NB_DATA_IN-1 : 0] dato_b;
reg [NB_OPERADOR-1 : 0] operador;
wire [NB_DATA_OUT-1: 0] resultado;

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
        operador<=sw;
    end
    else
    begin
        dato_a<=dato_a;
        dato_b<=dato_b;
        operador<=operador;
    end
end

assign led=resultado;

ALU
#(`NB_DATA_IN,`NB_DATA_OUT,`NB_OPERADOR)
u_ALU
(.i_dato_a(dato_a),
 .i_dato_b(dato_b),
 .i_operador(operador),
 .o_resultado(resultado)
);



endmodule
