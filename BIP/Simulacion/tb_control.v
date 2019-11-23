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


module tb_control();

localparam OPCODE = 5;
localparam ADDR =11;
localparam OPERANDO =11;
localparam DECODER_SEL_A =2;
localparam RAM_WIDTH =16;
localparam RAM_DEPTH_PM = 2048;
localparam RAM_PERFORMANCE = "LOW_LATENCY";
localparam INIT_FILE_PM = "/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/BIP/Source/program_memory.txt";

reg clk;
reg rst;
wire [OPCODE-1:0] opcode_pm;
wire [ADDR-1:0] addr_pm;
wire [DECODER_SEL_A-1:0] selA;
wire selB;
wire wrAcc;
wire [OPCODE-1:0] op;
wire wrRam;
wire rdRam;
wire [RAM_WIDTH-1:0] instruction_pm;
wire [ADDR-1:0] counter;

assign opcode_pm = instruction_pm [RAM_WIDTH -1 -: OPCODE];


initial begin
  #0
  rst = 1'b0;
  clk = 1'b0;
   
  #2  rst = 1'b1;
  
  
  #1000 $finish;
end // initial

always #1 clk = ~clk;


    control
#(
    .NB_OPCODE(OPCODE),
    .NB_ADDR(ADDR),
    .NB_DECODER_SEL_A(DECODER_SEL_A)
)
    u_control
(
    .i_clk(clk),
    .i_rst(rst),
    .i_opcode(opcode_pm),  
    .o_addr(addr_pm),     
    .o_selA(selA),
    .o_selB(selB),
    .o_wrAcc(wrAcc),
    .o_op(op),
    .o_wrRam(wrRam),
    .o_rdRam(rdRam)
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

count_clock
#(
    .NB_OPCODE(OPCODE),
    .NB_ADDR(OPERANDO)
)
    u_counter
(
    .i_clk(clk),
    .i_rst(rst),
    .i_opcode(opcode_pm),
    .o_counter(counter)
);

endmodule
