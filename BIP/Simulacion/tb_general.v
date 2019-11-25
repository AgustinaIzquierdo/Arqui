`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2019 16:11:27
// Design Name: 
// Module Name: tb_general
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


module tb_general();

localparam DECODER_SEL_A=5;
localparam DATA = 8;
localparam ADDR =11;
localparam OPCODE =5;
localparam OPERANDO =11;
localparam RAM =16;
localparam TICK= 16;
localparam DEPTH=2048;
localparam RAM_PER= "LOW_LATENCY";
localparam FILE_PM ="/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/BIP/Source/instrucciones.txt" ;


reg clk;
reg rst;
reg tick;
wire i_int_tx; //Indicador de dato valido para transmitir
wire [DATA-1:0] i_interfaz_tx_data; //Dato de la interfaz al tx
reg i_rx; //Recibe de la computadora bit a bit
wire o_tx_interfaz_done_data; //Tx avisa a la interfaz que esta libre para procesar datos
wire o_tx; //Envia a la computadora bit a bit
wire o_rx_interfaz_done_data; //Dato listo para pasarle a la interfaz
wire [DATA-1:0] o_rx_interfaz_data; //Dato del rx a la interfaz
wire [OPCODE-1:0] opcode_pm;
wire [OPERANDO-1:0] operando_pm;
wire [RAM-1:0] instruction_pm;
wire [RAM-1:0] o_data_dm;
wire [ADDR-1:0] o_counter;
wire wr_en;
wire [RAM-1:0] in_data_dm;
wire [ADDR-1:0] addr_pm;
wire reset;

initial
begin
    clk = 1'b0;
    tick = 1'b0;
    rst = 1'b0;
    i_rx= 1'b1; //Bit parada
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
    
    
    #5000 $finish;
end


always #2.5 clk=~clk;
always #5 tick=~tick;

assign opcode_pm = instruction_pm [RAM -1 -: OPCODE];
assign operando_pm = instruction_pm [OPERANDO-1 : 0];

cpu
#(  
    .NB_DECODER_SEL_A(DECODER_SEL_A),
    .NB_OPCODE(OPCODE),
    .NB_ADDR(ADDR),
    .NB_OPERANDO(OPERANDO),
    .RAM_WIDTH(RAM)
)
    u_cpu
(
    .i_clk(clk),
    .i_rst(reset),
    .i_opcode_pm(opcode_pm),
    .i_operando_pm(operando_pm),
    .i_data(o_data_dm), //DATA MEMORY
    .o_wr_en(wr_en),
    .o_data(in_data_dm), //DATA MEMORY
    .o_addr_pm(addr_pm)
);
    
    program_memory
#(
    .RAM_WIDTH(RAM),
    .RAM_DEPTH(DEPTH),
    .RAM_PERFORMANCE(RAM_PER),
    .INIT_FILE(FILE_PM)
)
    u_program_memory
(
    .i_clk(clk),
    .i_addr(addr_pm),
    .o_data(instruction_pm)
);

   data_memory
#(
    .RAM_WIDTH(RAM),
    .RAM_DEPTH(DEPTH),
    .RAM_PERFORMANCE(RAM_PER),
    .INIT_FILE("")
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
    .NB_ADDR(ADDR)
)
    u_count2_clock
(
    .i_clk(clk),
    .i_rst(reset),
    .i_opcode(opcode_pm),
    .o_counter(o_counter)
);


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
    .i_opcode(opcode_pm),
    .i_acc(in_data_dm),
    .i_pc(o_counter),
    .i_done_tx(o_tx_interfaz_done_data),
    .o_int_tx(i_int_tx),
    .o_uart(i_interfaz_tx_data),
    .o_ctrl_reset(reset)
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
