`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2019 11:08:40
// Design Name: 
// Module Name: datapath
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


module datapath
#(
    parameter NB_DECODER_SEL_A = 2,
    parameter NB_OPERANDO = 11,
    parameter NB_OPCODE = 5,
    parameter NB_DATA = 16
)
(
    input i_clk,
    input i_rst,
    input [NB_DECODER_SEL_A-1:0] i_selA,
    input i_selB,
    input i_wrAcc,
    input [NB_OPCODE-1:0] i_op,
    input [NB_OPERANDO-1:0] i_operando,
    input [NB_DATA-1:0] i_data,
    output [NB_DATA-1:0] o_data
);

localparam NB_EXT = (NB_DATA-NB_OPERANDO);

wire [NB_DATA-1:0] operando_ext;
wire [NB_DATA-1:0] muxA;
wire [NB_DATA-1:0] muxB;
wire [NB_DATA-1:0] resultado_op;
reg [NB_DATA-1:0] acc;

assign operando_ext = (i_operando[NB_DATA-1]==1'b1)? {{(NB_EXT){1'b1}},i_operando}: {{(NB_EXT){1'b0}},i_operando} ;

assign muxA = (i_selA==2'b00) ? i_data : 
                (i_selA==2'b01) ? operando_ext:
                (i_selA==2'b10) ? resultado_op:
                2'b00;
                
assign muxB = (i_selB==1'b0) ? i_data : operando_ext;

always @(posedge i_clk)
begin
    if(!i_rst)
        acc <= {NB_DATA{1'b0}};
    else
        acc <= (i_wrAcc==1'b1)? muxA : acc;
end

assign resultado_op = (i_op==5'b00110 || i_op==5'b00111) ? acc - muxB :
                      (i_op==5'b00100 || i_op==5'b00101) ? acc + muxB :
                       {NB_DATA{1'b0}};

assign o_data = acc;

endmodule
