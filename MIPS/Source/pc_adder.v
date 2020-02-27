`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 10:15:25
// Design Name: 
// Module Name: pc_adder
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


module pc_adder 
    #(
        parameter len=32
    )
    (
        input [len-1:0] i_pc,
        input i_cte,
        output [len-1:0] o_adder
    );
    
    assign o_adder = i_pc + i_cte; 
endmodule
