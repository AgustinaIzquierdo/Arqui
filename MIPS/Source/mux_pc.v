`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 10:57:58
// Design Name: 
// Module Name: mux_pc
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


module mux
    #(
        parameter len = 32
     )
     (
        input [len-1:0] i_a,
        input [len-1:0] i_b,
        input i_selector,
        output [len-1:0] o_mux
     );
     
     assign o_mux = (i_selector) ? i_b : i_a;
     
endmodule
