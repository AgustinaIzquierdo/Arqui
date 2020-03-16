`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 10:34:17
// Design Name: 
// Module Name: pc
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


module pc
    #(
        parameter LEN = 32
    )
    (
        input i_clk,
        input i_rst,
        input [LEN-1:0] i_mux,
        output reg [LEN-1:0] o_pc
    );
    
always @(negedge i_clk)
begin
    if(!i_rst)
        o_pc <= 0;
    else
        o_pc <= i_mux;    
end
endmodule
