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
        parameter len = 32
    )
    (
        input i_clk,
        input i_rst,
        input [len-1:0] i_address,
        input [len-1:0] i_write_data,
        output [len-1:0] o_read_data
    );
    
    ram_datos
    #(
        .RAM_WIDTH(len),
        .RAM_DEPTH(),        //VER QUE VA
        .RAM_PERFORMANCE(), //VER QUE VA
        .INIT_FILE()        //VER QUE VA
     )
     u_ram_datos
     (
        // COMPLETAAAAAAAAAR
     );
endmodule
