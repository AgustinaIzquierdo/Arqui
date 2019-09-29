`timescale 1ns / 1ps
module interfaz_rx # ( parameter DBIT = 8) //bits buffer 
(
    input i_clk,
    input i_rst,
    input [DBIT-1:0] i_data,
    input i_done_data,
    output reg [DBIT-1:0] o_a,
    output reg [DBIT-1:0] o_b,
    output reg [DBIT-1:0] o_op,
    output o_rx_alu_done
);

localparam [2-1:0] idle = 2'b00;
localparam [2-1:0] almacenar = 2'b01;
localparam [2-1:0] alu = 2'b10;

reg [2-1:0] state_reg;
reg [2-1:0] state_next;
reg [2-1:0] contador_reg; //Delimita que el dato vaya a A-B-OPCODE
reg [2-1:0] contador_next;
reg [DBIT-1:0] a;
reg [DBIT-1:0] b;
reg [DBIT-1:0] op;


//FSMD STATE & DATA REGISTERS
always @(posedge i_clk)
begin
    if(!i_rst)
    begin
        state_reg <= idle;
        contador_reg <= 2'b00;
        o_op <= 8'b0;
        o_a <= 8'b0;
        o_b <= 8'b0;
    end
    else
    begin
        state_reg <= state_next;
        contador_reg <= contador_next;
        if(state_reg==alu)
        begin
            o_a <= a;
            o_b <= b;
            o_op <= op;    
        end
        else
        begin
            o_a <= o_a;
            o_b <= o_b;
            o_op <= o_op;
        end
    end
end

//FSMD NEXT_STATE LOGIC
always @(*)
begin
    state_next = state_reg;
    case(state_reg)
        idle:
        begin
            contador_next=2'b0;
            if(i_done_data)
                state_next = almacenar;
        end
        
        almacenar:
        begin
            if(i_done_data)
            begin
                if(contador_reg==2)
                begin
                    contador_next= 2'b00;
                    state_next = alu;
                end
                else
                    contador_next = contador_reg + 1'b1;
                    
                if(contador_reg==2'b00)
                    a=i_data;
                else if(contador_reg==2'b01)
                    b=i_data;
                else
                    op=i_data;
            end        
        end
        
        alu:
        begin
                state_next = idle;
        end
    endcase
end

assign o_rx_alu_done = (state_reg==alu) ? 1'b1 : 1'b0;

endmodule