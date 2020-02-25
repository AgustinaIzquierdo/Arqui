`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 10:54:28
// Design Name: 
// Module Name: tl_execute
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


module tl_execute
#(  
    parameter len = 32    
)
(
    
);

//El shift_left_2 deberia ir acá
//como logica del top este, no módulo aparte.

add_execute
#(  
    .len(len)
)
u_add_execute
(
    .i_add_pc(add_pc),
    .i_shift_sign_extend(shift_sign_extend),
    .o_data(add_excute)
);

mux_execute
#(  
    .len(len)
)
u_mux_execute
(
    .i_dato2(),
    .i_extend_sign()   
);


endmodule
