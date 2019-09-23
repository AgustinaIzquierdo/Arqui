`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2019 21:06:09
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
    parameter DBIT = 8, //DATA BITS
    parameter SB_TICK = 16 // TICKS FOR STOP BITS
   )
   (
    input i_clk,
    input i_reset,
    input i_rx,
    input i_s_tick,
    output reg o_rx_done_tick,
    output [8-1:0] o_dout
   );
   
   //SYMBOLIC STATE DECLARATION
   localparam [2-1:0] idle= 2'b00;
   localparam [2-1:0] start= 2'b01;
   localparam [2-1:0] data=2'b10;
   localparam [2-1:0] stop=2'b11;
   
   //SYMBOL DECLARATION
   reg [2-1:0] state_reg;
   reg [2-1:0] state_next;
   reg [4-1:0] s_reg;
   reg [4-1:0] s_next;
   reg [3-1:0] n_reg;
   reg [3-1:0] n_next;
   reg [8-1:0] b_reg;
   reg [8-1:0] b_next;
   
   //FSMD STATE & DATA REGISTERS
   always @(posedge i_clk, posedge i_reset)
   begin
    if(i_reset)
    begin
        state_reg <= idle;
        s_reg <= 4'b0;
        n_reg <= 3'b0;
        b_reg <= 8'b0;
    end
    else
    begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
    end
   end
   
   //FSMD NEXT_STATE LOGIC
   always @(*)
   begin
        state_next = state_reg;
        o_rx_done_tick = 1'b0;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        
        case(state_reg)
            idle:
            begin
                if(~i_rx)
                begin
                    state_next = start;
                    s_next = 0;
                end
            end
            start:
            begin
                if(i_s_tick)
                begin
                    if(s_reg==7)
                    begin
                        state_next = data;
                        s_next = 4'b0;
                        n_next = 3'b0;    
                    end
                    else
                        n_next = n_reg + 1'b1;    
                end
            end
            data:
            begin
                if(i_s_tick)
                begin
                    if(s_reg==15)
                    begin
                        s_next = 4'b0;
                        b_next = {i_rx, b_reg[7:1]};
                        if(n_reg==(DBIT-1))
                            state_next = stop;
                        else
                            n_next = n_reg + 1'b1;    
                    end
                    else
                        s_next = s_reg + 1'b1;    
                end
            end
            stop:
            begin
                if(i_s_tick)
                begin
                    if(s_reg==(SB_TICK-1))
                    begin
                       state_next = idle;
                       o_rx_done_tick = 1'b1;   
                    end
                    else
                        s_next = s_reg + 1'b1;    
                end
            end
        endcase
   end
   
   //OUTPUT
   assign o_dout = b_reg;
endmodule
