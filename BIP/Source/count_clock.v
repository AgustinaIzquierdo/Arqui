`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2019 18:41:23
// Design Name: 
// Module Name: count_clock
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


module count_clock
#(
    parameter NB_OPCODE = 5,
    parameter NB_ADDR = 11
)
(
    input i_clk,
    input i_rst,
    input [NB_OPCODE-1:0] i_opcode,
    output reg [NB_ADDR-1:0] o_counter
);

always @(posedge i_clk)
begin
    if(!i_rst)
        o_counter <= 1'b1;
    else if(i_opcode != 0)
        o_counter <= o_counter + 1'b1;
    else
        o_counter <= o_counter;
end
endmodule
