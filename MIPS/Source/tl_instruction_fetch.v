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
        parameter LEN = 32,
        parameter INIT_FILE_IM="/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/instruction_memory.txt"
    )
    (
        input i_clk,
        input i_rst,
        input [LEN-1:0] i_branch_dir, //Salto condicional
        input i_PCSrc,
        input i_flag_stall,
        input i_flag_jump,
        input [LEN-1:0] i_dir_jump,  //Salto incondicional
        input [LEN-1:0] i_dir_mem_instr,
        input i_wea_mem_instr,
        input [LEN-1:0] i_addr_mem_inst,
        output reg [LEN-1:0] o_instruccion,
        output reg [LEN-1:0] o_adder,
        output reg [LEN-1:0] o_contador_programa, //DEBUG UNIT
        output o_flag_halt
    );
    
    //Cables-Reg hacia/desde mux 
    wire [LEN-1:0] contador_programa;
    
    //Cables-Reg hacia/desde mux 
    wire [LEN-1:0] mux_pc;
    
    //Cables-Reg hacia/desde adder 
    wire [LEN-1:0] adder;
   
    //Cables-Reg hacia/desde memoria 
    wire [LEN-1:0] instruccion;
    wire rsta_mem;
    wire regcea_mem;
   
    wire flush; 
    //Control Memoria
    assign rsta_mem =0;
    assign regcea_mem=1;
    
    assign flush = i_PCSrc | i_flag_jump;
    
 always @(negedge i_clk)
 begin
    if(!i_rst)
    begin
        o_adder <= 32'b0;
        o_instruccion <= 32'b0;
        o_contador_programa <= 32'h0;
    end
    else
    begin
        if(flush) //flush
        begin
            o_adder <= 32'b0;
            o_instruccion <= 32'b0;
        end
        else
        begin
            if(i_flag_stall==1'b1)
            begin
                o_adder <= o_adder;
                o_instruccion <= o_instruccion;
                o_contador_programa <= o_contador_programa;
            end
            else
            begin
                o_adder <= adder;
                o_instruccion <= instruccion;
                o_contador_programa <= contador_programa;
            end
        end
    end
 end
 
 //mux_PC
 mux_pc
 #(
    .LEN(LEN)
  )
  u_mux
  (
    .i_pc(adder),  //adder
    .i_jump(i_dir_jump),  
    .i_branch(i_branch_dir),
    .i_selector({i_flag_jump,i_PCSrc}),  
    .o_mux(mux_pc)
  );
 
 //pc
 pc
 #(
    .LEN(LEN)
  )
  u_pc
  (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_mux(mux_pc),
    .i_enable(i_flag_stall),
    .o_pc(contador_programa)
  );
  
 //ram_instrucciones
 ram_instrucciones
 #(
    .RAM_WIDTH(LEN),
    .RAM_DEPTH(2048),
    .RAM_PERFORMANCE("LOW_LATENCY"), //No hace uso de registros (ahorra un ciclo de clock al no usar reg)
    .INIT_FILE(INIT_FILE_IM)        
 )
 u_ram_instrucciones
 (
  .i_addra((!i_rst)? i_addr_mem_inst: contador_programa),
  .i_dina(i_dir_mem_instr), 
  .i_clka(i_clk),
  .i_wea(i_wea_mem_instr),  
  .i_ena(!i_flag_stall),
  .i_rsta(rsta_mem),
  .i_regcea(regcea_mem), 
  .o_douta(instruccion),
  .o_halt(o_flag_halt)  
 );
 
 //sumador
 adder_fetch 
 #(
    .LEN(LEN)
  )
  u_adder_fetch
  (
    .i_a(contador_programa), 
    .i_b(32'h00000001),
    .i_enable(!o_flag_halt),
    .o_adder(adder) 
  );
    
    
endmodule
