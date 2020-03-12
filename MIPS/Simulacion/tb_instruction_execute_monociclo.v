`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_execute_monociclo
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


module tb_instruction_execute_monociclo();

localparam len=32;
localparam NB_SENIAL_CONTROL = 8;
localparam NB_ALU_CONTROL = 4;

reg [len-1:0] PC_next;
reg [len-1:0] dato1;
reg [len-1:0] dato2;
reg [len-1:0] sign_extend;
reg [NB_SENIAL_CONTROL-1:0] senial_control;
reg [NB_ALU_CONTROL-1:0] alu_control;
wire [len-1:0] branch_dir;
wire [len-1:0] result_alu;
wire PCScr;

initial
begin
    #2 PC_next=1; //Tipo R
       dato1=2;
       dato2=3;
       sign_extend=32'h00000010;
       senial_control= 8'b10000001;
       alu_control=4'b0010;
    
    #10 PC_next=10; //Branch
        dato1=2;
        dato2=2;
        sign_extend=32'h00000010;
        senial_control= 8'b00000100;
        alu_control=4'b0110;
    
    #10 PC_next=10; //Load
        dato1=2;
        dato2=2;
        sign_extend=32'h00000010;
        senial_control= 8'b11011000;
        alu_control=4'b0010;
            
    #500 $finish;
end


tl_execute
#(
    .len(len),
    .NB_SENIAL_CONTROL(NB_SENIAL_CONTROL),
    .NB_ALU_CONTROL(NB_ALU_CONTROL)
)
    u_tl_execute
(
    .i_adder_if(PC_next),
    .i_dato1(dato1),
    .i_dato2(dato2),
    .i_sign_extend(sign_extend),
    .i_senial_control(senial_control),
    .i_alu_control(alu_control),
    .o_add_excute(branch_dir),
    .o_alu_result(result_alu),
    .o_PCSrc(PCScr)
);

endmodule
