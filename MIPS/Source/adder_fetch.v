`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2020 10:34:48
// Design Name: 
// Module Name: adder_fetch
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


module adder_fetch
    #(
        parameter LEN=32
    )
    (
        input [LEN-1:0] i_a,
        input [LEN-1:0] i_b,
        input i_enable,
        output [LEN-1:0] o_adder
    );
    
    assign o_adder = i_enable==1'b1 ? i_a + i_b : i_a; 
endmodule

