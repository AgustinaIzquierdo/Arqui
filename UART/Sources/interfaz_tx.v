
`timescale 1ns / 1ps
module interfaz_tx # ( parameter NB_DATA = 8) //bits buffer 
(
    input i_clk,
    input i_rst,
    input [NB_DATA-1:0] i_resultado, //Resultado proveniente de la ALU
    input i_done_alu, //ALU notifica que tiene el resultado
    input i_done_tx,  //Tx avisa a la interfaz que esta libre para procesar datos  
    output reg [NB_DATA-1:0] o_data, //Resultado enviado al TX
    output o_int_tx //Indicador de dato valido para transmitir
);

localparam [2-1:0] idle = 2'b00;
localparam [2-1:0] almacenar = 2'b01;
localparam [2-1:0] push_on = 2'b10;

reg [2-1:0] state_reg;
reg [2-1:0] state_next;

//FSMD STATE & DATA REGISTERS
always @(posedge i_clk)
begin
    if(!i_rst)
        state_reg <= idle;
    else
        state_reg <= state_next;
end

//Asignacion dato de salida
always @(posedge i_clk)
begin
    if(!i_rst)
        o_data<= 8'b0;
    else
    begin
        if(state_reg==almacenar)
            o_data <= i_resultado;
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
            if(i_done_tx)
                state_next = push_on;
        end
      
        push_on:
        begin
                state_next = idle;
        end
    endcase
end
assign o_int_tx = (state_reg==push_on) ? 1'b1 : 1'b0;

endmodule