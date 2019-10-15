`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2019 16:42:31
// Design Name: 
// Module Name: top_gral
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

`define NB_DATA 8
`define SB_TICK 16
`define NB_OPERADOR 6

module top_gral
(
     clk,
     rst,
     i_uart_rx,
     o_uart_tx
);

/// PARAMETERS
parameter NB_DATA              = `NB_DATA;
parameter NB_OPERADOR          = `NB_OPERADOR;
parameter SB_TICK          = `SB_TICK;

/// PORTS
 input clk;
 input rst;
 input i_uart_rx;
 output o_uart_tx;
 
// VARIABLES
    //TX con INTERFAZ
wire tx_interfaz_done_data;
wire [NB_DATA-1:0] interfaz_tx_data;
wire int_tx;  
    //RX con INTERFAZ
wire rx_interfaz_done_data;
wire [NB_DATA-1:0] rx_interfaz_data;
    //ALU con INTERFACES
wire [NB_DATA-1 : 0] dato_a;
wire [NB_DATA-1 : 0] dato_b;
wire [NB_OPERADOR-1 : 0] operador;
wire rx_alu_done;
wire done_alu_tx;
wire [NB_DATA-1 : 0] resultado;

    UART #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
(
    .i_clk(clk),
    .i_rst(rst),
    .i_int_tx(int_tx), //Indicador de dato valido para transmitir
    .i_interfaz_tx_data(interfaz_tx_data), //Dato de la interfaz al tx
    .i_rx(i_uart_rx), //Recibe de la computadora bit a bit
    .o_tx_interfaz_done_data(tx_interfaz_done_data), //Tx avisa a la interfaz que esta libre para procesar datos
    .o_tx(o_uart_tx), //Envia a la computadora bit a bit
    .o_rx_interfaz_done_data(rx_interfaz_done_data), //Dato listo para pasarle a la interfaz
    .o_rx_interfaz_data(rx_interfaz_data) //Dato del rx a la interfaz
);

    interfaz_tx #(.NB_DATA(NB_DATA))
(
    .i_clk(clk),
    .i_rst(rst),
    .i_resultado(resultado), //Resultado proveniente de la ALU
    .i_done_alu(done_alu_tx), //ALU notifica que tiene el resultado
    .i_done_tx(tx_interfaz_done_data), //Tx avisa a la interfaz que esta libre para procesar datos
    .o_data(interfaz_tx_data), //Resultado enviado al TX
    .o_int_tx(int_tx) //Indicador de dato valido para transmitir
);


    interfaz_rx #(.NB_DATA(NB_DATA), .NB_OPERADOR(NB_OPERADOR))
(
    .i_clk(clk),
    .i_rst(rst),
    .i_data(rx_interfaz_data), //Dato proveniente del RX
    .i_done_data(rx_interfaz_done_data), //Dato listo para pasarle a la interfaz
    .o_a(dato_a), 
    .o_b(dato_b), 
    .o_op(operador), 
    .o_rx_alu_done(rx_alu_done) //Notifica a la ALU que tiene los datos listos
);

    ALU #(.NB_DATA(NB_DATA), .NB_OPERADOR(NB_OPERADOR))
(
     .i_dato_a(dato_a),
     .i_dato_b(dato_b),
     .i_operador(operador),
     .i_alu_valid(rx_alu_done),
     .o_done_alu_tx(done_alu_tx), //ALU notifica que tiene el resultado
     .o_resultado(resultado) 
);
    
endmodule
