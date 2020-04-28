`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2020 09:16:26
// Design Name: 
// Module Name: debug_unit
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


module debug_unit
     #(
        parameter LEN = 32,
        parameter LEN_UART= 8,
        parameter CANT_REG = 16,
        parameter CANT_MEM = 10,
        parameter NB_IF_ID = 96,
        parameter NB_ID_EX = 160,
        parameter NB_EX_MEM = 128,
        parameter NB_MEM_WB = 96
    )
    (
        input i_clk,
        input i_rst,
        input i_halt,
        input [NB_IF_ID-1:0] i_if_id,
        input [NB_ID_EX-1:0] i_id_ex,
        input [NB_EX_MEM-1:0] i_ex_mem,
        input [NB_MEM_WB-1:0] i_mem_wb,
        input i_tx_done, //Fin de la transmision
        input i_rx_done, //Fin de la recepcion
        input [LEN_UART-1:0] i_uart_data, //Dato recibido del RX
        output o_tx_start,  //Voy a comenzar a transmitir
        output [LEN_UART-1:0] o_uart_data //Dato a transmitir por TX
    );

 /*
    Estados
  */
  localparam [2:0]  IDLE           = 3'b 000,   //Espera por senial start
                    PROGRAMMING    = 3'b 001,   //Recepcion instr. hasta deteccion de halt
                    WAITING        = 3'b 010,   //Seleccion de modo de operacion
                    STEP_BY_STEP   = 3'b 011,   //Modo step by step
                    SENDING_DATA   = 3'b 100,   //Envio de datos
                    CONTINUOUS     = 3'b 101;   //Modo continuo

  localparam [2:0]  SUB_INIT       = 3'b 000,  //Sublogica de recepcion de instrucciones
                    SUB_READ_1     = 3'b 001,  
                    SUB_READ_2     = 3'b 010,
                    SUB_READ_3     = 3'b 011,
                    SUB_READ_4     = 3'b 100,
                    SUB_WRITE_MEM  = 3'b 101; 
    
    
endmodule
