
`timescale 1ns / 1ps
module interfaz_tx # ( parameter DBIT = 8) //bits buffer 
(
    input i_clk,
    input i_rst,
    input [DBIT-1:0] i_resultado,
    input i_done_alu,
    input i_done_tx,    
    output reg [DBIT-1:0] o_data,
    output o_tx_start
);

localparam [2-1:0] idle = 2'b00;
localparam [2-1:0] almacenar = 2'b01;
localparam [2-1:0] push_on = 2'b10;

reg [2-1:0] state_reg;
reg [2-1:0] state_next;
reg [DBIT-1:0] data_aux;


//FSMD STATE & DATA REGISTERS
always @(posedge i_clk)
begin
    if(!i_rst)
    begin
        state_reg <= idle;
        o_data<= 8'b0;
    end
    else
    begin
        state_reg <= state_next;
        if(state_reg==push_on)
            o_data <= data_aux;
        else
            o_data <= o_data;
    end
end

//FSMD NEXT_STATE LOGIC
always @(*)
begin
    state_next = state_reg;
    case(state_reg)
        idle:
        begin
            if(i_done_alu)
                state_next = almacenar;
        end
        
        almacenar:
        begin
            data_aux = i_resultado;
            if(i_done_tx)
                state_next = push_on;
        end
      
        push_on:
        begin
                state_next = idle;
        end
    endcase
end

assign o_tx_start = (state_reg==push_on) ? 1'b1 : 1'b0;

endmodule