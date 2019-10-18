
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2019 23:44:57
// Design Name: 
// Module Name: top_level
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


module UART #(parameter NB_DATA = 8,//data bits
                   parameter SB_TICK =16//ticks for stop bits 16/24/32 ofr 1/1.5/2 bits
                   //parameter DVSR = 163, //divisor de baudrate DVSR=50M/(16*baudrate)
                   //parameter DVSR_BIT = 8, //bits of DVSR
                   //parameter FIFO_W = 2//bits de direccion de FIFO , palabras en FIFO=2^FIFO_W
                   )
(
    input i_clk,
    input i_rst,
    input i_int_tx, //Indicador de dato valido para transmitir
    input [NB_DATA-1:0] i_interfaz_tx_data, //Dato de la interfaz al tx
    input i_rx, //Recibe de la computadora bit a bit
    output o_tx_interfaz_done_data, //Tx avisa a la interfaz que esta libre para procesar datos
    output o_tx, //Envia a la computadora bit a bit
    output o_rx_interfaz_done_data, //Dato listo para pasarle a la interfaz
    output [NB_DATA-1:0] o_rx_interfaz_data //Dato del rx a la interfaz
);

//declaracion de señales
wire tick;

//instancias

tx #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_tx_start(i_int_tx),
    .i_tick(tick),
    .i_data(i_interfaz_tx_data),       
    .o_done_tx(o_tx_interfaz_done_data),       
    .o_tx(o_tx) 
);

rx #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_bit(i_rx),                  
    .i_tick(tick),
    .o_done_data(o_rx_interfaz_done_data),  
    .o_data(o_rx_interfaz_data)      
);
    
baudrate_gen
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .o_tick(tick)
);




endmodule
