`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2020 11:08:28
// Design Name: 
// Module Name: rx
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


module rx
#(
    parameter NB_DATA = 8, //DATA BITS
    parameter SB_TICK = 16 // TICKS FOR STOP BITS
)
(
    input i_clk,
    input i_rst,
    input i_bit, //Senial que recibe los bit de entrada
    input i_tick, //Senial de control que indica cuando muestrear
    output reg o_done_data, //Dato listo
    output [NB_DATA-1:0] o_data //Dato de salida
); 

	localparam LEN_DATA_COUNTER = $clog2(NB_DATA); 
	localparam LEN_NUM_TICKS_COUNTER = $clog2(SB_TICK); 

	localparam	[3:0] IDLE 	= 4'b 1000;
	localparam	[3:0] START	= 4'b 0100;
	localparam	[3:0] DATA	= 4'b 0010;
	localparam	[3:0] STOP 	= 4'b 0001;

	reg [3:0] state, state_next; //Estados a transitar
	reg [LEN_NUM_TICKS_COUNTER - 1:0] acc_tick, acc_tick_next; //Acumulador de tick
	reg [LEN_DATA_COUNTER - 1:0] num_bits, num_bits_next; //Bits recibidos
	reg [NB_DATA - 1:0] buffer, buffer_next; //Almacena el dato recibido

	assign o_data = buffer; 

	always @(posedge i_clk) 
	begin 
		if (!i_rst)
		begin 
			state <= IDLE; 
			acc_tick <= 0; 
			num_bits <= 0; 
			buffer <= 0; 
		end
		else 
		begin 
			state <= state_next; 
			acc_tick <= acc_tick_next; 
			num_bits <= num_bits_next; 
			buffer <= buffer_next; 
		end
	end 

	// lógica próxima estado
	always @(*) 
	begin 
		state_next = state; 
		o_done_data = 1'b 0; 
		acc_tick_next = acc_tick;
		num_bits_next = num_bits; 
		buffer_next = buffer; 

		case (state)
			IDLE : 
				if (~i_bit) 
				begin 
					state_next = START; 
					acc_tick_next = 0; 
				end 
			
			START : 
				if (i_tick) 
				begin
					if (acc_tick==(SB_TICK>>1)-1) 
					begin 
						state_next = DATA; 
						acc_tick_next = 0; 
						num_bits_next = 0; 
					end 
					else 
						acc_tick_next = acc_tick + 1;
                end
			
			DATA : 
				if (i_tick)
				begin
					if (acc_tick==SB_TICK-1)
					begin 
						acc_tick_next = 0; 
						buffer_next = {i_bit , buffer [NB_DATA-1 : 1]}; 
						if (num_bits==(NB_DATA-1)) 
							state_next = STOP; 
						else 
							num_bits_next = num_bits + 1; 
					end 
					else
						acc_tick_next = acc_tick + 1;
			    end

			STOP : 
				if (i_tick)
				begin
					if (acc_tick==(SB_TICK-1)) 
					begin 
						state_next = IDLE; 
						o_done_data =1'b 1; 
					end 
					else 
						acc_tick_next = acc_tick + 1;
                end

            default :
            begin
				state_next = IDLE; 
				acc_tick_next = 0; 
				num_bits_next = 0; 
				buffer_next = 0;
			end
        endcase
	end 
endmodule