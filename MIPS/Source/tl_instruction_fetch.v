`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 09:53:35
// Design Name: 
// Module Name: tl_instruction_fetch
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


module tl_instruction_fetch 
    #(
        parameter len = 32
    )
    (
        input i_clk,
        input i_rst
    );
    
 //mux_PC
 mux_pc
 #(
    .len(len)
  )
  (
    .i_pc_adder(), //VER A DONDE VA
    .i_execute_add(),  //VER A DONDE VA
    .i_selector(),  //VER A DONDE VA
    .o_mux_pc() //VER A DONDE VA
  );
 
 //pc
 pc
 #(
    .len(len)
  )
  u_pc
  (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_mux(), //VER A DONDE VA
    .o_pc() //VER A DONDE VA
  );
  
 //ram_instrucciones
 ram_instrucciones
 #(
    .RAM_WIDTH(len),
    .RAM_DEPTH(2048),
    .RAM_PERFORMANCE(), //VER QUE VA
    .INIT_FILE()        //VER QUE VA
 )
 u_ram_instrucciones
 (
    // COMPLETAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAR
 );
 
 //sumador
 pc_adder 
 #(
    .len(len)
  )
  u_pc_adder
  (
    .i_pc(), //VER A DONDE VA
    .i_offset(1),
    .o_adder() //VER A DONDE VA
  );
    
    
endmodule
