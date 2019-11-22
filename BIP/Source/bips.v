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
`define NB_ADDR 11
`define NB_OPERANDO 11
`define RAM_WIDTH 16
`define RAM_DEPTH_DM 1024
`define RAM_DEPTH_PM 2048
`define RAM_PERFORMANCE "LOW_LATENCY"
`define INIT_FILE_PM " " //PONER PATH 

module bips(
    i_clk,
    i_rst,
    o_counter
    );
    
/// PARAMETERS
parameter NB_OPCODE          = `NB_OPCODE;
parameter NB_ADDR              = `NB_ADDR;
parameter NB_OPERANDO          = `NB_OPERANDO;
parameter RAM_WIDTH          = `RAM_WIDTH;
parameter RAM_DEPTH_PM          = `RAM_DEPTH_PM;
parameter RAM_DEPTH_DM          = `RAM_DEPTH_DM;
parameter RAM_PERFORMANCE          = `RAM_PERFORMANCE;
parameter INIT_FILE_PM          = `INIT_FILE_PM;

//PUERTOS
input i_clk;
input i_rst;
output [NB_ADDR-1:0] o_counter;

//VARIABLES
wire [NB_OPCODE-1:0] opcode_pm;
wire [NB_OPERANDO-1:0] operando_pm;
wire [NB_ADDR-1:0] addr_pm;
wire [RAM_WIDTH-1:0] instruction_pm;
wire [RAM_WIDTH-1:0] in_data_dm;
wire [RAM_WIDTH-1:0] o_data_dm;
wire wr_en;

assign opcode_pm = instruction_pm [RAM_WIDTH -1 -: NB_OPCODE];
assign operando_pm = instruction_pm [NB_OPERANDO-1 : 0];

    cpu
#(  
    .NB_OPCODE(NB_OPCODE),
    .NB_ADDR(NB_ADDR),
    .NB_OPERANDO(NB_OPERANDO),
    .RAM_WIDTH(RAM_WIDTH)
)
    u_cpu
(
    .i_clk(i_clk),
    .i_rst(i_rst),
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
    .INIT_FILE(INIT_FILE_PM)
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
    .NB_OPERANDO(NB_OPERANDO)
)
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_opcode(opcode_pm),
    .o_counter(o_counter)
);
endmodule
