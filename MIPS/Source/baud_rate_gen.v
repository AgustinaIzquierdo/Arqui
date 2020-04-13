`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2020 11:08:28
// Design Name: 
// Module Name: baud_rate_gen
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


module baud_rate_gen
#(
    parameter BAUD_RATE = 9600,
    parameter CLK_RATE = 100000000,
    parameter NUM_TICKS = 16 //Division del baudio
)
(
    input i_clk,
	input i_rst,	
	output reg o_tick
);

localparam RATE_CLK_OUT = CLK_RATE / (BAUD_RATE * NUM_TICKS); //Frecuencia de recepcion
// parameter RATE_CLK_OUT = CLK_RATE / (BAUD_RATE * NUM_TICKS * 1000); // debug!
localparam LEN_ACUM = $clog2(RATE_CLK_OUT); //Largo en bits del buffer para generar esa frecuencia de recepcion

reg [LEN_ACUM - 1 : 0] contador = 0;

always @(posedge i_clk) 
begin
	if (!i_rst)
		begin
			contador <= 0;
			o_tick <= 0;
		end
	else
		begin			
			contador <= contador + 1;
			
			if (contador == (RATE_CLK_OUT)) //Contamos hasta lo que queriamos?
				begin
					o_tick <= 1;
					contador <= 0;
				end
			else
			   o_tick <= 0;
		end
end
endmodule