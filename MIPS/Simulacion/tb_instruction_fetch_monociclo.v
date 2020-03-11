`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_fetch_monociclo
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


module tb_instruction_fetch_monociclo();

localparam len=32;

reg clk;
reg rst;
reg [len-1:0] branch_dir;
reg PCSrc;
wire [len-1:0] instruccion;
wire [len-1:0] adder;


initial
begin
    clk = 1'b0;
    rst = 1'b0;
    branch_dir =0;
    PCSrc =0;
    #10 rst= 1'b1; //Desactiva el reset
    #10   PCSrc =1'b1;
        branch_dir = 32'h00000040;
        
    #1 PCSrc = 1'b0;
    
    #500 $finish;
end


always #2.5 clk=~clk;



tl_instruction_fetch
#(
    .len(len),
    .INIT_FILE_IM("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/instruction_memory.txt") //
)
    u_tl_instruction_fetch
(
    .i_clk(clk),
    .i_rst(rst),
    .i_branch_dir(branch_dir),
    .i_PCSrc(PCSrc),
    .o_instruccion(instruccion),
    .o_adder(adder)
);

endmodule
