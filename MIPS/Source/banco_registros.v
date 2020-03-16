`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2020 22:09:09
// Design Name: 
// Module Name: banco_registros
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


module banco_registros
#(
    parameter LEN = 32,
    parameter CANTIDAD_REGISTROS=32,
    parameter NB_ADDRESS_REGISTROS=$clog2(CANTIDAD_REGISTROS)
)
(
    input i_clk,
    input i_rst,
    input [NB_ADDRESS_REGISTROS-1:0] i_read_reg_1,
    input [NB_ADDRESS_REGISTROS-1:0] i_read_reg_2,
    input [NB_ADDRESS_REGISTROS-1:0] i_write_reg,
    input i_reg_write_ctrl,
    input [LEN-1:0] i_write_data,
    output reg [LEN-1:0] o_read_data_1,
    output reg [LEN-1:0] o_read_data_2
);

reg [CANTIDAD_REGISTROS-1:0] registros [LEN-1:0];
//Inicializacion del banco de registros
generate
    integer indice;
    initial
        for (indice=0; indice < CANTIDAD_REGISTROS; indice =indice+1)
            registros[indice] <= {LEN{1'b0+indice}};
endgenerate

always @(negedge i_clk) //Lectura del banco de registros
begin
    if(!i_rst)
    begin
        o_read_data_1 <= 0;
        o_read_data_2 <= 0;
    end
    
    else
    begin
        o_read_data_1 <= registros[i_read_reg_1];
        o_read_data_2 <= registros[i_read_reg_2];
    end
end

always @(posedge i_clk) //Escritura en banco de registros
begin
    if(i_reg_write_ctrl)
        registros[i_write_reg] <= i_write_data;
    
    else
       registros[i_write_reg] <= registros[i_write_reg];
end
endmodule
