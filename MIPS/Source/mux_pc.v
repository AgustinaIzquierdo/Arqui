`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2020 10:29:35
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


module mux_pc
   #(
       parameter LEN = 32
    )
    (
       input [LEN-1:0] i_pc,
       input [LEN-1:0] i_jump,
       input [LEN-1:0] i_branch, 
       input [1:0] i_selector,
       output [LEN-1:0] o_mux
     );
     
    assign o_mux = (i_selector == 2'b10) ? i_jump :
                    (i_selector == 2'b01) ? i_branch :
                                            i_pc;
endmodule
