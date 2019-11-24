`timescale 1ns / 1ps

module interfaz 
#( 
    parameter NB_DATA = 8,
    parameter NB_OPCODE = 5,
    parameter NB_ADDR = 11,
    parameter RAM_WIDTH = 16 
)  
(
    input i_clk,
    input i_rst,
    input [NB_DATA-1:0] i_data, //Dato proveniente del RX
    input i_done_data, //Dato listo para pasarle a la interfaz
    input [NB_OPCODE -1:0] i_opcode, //Instruction
    input [RAM_WIDTH -1:0] i_acc,
    input [NB_ADDR -1:0] i_pc,
    input i_done_tx, //TX_LIBRE
    output o_int_tx, //TENEMOS DATA
    output reg [NB_DATA -1:0] o_uart,
    output reg o_bip //Habilita el BIP
);

localparam [3-1:0] idle = 3'b000;
localparam [3-1:0] recibir = 3'b001;
localparam [3-1:0] acc_l = 3'b010;
localparam [3-1:0] acc_h = 3'b011;
localparam [3-1:0] pc_l = 3'b100;
localparam [3-1:0] pc_h = 3'b101;


reg [3-1:0] state_reg;
reg [3-1:0] state_next;
reg bip_next;
reg done_data_prev;
reg [NB_DATA-1:0] uart_next;

//FSMD STATE & DATA REGISTERS
always @(posedge i_clk)
begin
    if(!i_rst)
    begin
        state_reg <= idle;
        done_data_prev <= 0;
        o_bip <= 0;
        o_uart <= 0;
    end
    else
    begin
        state_reg <= state_next;
        done_data_prev <= i_done_data;
        o_bip <= bip_next;
        o_uart <= uart_next;
    end
end

always @(*) begin
    case(state_reg)
        
        idle:
        begin
            bip_next = 0;
            uart_next =0;
        end
        
        recibir:
        begin
            bip_next = 1'b1;
            uart_next = 0;
        end
        
        acc_l:
        begin
            bip_next = 1'b1;
            uart_next = i_acc[NB_DATA-1:0];
        end
        
        acc_h:
        begin
            bip_next = 1'b1;
            uart_next = i_acc[RAM_WIDTH -1 :NB_DATA];
        end
        
        pc_l:
        begin
            bip_next = 1'b1;
            uart_next = i_pc[NB_DATA-1:0];
        end
        
        pc_h:
        begin
            bip_next = 1'b1;
            uart_next = {{(NB_OPCODE){1'b0}},i_pc[NB_ADDR -1 :NB_DATA]};
        end

        default:
        begin
            bip_next = 0;
            uart_next = 0;
        end
    endcase
end

//FSMD NEXT_STATE LOGIC
always @(*)
begin
    state_next = state_reg;
    case(state_reg)
        
        idle:
        begin
            if((i_done_data==1)&&(done_data_prev == 0))
                state_next = recibir;
        end
        
        recibir:
        begin
            if(i_opcode==5'b00000)
                state_next = acc_l;
        end
        
        acc_l:
        begin
            if(i_done_tx==1'b1)
                state_next = acc_h;
        end
        
        acc_h:
        begin
            if(i_done_tx==1'b1)
                state_next = pc_l;
        end
        
        pc_l:
        begin
            if(i_done_tx==1'b1)
                state_next = pc_h;
        end
        
        pc_h:
        begin
            if(i_done_tx==1'b1)
                state_next = idle;
        end
                
        default:
            state_next=idle;
    endcase
end

assign o_int_tx = (state_reg == acc_l || state_reg == acc_h || state_reg == pc_l || state_reg == pc_h) ? 1'b1 : 1'b0; 

endmodule
