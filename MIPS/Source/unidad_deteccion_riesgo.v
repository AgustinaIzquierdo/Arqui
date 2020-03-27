`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2020 10:13:43
// Design Name: 
// Module Name: unidad_deteccion_riesgo
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


module unidad_deteccion_riesgo
#(
    parameter LEN = 32,
    parameter NB_ADDRESS_REGISTROS=5  
)
(
    input [NB_ADDRESS_REGISTROS-1:0] i_rs_id,
    input [NB_ADDRESS_REGISTROS-1:0] i_rt_id,
    input [NB_ADDRESS_REGISTROS-1:0] i_rt_ex, 
    input i_memRead_ex,
    output o_flag_stall
);
    assign o_flag_stall = ( (i_memRead_ex == 1'b1) & ((i_rs_id==i_rt_ex) | (i_rt_id==i_rt_ex))) ? 1'b1 : 1'b0;
    
endmodule
