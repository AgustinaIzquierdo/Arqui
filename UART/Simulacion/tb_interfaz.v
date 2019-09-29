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


module tb_interfaz_rx();

//local parameters
localparam  NB_DBIT_01    =  8;

//Inputs
reg  clk;
reg  rst;
reg [NB_DBIT_01-1:0] data;
reg done_data;

//Outputs
wire  signed       [NB_DBIT_01-1:0]        o_data_bus_a;
wire  signed       [NB_DBIT_01-1:0]        o_data_bus_b;
wire  [NB_DBIT_01-1:0]    o_data_operador;
wire rx_alu_done;

initial begin
  #0
  rst = 1'b0;
  clk = 1'b0;
  done_data = 1'b0;
  data = 8'b0;
   
  #2  rst = 1'b1;
  #10  done_data =1'b1; 
  data= 8'b00000100;
  #2 done_data =1'b0;
  #10  done_data =1'b1; 
  data= 8'b00000010;
  #1 done_data =1'b0;
  #10  done_data =1'b1; 
  data= 8'b00001000;
  #1 done_data =1'b0;
  
  #100000 $finish;
end // initial

always #1 clk = ~clk;

    interfaz_rx 
    #(.NB_DBIT           (NB_DBIT_01))
    u_interfaz_01
    (
      .i_clk (clk),
      .i_rst (rst),
      .i_data (data),
      .i_done_data (done_data),
      .o_rx_alu_done(rx_alu_done),
      .o_a (o_data_bus_a),
      .o_b (o_data_bus_b),
      .o_op (o_data_operador)
    );


endmodule
