`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2019 01:26:26
// Design Name: 
// Module Name: tb_tx
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

module tb_tx();
//local parameters
localparam  NB_DBIT_01    =  8;
localparam NB_TICK_01 = 16;

reg  clk;
reg  rst;
reg  tx_start; //Bit de entrada al RX
reg rate;
reg [NB_DBIT_01-1:0] data;
wire done_tx;
wire tx_o;



initial	
begin
    #0
    clk = 1'b0;
    rate = 1'b0;
    rst = 1'b0;
    data = 8'b0;
    tx_start = 0;
    #10 rst = 1'b1;
    // Test 1: Envío de dato.
    #160 data = 8'b00000110; // Dato a enviar
    
    #160 tx_start = 1'b1; // Enviar ahora
    #10 tx_start = 1'b0;
            
            
    
    #500000000 $finish;
end
    always #2.5 clk=~clk;  // Simulacion de clock.
    always #5 rate=~rate;       // Simulacion de rate.

tx #(.NB_DATA(NB_DBIT_01), .SB_TICK(NB_TICK_01))
u_b
(
    .i_clk(clk),
    .i_rst(rst),
    .i_tx_start(tx_start),   
    .i_data(data),               
    .i_tick(rate),
    .o_done_tx(done_tx),  
    .o_tx(tx_o)      
);

endmodule
