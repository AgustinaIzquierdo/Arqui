
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2019 23:04:29
// Design Name: 
// Module Name: interfaz
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
module interfaz # ( parameter W = 8) //bits buffer 
(
    input i_clk,
    input i_rst,
    input i_clr_flag,
    input i_set_flag,
    input [W-1:0] i_din,
    output o_flag,
    output [W-1:0] o_dout    
);

//declaracion de señales
reg [W-1:0] buf_reg;
reg [W-1:0] buf_next;
reg flag_reg;
reg flag_next;

//FF y registro
always @(posedge i_clk or posedge i_rst)
begin
    if(i_rst)
    begin
        buf_reg <= 0 ;
        flag_reg <= 1'b0; 
    end
    else
    begin
        buf_reg <= buf_next;
        flag_reg <= flag_next;
    end
end

//logica siguiente estado
always @(*)
begin
    buf_next = buf_reg;
    flag_next = flag_reg;
    if(i_set_flag)
    begin
        buf_next = i_din;
        flag_next = 1'b1; 
    end
    else if(i_clr_flag)
        flag_next = 1'b0;
end

//logica de salida
assign o_dout = buf_reg;
assign flag = flag_reg;


endmodule