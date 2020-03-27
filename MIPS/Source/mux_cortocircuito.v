`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2020 09:19:32
// Design Name: 
// Module Name: mux_cortocircuito
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


module mux_cortocircuito
    #(
        parameter LEN = 32
     )
     (
        input [LEN-1:0] i_dato,
        input [LEN-1:0] i_mem_corto,
        input [LEN-1:0] i_wb_corto, 
        input [1:0] i_selector,
        output [LEN-1:0] o_mux
     );
     
     assign o_mux = (i_selector == 2'b00) ? i_dato :
                    (i_selector == 2'b01) ? i_mem_corto :
                                            i_wb_corto;
     
endmodule
