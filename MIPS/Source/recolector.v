`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2020 10:50:47
// Design Name: 
// Module Name: recolector
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


module recolector
#(
    parameter LEN = 32,
    parameter CANT_REG = 16,
    parameter CANT_MEM = 8        
)
(
    input i_clk,
    input i_rst,
    input [LEN-1:0] i_reg,
    input [LEN-1:0] i_mem_datos,
    input i_enable_next,
    input i_send_regs,
    output reg [$clog2(CANT_REG)-1:0] o_addr_reg,
    output reg [$clog2(CANT_MEM)-1:0] o_addr_mem,
    output reg [LEN-1:0] o_data    
);

always @(posedge i_clk) begin
    if (i_rst) begin
        o_addr_reg <= 0;
        o_addr_mem <= 0;
        o_data <= 0;
    end
    else if (i_enable_next) begin
        if (i_send_regs) begin
            o_addr_mem <= o_addr_mem;
            o_data <= i_reg;
            o_addr_reg <= o_addr_reg + 1;
        end 
        else begin
            o_addr_reg <= o_addr_reg;
            o_data <= i_mem_datos;    		 	    			
            o_addr_mem <= o_addr_mem + 1;
        end
    end
end

endmodule
