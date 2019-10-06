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

module tx
  #(
    parameter NB_DATA = 8, //DATA BITS
    parameter SB_TICK = 16 // TICKS FOR STOP BITS
   )
   (
    input i_clk,  
    input i_rst,
    input i_tx_start, //Tiene un resultado la interfaz
    input i_tick,
    input [NB_DATA-1:0] i_data, //Resultado de la ALU
    output reg o_done_tx, //Ya transmiti el dato a la PC
    output o_tx
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
   reg [NB_DATA-1:0] b_reg;
   reg [NB_DATA-1:0] b_next;
   reg tx_reg;
   reg tx_next; //En los estados IDLE-START-STOP lo usa para empezar y cerrar la trama
                //En el estado DATA lo usa para transmitir los datos a la PC
   
   //FSMD STATE & DATA REGISTERS
   always @(posedge i_clk)
   begin
    if(i_rst)
    begin
        state_reg <= idle;
        s_reg <= 4'b0;
        n_reg <= 3'b0;
        b_reg <= 8'b0;
        tx_reg <= 1'b1;
    end
    else
    begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
        tx_reg <= tx_next;
    end
   end
   
   //FSMD NEXT_STATE LOGIC
   always @(*)
   begin
        state_next = state_reg;
        o_done_tx = 1'b0;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        tx_next = tx_reg;
        
        case(state_reg)
            idle:
            begin
                tx_next = 1'b1;
                if(i_tx_start)
                begin
                    state_next = start;
                    s_next = 0;
                    b_next = i_data;
                end
            end
            start:
            begin
                tx_next = 1'b0;
                if(i_tick)
                begin
                    if(s_reg==15)
                    begin
                        state_next = data;
                        s_next = 4'b0;
                        n_next = 3'b0;    
                    end
                    else
                        s_next = s_reg + 1'b1;    
                end
            end
            data:
            begin
                tx_next = b_reg[0];
                if(i_tick)
                begin
                    if(s_reg==15)
                    begin
                        s_next = 4'b0;
                        b_next = b_reg >> 1;
                        if(n_reg==(NB_DATA-1))
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
                tx_next = 1'b1;
                if(i_tick)
                begin
                    if(s_reg==(SB_TICK-1))
                    begin
                       state_next = idle;
                       o_done_tx = 1'b1;   
                    end
                    else
                        s_next = s_reg + 1'b1;    
                end
            end
        endcase
   end
   
   //OUTPUT
   assign o_tx = tx_reg;
endmodule