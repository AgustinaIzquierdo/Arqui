
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


module top_level #(parameter DBIT = 8,//data bits
                   parameter SB_TICK =16,//ticks for stop bits 16/24/32 ofr 1/1.5/2 bits
                   parameter DVSR = 163, //divisor de baudrate DVSR=50M/(16*baudrate)
                   parameter DVSR_BIT = 8, //bits of DVSR
                   parameter FIFO_W = 2)//bits de direccion de FIFO , palabras en FIFO=2^FIFO_W
(
    input i_clk,
    input i_rst,
    input i_rd_uart,
    input i_wr_uart,
    input i_rx,
    input [7:0] i_w_data,
    output o_tx_full,
    output o_rx_empty,
    output o_tx,
    output [7:0] o_r_data
);

//declaracion de señales
wire tick;
wire rx_done_tick;
wire tx_done_tick;
wire tx_empty;
wire tx_fifo_not_empty;
wire [7:0] tx_f;
wire fifo_out;
wire rx_data_out;

//instancias


assign tx_fifo_not_empty = ~tx_empty; //ta pesimo

endmodule
