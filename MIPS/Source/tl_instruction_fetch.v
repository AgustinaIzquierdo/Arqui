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
        input i_rst,
        input [len-1:0] i_branch_dir, //Salto condicional
        
        output [len-1:0] o_contador_programa,
        output [len-1:0] o_instruccion
    );
    
    wire [len-1:0] adder_mux;
    wire [len-1:0] mux_pc;

 //mux_PC
 mux_pc
 #(
    .len(len)
  )
  (
    .i_pc(adder_mux),
    .i_branch(i_branch_dir),  
    .i_selector(),  //Aca va la linea de control PCSrc
    .o_mux_pc(mux_pc)
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
    .i_mux(mux_pc),
    .o_pc(o_contador_programa)
  );
  
 //ram_instrucciones
 ram_instrucciones
 #(
    .RAM_WIDTH(len),
    .RAM_DEPTH(2048),
    .RAM_PERFORMANCE("LOW_LATENCY"), //VER QUE VA
    .INIT_FILE("")        //VER QUE VA
 )
 u_ram_instrucciones
 (
  .i_addra(o_contador_programa),
  .i_dina(),
  .i_clka(i_clk),
  .i_wea(),
  .i_ena(),
  .i_rsta(i_rst),
  .i_regcea(),
  .o_douta(o_instruccion)  
 );
 
 //sumador
 pc_adder 
 #(
    .len(len)
  )
  u_pc_adder
  (
    .i_pc(o_contador_programa), //VER A DONDE VA
    .i_cte(1),
    .o_adder(adder_mux) //VER A DONDE VA
  );
    
    
endmodule
