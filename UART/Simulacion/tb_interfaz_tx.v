`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2019 17:33:09
// Design Name: 
// Module Name: tb_interfaz
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


module tb_interfaz_tx();

//local parameters
localparam  NB_DBIT_01    =  8;

//Inputs
reg  clk;
reg  rst;
reg [NB_DBIT_01-1:0] resultado;
reg done_alu;
reg done_tx;

//Outputs
wire  signed       [NB_DBIT_01-1:0]        o_data;
wire tx_start;

initial begin
  #0
  rst = 1'b0;
  clk = 1'b0;
  done_alu = 1'b0;
  done_tx = 1'b0;
  resultado = 8'b0;
   
  #2  rst = 1'b1;
  #10  done_alu =1'b1; 
  resultado= 8'b00000100;
  #2 done_alu =1'b0;
  
  #10 done_tx = 1'b1;
  #2 done_tx =1'b0;
  
   #10  done_alu =1'b1; 
   resultado= 8'b00000110;
   #2 done_alu =1'b0;
  
  #1000 $finish;
end // initial

always #1 clk = ~clk;

    interfaz_tx  
    #(.NB_DATA           (NB_DBIT_01))
    u_interfaz_01
    (
      .i_clk (clk),
      .i_rst (rst),
      .i_resultado (resultado),
      .i_done_alu (done_alu),
      .i_done_tx(done_tx),
      .o_data (o_data),
      .o_int_tx (tx_start)
    );


endmodule
