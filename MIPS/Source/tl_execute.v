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
    parameter LEN = 32,
    parameter NB_ADDRESS_REGISTROS = 5,
    parameter NB_ALU_CONTROL = 4,
    parameter NB_CTRL_WB = 2,
    parameter NB_CTRL_MEM = 9,
    parameter NB_CTRL_EX = 8    
)
(
    input i_clk,
    input i_rst,
    input [LEN-1:0] i_adder_id,
    input [LEN-1:0] i_dato1,
    input [LEN-1:0] i_dato2,
    input [LEN-1:0] i_sign_extend,
    input [NB_CTRL_WB-1:0] i_ctrl_wb,
    input [NB_CTRL_MEM-1:0] i_ctrl_mem,
    input [NB_CTRL_EX-1:0] i_ctrl_ex, //JAL,Jump, JR, JALR,RegDst ,Jump,RegDst ,ALUSrc1(MUX de la entrada A de la ALU), ALUSrc2(MUX de la entrada B de la ALU) y alu_code(4)
    input [NB_ADDRESS_REGISTROS-1:0] i_rd,
    input [NB_ADDRESS_REGISTROS-1:0] i_rt,
    input [NB_ADDRESS_REGISTROS-1:0] i_shamt,
    input [1:0] i_ctrl_muxA_corto,
    input [1:0] i_ctrl_muxB_corto,
    input [LEN-1:0] i_rd_mem_corto,
    input [LEN-1:0] i_rd_wb_corto,
    input i_flush,
    output reg o_alu_zero,
    output reg [NB_ADDRESS_REGISTROS-1:0] o_write_reg,
    output reg [NB_CTRL_WB-1:0] o_ctrl_wb,
    output reg [NB_CTRL_MEM-1:0] o_ctrl_mem,
    output reg [LEN-1:0] o_pc_branch,    
    output reg [LEN-1:0] o_alu_result,
    output reg [LEN-1:0] o_dato2
   
); 

//Cables-Reg hacia/desde adder
wire [LEN-1:0] pc_branch;

//Cables-Reg hacia/desde mux
wire [LEN-1:0] mux_alu_B;
wire [LEN-1:0] mux_alu_A;
wire [LEN-1:0] mux_A;
wire [LEN-1:0] mux_B;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg;

//Cables-Reg hacia/desde alu
wire alu_zero;
wire [LEN-1:0] alu_result;

//Cables mux_cortocircuitos 
wire [LEN-1:0] mux_aluA_corto;
wire [LEN-1:0] mux_aluB_corto;
    
always @(negedge i_clk)
begin
    if(!i_rst | i_flush)
    begin
        o_pc_branch <= 32'b0;
        o_alu_result <= 32'b0;
        o_dato2 <= 32'b0;
        o_ctrl_wb <= 2'b0;
        o_ctrl_mem <= 9'b0;
        o_write_reg <= 5'b0;
        o_alu_zero <= 1'b0;
    end
    else
    begin
        o_pc_branch <= pc_branch;
        o_alu_result <= alu_result;
        o_dato2 <= i_dato2;
        o_ctrl_wb <= i_ctrl_wb;
        o_ctrl_mem <= i_ctrl_mem;
        o_write_reg <= write_reg;
        o_alu_zero <= alu_zero;
    end  
end


 mux_cortocircuito
 #(
    .LEN(LEN)
  )
  u_muxA_cortocircuito
  (
    .i_dato(i_dato1),
    .i_mem_corto(i_rd_mem_corto),
    .i_wb_corto(i_rd_wb_corto),  
    .i_selector(i_ctrl_muxA_corto),
    .o_mux(mux_aluA_corto)
  );
  
  mux_cortocircuito
 #(
    .LEN(LEN)
  )
  u_muxB_cortocircuito
  (
    .i_dato(i_dato2),
    .i_mem_corto(i_rd_mem_corto),
    .i_wb_corto(i_rd_wb_corto),  
    .i_selector(i_ctrl_muxB_corto),
    .o_mux(mux_aluB_corto)
  );
  
 mux
 #(
    .LEN(NB_ADDRESS_REGISTROS)
  )
  u_mux_execute
  (
    .i_a(i_rt),
    .i_b(i_rd),  
    .i_selector(i_ctrl_ex[6]),  //RegDst
    .o_mux(write_reg)
  );
    
adder
#(  
    .LEN(LEN)
)
u_add
(
    .i_a(i_adder_id),
    .i_b(i_sign_extend),
    .o_adder(pc_branch)
);

mux
#(  
    .LEN(LEN)
)
u_mux_datoA
(
    .i_a(mux_aluA_corto),
    .i_b({{(27){1'b0}},i_shamt}),
    .i_selector(i_ctrl_ex[5]), //AluScr1
    .o_mux(mux_A)   
);

mux
#(  
    .LEN(LEN)
)
u_mux_datoB
(
    .i_a(mux_aluB_corto),
    .i_b(i_sign_extend),
    .i_selector(i_ctrl_ex[4]), //AluScr2
    .o_mux(mux_B)   
);

mux
#(  
    .LEN(LEN)
)
u_mux_datoB_out
(
    .i_a(mux_B),
    .i_b(i_adder_id),
    .i_selector(i_ctrl_ex[10] | i_ctrl_ex[7]), //JAL
    .o_mux(mux_alu_B)   
);


mux
#(  
    .LEN(LEN)
)
u_mux_datoA_out
(
    .i_a(mux_A),
    .i_b(4'b1000),
    .i_selector(i_ctrl_ex[10]| i_ctrl_ex[7] ), //JAL o JALR
    .o_mux(mux_alu_A)   
);

alu
#(
    .NB_ALU_CONTROL(NB_ALU_CONTROL), 
    .LEN(LEN)
)
u_alu
(
    .i_datoA(mux_alu_A),
    .i_datoB(mux_alu_B),
    .i_opcode(i_ctrl_ex[NB_ALU_CONTROL-1:0]), //Control
    .o_result(alu_result),
    .o_zero_flag(alu_zero)    
);

endmodule
