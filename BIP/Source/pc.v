`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2019 10:52:32
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
    parameter NB_PC = 11
)
(
    input i_clk,
    input i_rst,
    input i_enable,
    output reg [NB_PC-1:0] o_addr
);

always @(negedge i_clk) 
begin
    if(!i_rst)
        o_addr <= 0;
    else
    begin
        if(i_enable)
            o_addr <= o_addr + 1'b1;
        else
            o_addr <= o_addr;
    end
end
endmodule
