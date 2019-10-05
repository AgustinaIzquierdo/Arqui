
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


module UART #(parameter DBIT = 8,//data bits
                   parameter SB_TICK =16//ticks for stop bits 16/24/32 ofr 1/1.5/2 bits
                   //parameter DVSR = 163, //divisor de baudrate DVSR=50M/(16*baudrate)
                   //parameter DVSR_BIT = 8, //bits of DVSR
                   //parameter FIFO_W = 2//bits de direccion de FIFO , palabras en FIFO=2^FIFO_W
                   )
(
    input i_clk,
    input i_rst,
    input i_rd_uart,
    input i_wr_uart,
    input i_rx,
    input [DBIT-1:0] i_w_data,
    output o_tx_full,
    output o_rx_empty,
    output o_tx,
    output [DBIT-1:0] o_r_data
);

//declaracion de señales
wire tick;
wire rx_done_data;
wire tx_done_tick;
wire tx_empty;
wire tx_fifo_not_empty;
wire [8-1:0] tx_f;
wire rx_data_out;
wire [DBIT-1:0] tx_interfaz_data;

//instancias

tx #(.DBIT(DBIT), .SB_TICK(SB_TICK))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_tx_start(tx_fifo_not_empty), //
    .i_tick(tick),
    .i_data(tx_interfaz_data),       
    .o_done_tx(tx_done_tick),       //
    .o_tx(o_tx)                     // TPLEVEL
);

interfaz_tx #(.DBIT(DBIT))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_resultado(),
    .i_done_alu(),
    .i_done_tx(),
    .o_data(tx_interfaz_data),
    .o_tx_start()
);

rx #(.DBIT(DBIT), .SB_TICK(SB_TICK))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_bit(i_rx),                  //TPLEVEL
    .i_tick(tick),
    .o_done_data(rx_done_data),   //
    .o_dout(rx_data_out)         //
);
    
baudrate_gen
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .o_tick(tick)
);

interfaz_rx #(.DBIT(DBIT))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(rx_data_out),
    .i_done_data(rx_done_data),
    .o_a(),
    .o_b(),
    .o_op(),
    .o_rx_alu_done()
);

assign tx_fifo_not_empty = ~tx_empty; //ta pesimo

endmodule
