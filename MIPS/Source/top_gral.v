`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2020 10:14:20
// Design Name: 
// Module Name: top_gral
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

//Tamanio de los latches 
`define NB_IF_ID  96
`define NB_ID_EX  160
`define NB_EX_MEM  128
`define NB_MEM_WB  96

`define LEN 32
`define CANT_REG 16
`define CANT_MEM 8

`define NBITS 8
`define NUM_TICKS 16
`define BAUD_RATE 9600
`define CLK_RATE 100000000

parameter LEN = `LEN;
parameter CANT_REG = `CANT_REG;
parameter CANT_MEM = `CANT_MEM;
parameter NB_IF_ID = `NB_IF_ID; 
parameter NB_ID_EX = `NB_ID_EX; 
parameter NB_EX_MEM = `NB_EX_MEM; 
parameter NB_MEM_WB = `NB_MEM_WB; 
parameter NBITS = `NBITS;
parameter NUM_TICKS = `NUM_TICKS;
parameter BAUD_RATE = `BAUD_RATE;
parameter CLK_RATE = `CLK_RATE;

module top_gral
(

);

//Mips-Recolector
wire [$clog2(CANT_REG)-1:0] addr_reg_reco;
wire [$clog2(CANT_MEM)-1:0] addr_memdatos_reco;
wire [LEN-1:0] reg_recolector;
wire [LEN-1:0] mem_datos_recolector;

top_mips 
#(
   .LEN(LEN),
   .NB_IF_ID(NB_IF_ID),
   .NB_ID_EX(NB_ID_EX),
   .NB_EX_MEM(NB_EX_MEM),
   .NB_MEM_WB(NB_MEM_WB),
   .CANT_REG(CANT_REG),
   .CANT_MEM(CANT_MEM)
   
)
    u_top_mips
(
    .i_clk(),
    .i_rst(),
    .i_debug_flag(),
    .i_addr_reg_reco(addr_reg_reco),
    .i_addr_memdatos_reco(addr_memdatos_reco),
    .o_if_id(),
    .o_id_ex(),
    .o_ex_mem(),
    .o_mem_wb(),
    .o_debug_halt(),
    .o_reg_recolector(reg_recolector),
    .o_mem_datos_recolector(mem_datos_recolector)
);

uart
#(
   .NBITS(NBITS),
   .NUM_TICKS(NUM_TICKS),
   .BAUD_RATE(BAUD_RATE),
   .CLK_RATE(CLK_RATE)
)
    u_uart
(
    .i_clk(),
    .i_rst(),
    .i_tx_start(),
    .i_rx_bit(),
    .i_data_in_tx(),
    .o_data_out_rx(),
    .o_rx_done_tick(),
    .o_tx_bit(),
    .o_tx_done_tick()
);

debug_unit
#(
    .LEN(LEN),
    .LEN_UART(NBITS),
    .CANT_REG(CANT_REG),
    .CANT_MEM(CANT_MEM),
    .NB_IF_ID(NB_IF_ID),
    .NB_ID_EX(NB_ID_EX),
    .NB_EX_MEM(NB_EX_MEM),
    .NB_MEM_WB(NB_MEM_WB)
)
    u_debug_unit
(
    .i_clk(),
    .i_rst(),
    .i_halt(),
    .i_if_id(),
    .i_id_ex(),
    .i_ex_mem(),
    .i_mem_wb(),
    .i_tx_done(),
    .i_rx_done(),
    .i_uart_data(),
    .o_tx_start(),
    .o_uart_start()
);

recolector
#(
    .LEN(LEN),
    .CANT_REG(CANT_REG),
    .CANT_MEM(CANT_MEM)
)
    u_recolector
(
    .i_clk(),
    .i_rst(),
    .i_reg(reg_recolector),
    .i_mem_datos(mem_datos_recolector),
    .i_enable_next(),
    .i_send_regs(),
    .o_addr_reg(addr_reg_reco),
    .o_addr_mem(addr_memdatos_reco),
    .o_data()  
);
endmodule
