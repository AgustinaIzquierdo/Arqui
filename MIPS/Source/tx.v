`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2020 11:08:28
// Design Name: 
// Module Name: tx
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


module tx
#(
    parameter NB_DATA = 8, //DATA BITS
    parameter SB_TICK = 16 // TICKS FOR STOP BITS
)
(
	input i_clk,
	input i_rst,
	input i_tx_start, //Tiene un valor para transmitir
	input i_tick,
	input [NB_DATA-1:0] i_data, //Dato a transmitir
	output reg o_done_tx, //Ya transmiti el dato a la PC
	output o_tx
);

localparam LEN_DATA_COUNTER = $clog2(NB_DATA); 
localparam LEN_NUM_TICKS_COUNTER = $clog2(SB_TICK); 

// Declaracion de estados
localparam [3:0] IDLE 	= 4'b 1000;
localparam [3:0] START 	= 4'b 0100;
localparam [3:0] DATA	= 4'b 0010;
localparam [3:0] STOP 	= 4'b 0001;

//Declaracion de registros auxiliares
reg [3:0] state_reg, state_next; //Estados a transitar
reg [LEN_NUM_TICKS_COUNTER-1:0] acc_tick, acc_tick_next; //Acumulador de tick
reg [LEN_DATA_COUNTER-1:0] num_bits, num_bits_next; //Bits transmitidos
reg [NB_DATA-1:0] buffer, buffer_next; //Almacena el dato a transmitir
reg tx_reg, tx_next;

assign o_tx = tx_reg;

// parte sincrona con el clock
always @(posedge i_clk)
begin
	if(!i_rst)
		begin
			state_reg <= IDLE;
			acc_tick <= 0;
			num_bits <= 0;
			buffer <= 0;
			tx_reg <= 1'b1;	
		end
	else 
		begin
			state_reg <= state_next;
			acc_tick <= acc_tick_next;
			num_bits <= num_bits_next;
			buffer <= buffer_next;
			tx_reg <= tx_next;
		end
end

always @*
begin
	state_next = state_reg;
	o_done_tx = 1'b0;
	acc_tick_next = acc_tick;
	num_bits_next = num_bits;
	buffer_next = buffer;
	tx_next = tx_reg;

	case (state_reg)
		IDLE:
			begin
				tx_next = 1'b1;
				if (i_tx_start) 
				begin
					state_next = START;
					acc_tick_next = 0;
					buffer_next = i_data;	
				end
			end
		START:
			begin
				tx_next = 1'b0;
				if(i_tick)
					if(acc_tick == SB_TICK-1)
					begin
						state_next = DATA;
						acc_tick_next = 0;
						num_bits_next = 0;
					end
					else 
					begin
						acc_tick_next = acc_tick + 1;	
					end
			end
		DATA:
			begin
				tx_next = buffer[0];
				if(i_tick)
				begin
					if(acc_tick == SB_TICK-1)
					begin
						acc_tick_next = 0;
						buffer_next = buffer >> 1;
						if(num_bits == (NB_DATA - 1))
						begin
							state_next = STOP;
						end
						else 
						begin
							num_bits_next = num_bits + 1;	
						end
					end
					else 
					begin
						acc_tick_next = acc_tick + 1;	
					end
				end
			end
		STOP:
			begin
				tx_next = 1'b1;
				if (i_tick)
				begin
					if(acc_tick == (SB_TICK - 1))
					begin
						state_next = IDLE;
						o_done_tx = 1'b1;
					end
					else 
					begin
						acc_tick_next = acc_tick + 1;	
					end
				end
			end

        default:
            begin
				state_next = IDLE; 
				acc_tick_next = 0; 
				num_bits_next = 0; 
				buffer_next = 0;
				tx_next = 1'b1;
			end
	endcase
end
endmodule
