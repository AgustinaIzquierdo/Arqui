`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2019 18:59:53
// Design Name: 
// Module Name: tb_control
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


module tb_datapath();

localparam OPCODE= 5;
localparam DECODER_SEL_A=2;
localparam ADDR= 11;
localparam OPERANDO= 11;
localparam RAM_WIDTH= 16;
localparam RAM_DEPTH_DM= 1024;
localparam RAM_DEPTH_PM= 2048;
localparam RAM_PERFORMANCE= "LOW_LATENCY";
localparam INIT_FILE_PM= "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/BIP/Source/program_memory.txt"; 

reg clk;
reg rst;

wire [ADDR-1:0] counter;
wire [OPCODE-1:0] opcode_pm;
wire [OPERANDO-1:0] operando_pm;
wire [ADDR-1:0] addr_pm;
wire [RAM_WIDTH-1:0] instruction_pm;
wire [RAM_WIDTH-1:0] in_data_dm;
wire [RAM_WIDTH-1:0] o_data_dm;
wire wr_en;

assign opcode_pm = instruction_pm [RAM_WIDTH -1 -: OPCODE];
assign operando_pm = instruction_pm [OPERANDO-1 : 0];

initial begin
  #0
  rst = 1'b0;
  clk = 1'b0;
   
  #1  rst = 1'b1;
  
  
  #1000 $finish;
end // initial

always #1 clk = ~clk;

    cpu
#(  
    .NB_DECODER_SEL_A(DECODER_SEL_A),
    .NB_OPCODE(OPCODE),
    .NB_ADDR(ADDR),
    .NB_OPERANDO(OPERANDO),
    .RAM_WIDTH(RAM_WIDTH)
)
    u_cpu
(
    .i_clk(clk),
    .i_rst(rst),
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
    .i_clk(clk),
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
     .i_clk(clk),
     .i_addr(operando_pm),
     .i_data(in_data_dm),
     .i_wea(wr_en),
     .o_data(o_data_dm)
);

    count_clock
#(
    .NB_OPCODE(OPCODE),
    .NB_ADDR(OPERANDO)
)
    u_count2_clock
(
    .i_clk(clk),
    .i_rst(rst),
    .i_opcode(opcode_pm),
    .o_counter(counter)
);

endmodule
