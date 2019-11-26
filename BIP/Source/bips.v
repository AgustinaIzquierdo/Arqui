`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2019 19:57:46
// Design Name: 
// Module Name: bips
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

`define NB_OPCODE 5
`define NB_DECODER_SEL_A 2
`define NB_ADDR 11
`define NB_OPERANDO 11
`define RAM_WIDTH 16
`define RAM_DEPTH_DM 2048
`define RAM_DEPTH_PM 2048
`define RAM_PERFORMANCE "LOW_LATENCY"
`define INIT_FILE_PM "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/BIP/Source/instrucciones.txt" 
`define NB_DATA  8
`define SB_TICK 16

module bips(
    i_clk,
    i_rst,
    i_uart_rx,
    o_uart_tx,
    led
    );
    
/// PARAMETERS
parameter NB_OPCODE          = `NB_OPCODE;
parameter NB_DECODER_SEL_A          = `NB_DECODER_SEL_A;
parameter NB_ADDR              = `NB_ADDR;
parameter NB_OPERANDO          = `NB_OPERANDO;
parameter RAM_WIDTH          = `RAM_WIDTH;
parameter RAM_DEPTH_PM          = `RAM_DEPTH_PM;
parameter RAM_DEPTH_DM          = `RAM_DEPTH_DM;
parameter RAM_PERFORMANCE          = `RAM_PERFORMANCE;
parameter INIT_FILE_PM          = `INIT_FILE_PM;
parameter NB_DATA =  `NB_DATA;  //data bits
parameter SB_TICK = `SB_TICK;    //ticks for stop bits 16/24/32 ofr 1/1.5/2 bits

//PUERTOS
input i_clk;
input i_rst;
input i_uart_rx;
output o_uart_tx;
output [8-1:0] led;

//VARIABLES
wire [NB_OPCODE-1:0] opcode_pm;
wire [NB_OPERANDO-1:0] operando_pm;
wire [NB_ADDR-1:0] addr_pm;
wire [RAM_WIDTH-1:0] instruction_pm;
wire [RAM_WIDTH-1:0] in_data_dm;
wire [RAM_WIDTH-1:0] o_data_dm;
wire [NB_ADDR-1:0] o_counter;
wire wr_en;
wire tick;
wire i_int_tx; //Indicador de dato valido para transmitir
wire [NB_DATA-1:0] i_interfaz_tx_data; //Dato de la interfaz al tx
wire o_tx_interfaz_done_data; //Tx avisa a la interfaz que esta libre para procesar datos
wire o_tx; //Envia a la computadora bit a bit
wire o_rx_interfaz_done_data; //Dato listo para pasarle a la interfaz
wire [NB_DATA-1:0] o_rx_interfaz_data; //Dato del rx a la interfaz
wire reset;

assign opcode_pm = instruction_pm [RAM_WIDTH -1 -: NB_OPCODE];
assign operando_pm = instruction_pm [NB_OPERANDO-1 : 0];
assign led = {addr_pm [4-1:0], o_counter [4-1:0]}; 
    cpu
#(  
    .NB_DECODER_SEL_A(NB_DECODER_SEL_A),
    .NB_OPCODE(NB_OPCODE),
    .NB_ADDR(NB_ADDR),
    .NB_OPERANDO(NB_OPERANDO),
    .RAM_WIDTH(RAM_WIDTH)
)
    u_cpu
(
    .i_clk(i_clk),
    .i_rst(reset),
    .i_opcode_pm(opcode_pm),
    .i_operando_pm(operando_pm),
    .i_data(o_data_dm), //DATA MEMORY
    .o_wr_en(wr_en),
    .o_data(in_data_dm), //DATA MEMORY
    .o_addr_pm(addr_pm)
);
    
    program_memory
#(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH_PM),
    .RAM_PERFORMANCE(RAM_PERFORMANCE),
    .INIT_FILE(INIT_FILE_PM)
)
    u_program_memory
(
    .i_clk(i_clk),
    .i_addr(addr_pm),
    .o_data(instruction_pm)
);

   data_memory
#(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH_DM),
    .RAM_PERFORMANCE(RAM_PERFORMANCE),
    .INIT_FILE("")
)
     u_data_memory
(
     .i_clk(i_clk),
     .i_addr(operando_pm),
     .i_data(in_data_dm),
     .i_wea(wr_en),
     .o_data(o_data_dm)
);

    count_clock
#(
    .NB_OPCODE(NB_OPCODE),
    .NB_ADDR(NB_ADDR)
)
    u_count2_clock
(
    .i_clk(i_clk),
    .i_rst(reset),
    .i_opcode(opcode_pm),
    .o_counter(o_counter)
);

tx #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_tx_start(i_int_tx),
    .i_tick(tick),
    .i_data(i_interfaz_tx_data),       
    .o_done_tx(o_tx_interfaz_done_data),       
    .o_tx(o_uart_tx) 
);

rx #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_bit(i_uart_rx),                  
    .i_tick(tick),
    .o_done_data(o_rx_interfaz_done_data),  
    .o_data(o_rx_interfaz_data)      
);
    
baudrate_gen
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .o_tick(tick)
);

interfaz
#(
    .NB_DATA(NB_DATA),
    .NB_OPCODE(NB_OPCODE),
    .NB_ADDR(NB_ADDR),
    .RAM_WIDTH(RAM_WIDTH)
)
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(o_rx_interfaz_data),
    .i_done_data(o_rx_interfaz_done_data),
    .i_opcode(opcode_pm),
    .i_acc(in_data_dm),
    .i_pc(o_counter),
    .i_done_tx(o_tx_interfaz_done_data),
    .o_int_tx(i_int_tx),
    .o_uart(i_interfaz_tx_data),
    .o_ctrl_reset(reset)
);

endmodule
