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


module tb_intTx_alu();

//local parameters
localparam  NB_DBIT_01    =  8;
localparam NB_OPER_01 = 6;
//Inputs
reg  clk;
reg  rst;
reg done_tx;

//Outputs
wire  signed       [NB_DBIT_01-1:0]        o_data;
wire tx_start;
wire tx_done_alu;

reg  signed       [NB_DBIT_01-1:0]        o_data_bus_a;
reg  signed       [NB_DBIT_01-1:0]        o_data_bus_b;
reg  [NB_OPER_01-1:0]    o_data_operador;
reg [NB_DBIT_01-1:0]  rx_alu_done;

wire [NB_DBIT_01-1:0] alu_resultado;
initial begin
  #0
  rst = 1'b0;
  clk = 1'b0;
  done_tx = 1'b0;
  o_data_bus_a= 8'b00000100;
  o_data_bus_b= 8'b00000010;
  o_data_operador= 6'b100000;
  
  #2  rst = 1'b1;
  #10 rx_alu_done=1'b1;
  #2   rx_alu_done=1'b0;
  
  o_data_bus_a= 8'b00000110;
  o_data_bus_b= 8'b00000011;
  o_data_operador= 6'b100010;
  #10 rx_alu_done=1'b1;
  #2   rx_alu_done=1'b0;

  #100000 $finish;
end // initial

always #1 clk = ~clk;

    interfaz_tx  
    #(.NB_DBIT           (NB_DBIT_01))
    u_interfaz_01
    (
      .i_clk (clk),
      .i_rst (rst),
      .i_resultado (alu_resultado),
      .i_done_alu (tx_done_alu),
      .i_done_tx(done_tx),
      .o_data (o_data),
      .o_tx_start (tx_start)
    );
    
      ALU
      #(.NB_DATA           (NB_DBIT_01), .NB_OPERADOR(NB_OPER_01))
      u_alu1
      (
       .i_dato_a(o_data_bus_a),
       .i_dato_b(o_data_bus_b),
       .i_operador(o_data_operador),
       .i_alu_valid(rx_alu_done),
       .o_done_alu(tx_done_alu),
       .o_resultado(alu_resultado)  
      );

endmodule
