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

localparam [3-1:0] idle = 3'b000;
localparam [3-1:0] op1 = 3'b001;
localparam [3-1:0] op2 = 3'b010;
localparam [3-1:0] operacion = 3'b011;
localparam [3-1:0] alu = 3'b100;

reg [3-1:0] state_reg;
reg [3-1:0] state_next;
reg count_reset;
reg count_inc;

reg done_data_prev;

//FSMD STATE & DATA REGISTERS
always @(posedge i_clk)
begin
    if(!i_rst)
    begin
        state_reg <= idle;
        done_data_prev <= 0;
    end
    else
    begin
        state_reg <= state_next;
        done_data_prev <= i_done_data;
    end
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
        if(state_reg==op1)
                o_a <= i_data;
        else if(state_reg==op2)
                o_b <= i_data;
        else if(state_reg==operacion)
                o_op <= i_data[NB_OPERADOR-1:0];   
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
            if((i_done_data==1)&&(done_data_prev == 0))
                state_next = op1;
        end
        
        op1:
        begin
            if((i_done_data==1)&&(done_data_prev == 0))
                state_next = op2;
        end
        
        op2:
        begin
            if((i_done_data==1)&&(done_data_prev == 0))
                state_next = operacion;
        end
        
        operacion:
                begin
                    if((i_done_data==1)&&(done_data_prev == 0))
                        state_next = alu;
                end
        alu:
        begin
                state_next = idle;
        end
        
        default:
            state_next=idle;
    endcase
end

assign o_rx_alu_done = (state_reg==alu) ? 1'b1 : 1'b0;

endmodule