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

`define NB_ADDR 11
`define NB_OPERANDO 11
`define RAM_WIDTH 16
`define RAM_DEPTH_PM 2048
`define RAM_PERFORMANCE_PM "HIGH_PERFORMANCE"
`define INIT_FILE_PM " " //PONER PATH 

module bips(
    input i_clk,
    input i_rst
    );
    
/// PARAMETERS
parameter NB_ADDR              = `NB_ADDR;
parameter NB_OPERANDO          = `NB_OPERANDO;
parameter RAM_WIDTH          = `RAM_WIDTH;
parameter RAM_DEPTH_PM          = `RAM_DEPTH_PM;
parameter RAM_PERFORMANCE_PM          = `RAM_PERFORMANCE_PM;
parameter INIT_FILE_PM          = `INIT_FILE_PM;

//VARIABLES
wire [RAM_WIDTH-1:0] instruction_pm;
wire [NB_ADDR-1:0] addr_pm;
    cpu
#(
    .NB_ADDR(NB_ADDR),
    .NB_OPERANDO(NB_OPERANDO),
    .RAM_WIDTH(RAM_WIDTH)
)
    u_cpu
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_instruction_pm(instruction_pm),
    .o_addr_pm(addr_pm)
);
    
    program_memory
#(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH_PM),
    .RAM_PERFORMANCE(RAM_PERFORMANCE_PM),
    .INIT_FILE(INIT_FILE_PM)
)
    u_program_memory
(
    .i_clk(i_clk),
    .i_addr(addr_pm),
    .o_data(instruction_pm)
);

    //DATA_MEMORY
    
    //COUNTER_CLOCK?

endmodule
