`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 11:51:14
// Design Name: 
// Module Name: tl_write_back
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

module tl_write_back
    #(
        parameter len = 32,
        parameter NB_SENIAL_CONTROL = 8
    )
    (
        input [len-1:0] i_read_data,
        input [len-1:0] i_result_alu,
        input [NB_SENIAL_CONTROL-1:0] i_senial_control,
        output [len-1:0] o_write_data
    );
    
    mux
    #(
        .len(len)
    )
    u_mux
    (
        .i_a(i_result_alu),
        .i_b(i_read_data),
        .i_selector(i_senial_control[4]),
        .o_mux(o_write_data)
    );
endmodule
