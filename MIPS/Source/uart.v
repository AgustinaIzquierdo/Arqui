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
	input tx_start,
	input rx,
	input [NBITS-1 : 0] data_in,
	output [NBITS-1 : 0] data_out,
	output rx_done_tick,
	output tx,
	output tx_done_tick
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
    .i_bit(rx),
    .i_tick(connect_baud_rate_rx_tx),
    .o_done_data(rx_done_tick),
    .o_data(data_out)
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
    .i_tx_start(tx_start),
    .i_tick(connect_baud_rate_rx_tx),
    .i_data(data_in),
    .o_done_tx(tx_done_tick),
    .o_tx(tx)
);
endmodule	
			
