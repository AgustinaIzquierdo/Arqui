`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2019 18:01:45
// Design Name: 
// Module Name: tb_rx
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
module tb_rx();

//local parameters
localparam  NB_DBIT_01    =  8;
localparam NB_TICK_01 = 16;
reg  clk;
reg  rst;
reg  rx; //Bit de entrada al RX
reg rate;
wire [NB_DBIT_01-1:0] data;
wire done_data_interfaz;



initial	
begin
    clk = 1'b0;
    rate = 1'b0;
    rst = 1'b0;
    rx= 1'b1; //Bit parada
    
    #10 rst= 1'b1; //Desactiva el reset
    #160 rx = 1'b0; //bit inicio
            
    #160 rx = 1'b0; // dato - 8 bits (1001 0110)
    #160 rx = 1'b1; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
    #160 rx = 1'b1; // o sea, cada 10 instantes de tiempo hay un nuevo tick
    #160 rx = 1'b0; // entonces 16 * 10 = 160
    #160 rx = 1'b0;
    #160 rx = 1'b0;
    #160 rx = 1'b0;
    #160 rx = 1'b0;
    
    #160 rx = 1'b1; //bits stop
    #500000000 $finish;
end
always #2.5 clk=~clk;  // Simulacion de clock.
always #5 rate=~rate;       // Simulacion de rate.


rx #(.NB_DATA(NB_DBIT_01), .SB_TICK(NB_TICK_01))
u_a
(
    .i_clk(clk),
    .i_rst(rst),
    .i_bit(rx),                  
    .i_tick(rate),
    .o_done_data(done_data_interfaz),  
    .o_data(data)      
);


endmodule
