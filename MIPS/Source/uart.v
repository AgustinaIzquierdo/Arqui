`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2020 11:08:28
// Design Name: 
// Module Name: uart
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


module uart
#(
	parameter NBITS = 8,
	parameter NUM_TICKS = 16,
	parameter BAUD_RATE = 9600,
	parameter CLK_RATE = 100000000
)
(
	input i_clk,
	input i_rst,
	input i_tx_start, //Indicador de dato valido para transmitir
	input i_rx_bit, //Recibe de la computadora bit a bit
	input [NBITS-1 : 0] i_data_in_tx, //Dato a transmitir
	output [NBITS-1 : 0] o_data_out_rx, //Dato recibido
	output o_rx_done_tick, //Dato listo para pasar
	output o_tx_bit, //Envia a la computadora bit a bit
	output o_tx_done_tick //Tx esta libre
);

wire connect_baud_rate_rx_tx; 

baud_rate_gen 
#(
    .BAUD_RATE(BAUD_RATE),
    .CLK_RATE(CLK_RATE),
    .NUM_TICKS(NUM_TICKS)
) 
    u_baud_rate_gen 
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .o_tick(connect_baud_rate_rx_tx)
);

rx 
#(
    .NB_DATA(NBITS),
    .SB_TICK(NUM_TICKS)
)
     
    u_rx 
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_bit(i_rx_bit),
    .i_tick(connect_baud_rate_rx_tx),
    .o_done_data(o_rx_done_tick),
    .o_data(o_data_out_rx)
);

tx 
#(
    .NB_DATA(NBITS),
    .SB_TICK(NUM_TICKS)
) 
u_transmisor 
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_tx_start(i_tx_start),
    .i_tick(connect_baud_rate_rx_tx),
    .i_data(i_data_in_tx),
    .o_done_tx(o_tx_done_tick),
    .o_tx(o_tx_bit)
);
endmodule	
			
