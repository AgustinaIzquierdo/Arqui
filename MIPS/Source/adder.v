`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2020 15:42:34
// Design Name: 
// Module Name: adder
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


module adder 
    #(
        parameter LEN=32
    )
    (
        input [LEN-1:0] i_a,
        input [LEN-1:0] i_b,
        output [LEN-1:0] o_adder
    );
    
    assign o_adder = i_a + i_b; 
endmodule
