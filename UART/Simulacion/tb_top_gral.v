`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2019 18:21:37
// Design Name: 
// Module Name: tb_top_gral
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
module tb_top_gral();
//local parameters
localparam  NB_DATA    =  8;
localparam SB_TICK = 16;
localparam  NB_OPERADOR    =  6;

reg clk;
reg rst;
reg rate;
// VARIABLES
    //TX con INTERFAZ
wire tx_interfaz_done_data;
wire [NB_DATA-1:0] interfaz_tx_data;
wire int_tx;  
    //RX con INTERFAZ
wire rx_interfaz_done_data;
wire [NB_DATA-1:0] rx_interfaz_data;
    //ALU con INTERFACES
wire [NB_DATA-1 : 0] dato_a;
wire [NB_DATA-1 : 0] dato_b;
wire [NB_OPERADOR-1 : 0] operador;
wire rx_alu_done;
wire done_alu_tx;
wire [NB_DATA-1 : 0] resultado;

//TX CPU
wire tx_cpu;
reg cpu_rx;

initial	
begin
    clk = 1'b0;
    rate = 1'b0;
    rst = 1'b0;
    cpu_rx= 1'b1; //Bit parada
    
    #10 rst= 1'b1; //Desactiva el reset
    #160 cpu_rx = 1'b0; //bit inicio
            
    #160 cpu_rx = 1'b0; // dato - 8 bits   6
    #160 cpu_rx = 1'b1; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
    #160 cpu_rx = 1'b1; // o sea, cada 10 instantes de tiempo hay un nuevo tick
    #160 cpu_rx = 1'b0; // entonces 16 * 10 = 160
    #160 cpu_rx = 1'b0;
    #160 cpu_rx = 1'b0;
    #160 cpu_rx = 1'b0;
    #160 cpu_rx = 1'b0;
    
    #160 cpu_rx = 1'b1; //bits stop
    
    #160 cpu_rx = 1'b0; //bit inicio
             
     #160 cpu_rx = 1'b1; // dato - 8 bits  1
     #160 cpu_rx = 1'b0; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
     #160 cpu_rx = 1'b0; // o sea, cada 10 instantes de tiempo hay un nuevo tick
     #160 cpu_rx = 1'b0; // entonces 16 * 10 = 160
     #160 cpu_rx = 1'b1;
     #160 cpu_rx = 1'b0;
     #160 cpu_rx = 1'b0;
     #160 cpu_rx = 1'b0;
     
     #160 cpu_rx = 1'b1; //bits stop
     
     #160 cpu_rx = 1'b0; //bit inicio
             
     #160 cpu_rx = 1'b1; // dato - 8 bits 
     #160 cpu_rx = 1'b1; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
     #160 cpu_rx = 1'b1; // o sea, cada 10 instantes de tiempo hay un nuevo tick
     #160 cpu_rx = 1'b0; // entonces 16 * 10 = 160
     #160 cpu_rx = 1'b0;
     #160 cpu_rx = 1'b1;
     #160 cpu_rx = 1'b0;
     #160 cpu_rx = 1'b0;
     
     #160 cpu_rx = 1'b1; //bits stop
    
      #160 cpu_rx = 1'b0; //bit inicio
                
        #160 cpu_rx = 1'b0; // dato - 8 bits   6
        #160 cpu_rx = 1'b1; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
        #160 cpu_rx = 1'b1; // o sea, cada 10 instantes de tiempo hay un nuevo tick
        #160 cpu_rx = 1'b0; // entonces 16 * 10 = 160
        #160 cpu_rx = 1'b0;
        #160 cpu_rx = 1'b0;
        #160 cpu_rx = 1'b0;
        #160 cpu_rx = 1'b0;
        
        #160 cpu_rx = 1'b1; //bits stop
        
        #160 cpu_rx = 1'b0; //bit inicio
                 
         #160 cpu_rx = 1'b1; // dato - 8 bits  1
         #160 cpu_rx = 1'b0; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
         #160 cpu_rx = 1'b1; // o sea, cada 10 instantes de tiempo hay un nuevo tick
         #160 cpu_rx = 1'b0; // entonces 16 * 10 = 160
         #160 cpu_rx = 1'b0;
         #160 cpu_rx = 1'b0;
         #160 cpu_rx = 1'b0;
         #160 cpu_rx = 1'b0;
         
         #160 cpu_rx = 1'b1; //bits stop
         
         #160 cpu_rx = 1'b0; //bit inicio
                 
         #160 cpu_rx = 1'b0; // dato - 8 bits 
         #160 cpu_rx = 1'b0; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
         #160 cpu_rx = 1'b0; // o sea, cada 10 instantes de tiempo hay un nuevo tick
         #160 cpu_rx = 1'b0; // entonces 16 * 10 = 160
         #160 cpu_rx = 1'b0;
         #160 cpu_rx = 1'b1;
         #160 cpu_rx = 1'b0;
         #160 cpu_rx = 1'b0;
         
         #160 cpu_rx = 1'b1; //bits stop
    #500000000 $finish;
end
always #2.5 clk=~clk;  // Simulacion de clock.
always #5 rate=~rate;       // Simulacion de rate.

tx #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
u_tx
(
    .i_clk(clk),
    .i_rst(rst),
    .i_tx_start(int_tx),
    .i_tick(rate),
    .i_data(interfaz_tx_data),       
    .o_done_tx(tx_interfaz_done_data),       
    .o_tx(tx_cpu) 
);

rx #(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
u_rx
(
    .i_clk(clk),
    .i_rst(rst),
    .i_bit(cpu_rx),                  
    .i_tick(rate),
    .o_done_data(rx_interfaz_done_data),  
    .o_data(rx_interfaz_data)      
);

    interfaz_tx #(.NB_DATA(NB_DATA))
    u_interfaztx
(
    .i_clk(clk),
    .i_rst(rst),
    .i_resultado(resultado), //Resultado proveniente de la ALU
    .i_done_alu(done_alu_tx), //ALU notifica que tiene el resultado
    .i_done_tx(tx_interfaz_done_data), //Tx avisa a la interfaz que esta libre para procesar datos
    .o_data(interfaz_tx_data), //Resultado enviado al TX
    .o_int_tx(int_tx) //Indicador de dato valido para transmitir
);


    interfaz_rx #(.NB_DATA(NB_DATA), .NB_OPERADOR(NB_OPERADOR))
    u_interfazrx
(
    .i_clk(clk),
    .i_rst(rst),
    .i_data(rx_interfaz_data), //Dato proveniente del RX
    .i_done_data(rx_interfaz_done_data), //Dato listo para pasarle a la interfaz
    .o_a(dato_a), 
    .o_b(dato_b), 
    .o_op(operador), 
    .o_rx_alu_done(rx_alu_done) //Notifica a la ALU que tiene los datos listos
);

    ALU #(.NB_DATA(NB_DATA), .NB_OPERADOR(NB_OPERADOR))
    u_alu
(
     .i_dato_a(dato_a),
     .i_dato_b(dato_b),
     .i_operador(operador),
     .i_alu_valid(rx_alu_done),
     .o_done_alu_tx(done_alu_tx), //ALU notifica que tiene el resultado
     .o_resultado(resultado) 
);

endmodule
