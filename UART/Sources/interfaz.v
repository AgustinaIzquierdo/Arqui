`timescale 1ns / 1ps
module interfaz_rx # ( parameter NB_DATA = 8, parameter NB_OPERADOR =6) //bits buffer 
(
    input i_clk,
    input i_rst,
    input [NB_DATA-1:0] i_data, //Dato proveniente del RX
    input i_done_data, //Dato listo para pasarle a la interfaz
    output reg [NB_DATA-1:0] o_a,
    output reg [NB_DATA-1:0] o_b,
    output reg [NB_OPERADOR-1:0] o_op,
    output o_rx_alu_done //Notifica a la ALU que tiene los datos listos
);

localparam [2-1:0] idle = 2'b00;
localparam [2-1:0] almacenar = 2'b01;
localparam [2-1:0] alu = 2'b10;

reg [2-1:0] state_reg;
reg [2-1:0] state_next;
reg [2-1:0] contador_reg; //Delimita que el dato vaya a A-B-OPCODE
wire [2-1:0] contador_next;
reg count_reset;
reg count_inc;

//FSMD STATE & DATA REGISTERS
always @(posedge i_clk)
begin
    if(!i_rst)
        state_reg <= idle;
    else
        state_reg <= state_next;
end

//Asignacion datos de salida
always @(posedge i_clk)
begin
    if(!i_rst)
    begin
        o_op <= 8'b0;
        o_a <= 8'b0;
        o_b <= 8'b0;
    end
    else
    begin
        if(state_reg==almacenar)
        begin
            if(contador_reg==2'b00)
                o_a <= i_data;
            else if(contador_reg==2'b01)
                o_b <= i_data;
            else
                o_op <= i_data[NB_OPERADOR-1:0];   
        end
        else
        begin
            o_a <= o_a;
            o_b <= o_b;
            o_op <= o_op;
        end
    end
end

//Incremento y reset contador
always @(posedge i_clk)
begin
    if(!i_rst || count_reset)
    begin
        contador_reg <= 2'b00;
    end
    else
    begin
        if(state_reg==almacenar)
        begin
            contador_reg <= contador_next;
        end
        else
        begin
            contador_reg <= contador_reg;
        end
    end
end

//FSMD NEXT_STATE LOGIC
always @(*)
begin
    state_next = state_reg;
    count_reset = 1'b0;
    count_inc = 1'b0;
    case(state_reg)
        idle:
        begin
            if(i_done_data)
                state_next = almacenar;
        end
        
        almacenar:
        begin
            if(i_done_data)
            begin
                if(contador_reg==3)
                begin
                    count_reset = 1'b1;
                    state_next = alu;
                    count_inc = 1'b0;
                end
                else
                    count_reset = 1'b0;
                    count_inc = 1'b1;
            end
            else
            begin
                count_inc = 1'b0;
                count_reset = 1'b0;
            end        
        end
        
        alu:
        begin
                state_next = idle;
        end
    endcase
end

assign o_rx_alu_done = (state_reg==alu) ? 1'b1 : 1'b0;

assign contador_next = (!i_rst)? 2'b0 : (count_inc) ? (contador_reg +1'b1) : contador_reg;

endmodule