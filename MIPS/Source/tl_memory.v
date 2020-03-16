`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 11:38:13
// Design Name: 
// Module Name: tl_memory
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


module tl_memory
    #(
        parameter LEN = 32,
        parameter NB_SENIAL_CONTROL = 8
    )
    (
        input i_clk,
        input i_rst,
        input [LEN-1:0] i_address,
        input [LEN-1:0] i_write_data,
        input [NB_SENIAL_CONTROL-1:0] i_senial_control,
        output reg [LEN-1:0] o_address,
        output reg [LEN-1:0] o_read_data
    );
    
//Cables-Reg hacia/desde memoria de datos    
wire rsta_mem;  
wire regcea_mem;
wire [LEN-1:0] read_data;
  
//Control Memoria
assign rsta_mem =0;
assign regcea_mem=1;

always @(negedge i_clk)
if(!i_rst)
begin
    o_address <= 32'b0;
    o_read_data <= 32'b0;
end
else
begin
    o_address <= i_address;
    o_read_data <= read_data;
end
  
ram_datos
#(
    .RAM_WIDTH(LEN),
    .RAM_DEPTH(2048),        
    .RAM_PERFORMANCE("LOW_LATENCY"),
    .INIT_FILE("")        
 )
 u_ram_datos
 (
    .i_addra(i_address),
    .i_dina(i_write_data), //Ver de donde viene
    .i_clka(i_clk),
    .i_wea(i_senial_control[5]),  //Ver de donde viene
    .i_ena(i_senial_control[3]), //Ver de donde viene
    .i_rsta(rsta_mem),
    .i_regcea(regcea_mem), 
    .o_douta(read_data) 
 );
 
endmodule
