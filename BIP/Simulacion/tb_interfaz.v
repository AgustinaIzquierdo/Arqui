`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 18:47:10
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


module tb_interfaz();

localparam DATA = 8;
localparam ADDR =11;
localparam OPCODE =5;
localparam RAM =16;
localparam TICK= 16;

reg clk;
reg rst;
reg [OPCODE-1:0] opcode;
reg [RAM-1:0] acc;
reg [ADDR-1:0] pc;
wire bip_enable;
reg tick;
wire i_int_tx; //Indicador de dato valido para transmitir
wire [DATA-1:0] i_interfaz_tx_data; //Dato de la interfaz al tx
reg i_rx; //Recibe de la computadora bit a bit
wire o_tx_interfaz_done_data; //Tx avisa a la interfaz que esta libre para procesar datos
wire o_tx; //Envia a la computadora bit a bit
wire o_rx_interfaz_done_data; //Dato listo para pasarle a la interfaz
wire [DATA-1:0] o_rx_interfaz_data; //Dato del rx a la interfaz

initial
begin
    clk = 1'b0;
    tick = 1'b0;
    rst = 1'b0;
    opcode= 5'b1;
    i_rx= 1'b1; //Bit parada
    pc=11'b11001000011;
    acc=16'b0101011001000011;
    #10 rst= 1'b1; //Desactiva el reset
    #160 i_rx = 1'b0; //bit inicio
            
    #160 i_rx = 1'b0; // dato - 8 bits
    #160 i_rx = 1'b1; // 160 viene dado porque cada 5 instantes de tiempo cambia el estado del rate
    #160 i_rx = 1'b1; // o sea, cada 10 instantes de tiempo hay un nuevo tick
    #160 i_rx = 1'b0; // entonces 16 * 10 = 160
    #160 i_rx = 1'b0;
    #160 i_rx = 1'b0;
    #160 i_rx = 1'b0;
    #160 i_rx = 1'b0;
    
    #160 i_rx = 1'b1; //bits stop
    
    #20 opcode = 5'b01100;
    
    #20 opcode = 0;
    #500000000 $finish;
end


always #2.5 clk=~clk;
always #5 tick=~tick;



interfaz
#(
    .NB_DATA(DATA),
    .NB_OPCODE(OPCODE),
    .NB_ADDR(ADDR),
    .RAM_WIDTH(RAM)
)
u_agu
(
    .i_clk(clk),
    .i_rst(rst),
    .i_data(o_rx_interfaz_data),
    .i_done_data(o_rx_interfaz_done_data),
    .i_opcode(opcode),
    .i_acc(acc),
    .i_pc(pc),
    .i_done_tx(o_tx_interfaz_done_data),
    .o_int_tx(i_int_tx),
    .o_uart(i_interfaz_tx_data),
    .o_bip(bip_enable)
);

tx #(.NB_DATA(DATA), .SB_TICK(TICK))
u_agu1
(
    .i_clk(clk),
    .i_rst(rst),
    .i_tx_start(i_int_tx),
    .i_tick(tick),
    .i_data(i_interfaz_tx_data),       
    .o_done_tx(o_tx_interfaz_done_data),       
    .o_tx(o_tx) 
);

rx #(.NB_DATA(DATA), .SB_TICK(TICK))
u_agu2
(
    .i_clk(clk),
    .i_rst(rst),
    .i_bit(i_rx),                  
    .i_tick(tick),
    .o_done_data(o_rx_interfaz_done_data),  
    .o_data(o_rx_interfaz_data)      
);


endmodule
