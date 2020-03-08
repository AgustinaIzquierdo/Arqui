`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 11:38:13
// Design Name: 
// Module Name: tl_memory
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


module tl_memory
    #(
        parameter len = 32,
        parameter NB_SENIAL_CONTROL = 8
    )
    (
        input i_clk,
        input i_rst,
        input [len-1:0] i_address,
        input [len-1:0] i_write_data,
        input [NB_SENIAL_CONTROL-1:0] i_senial_control,
        output [len-1:0] o_read_data
    );
    
    wire rsta_mem;  
    wire regcea_mem;
    
    //Control Memoria
    assign rsta_mem =0;
    assign regcea_mem=1;
    
    ram_datos
    #(
        .RAM_WIDTH(len),
        .RAM_DEPTH(2048),        
        .RAM_PERFORMANCE("LOW_LATENCY"),
        .INIT_FILE()        
     )
     u_ram_datos
     (
        .i_addra(i_address),
        .i_dina(i_write_data), //Ver de donde viene
        .i_clka(i_clk),
        .i_wea(i_senial_control[5]),  //Ver de donde viene
        .i_ena(i_senial_control[3]), //Ver de donde viene
        .i_rsta(rsta_mem),
        .i_regcea(regcea_mem), 
        .o_douta(o_read_data) 
     );
endmodule
