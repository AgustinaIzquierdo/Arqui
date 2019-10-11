`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2019 16:13:39
// Design Name: 
// Module Name: baudrate_gen
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


module baudrate_gen(
    input i_clk,
	input i_rst,	
	output reg o_tick
    );
    
localparam BAUD_RATE = 9600;
localparam CLK_RATE = 50000000; //clock de la placa 
localparam NUM_TICKS = 16;  //division del baudio

localparam RATE_CLK_OUT = CLK_RATE / (BAUD_RATE * NUM_TICKS); //Frecuencia de recepcion
localparam LEN_ACUM = $clog2(RATE_CLK_OUT);  //Largo en bits del buffer para generar esa frecuencia de recepcion

reg [LEN_ACUM - 1 : 0] contador = 0;

always @(posedge i_clk) 
begin
	if (i_rst)
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