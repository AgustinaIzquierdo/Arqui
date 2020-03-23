`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 11:38:13
// Design Name: 
// Module Name: tl_memory
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


module tl_memory
    #(
        parameter LEN = 32,
        parameter NB_CTRL_WB = 2,
        parameter NB_CTRL_MEM = 9,
        parameter NB_ADDRESS_REGISTROS = 5
    )
    (
        input i_clk,
        input i_rst,
        input [LEN-1:0] i_address,
        input [LEN-1:0] i_write_data,
        input [NB_CTRL_WB-1:0] i_ctrl_wb,
        input [NB_CTRL_MEM-1:0] i_ctrl_mem, //BranchNotEqual, SB, SH, LB, LH, Unsigned , Branch , MemRead Y MemWrite
        input i_alu_zero,
        input [NB_ADDRESS_REGISTROS-1:0] i_write_reg,
        output reg [LEN-1:0] o_address,
        output reg [LEN-1:0] o_read_data,
        output reg [NB_ADDRESS_REGISTROS-1:0] o_write_reg,
        output reg [NB_CTRL_WB-1:0] o_ctrl_wb,
        output o_PCSrc
    );
    
//Cables-Reg hacia/desde memoria de datos    
wire rsta_mem;  
wire regcea_mem;
wire [LEN-1:0] read_data;
wire [LEN-1:0] write_data_mem;

//Control Memoria
assign rsta_mem =0;
assign regcea_mem=1;

//Control Mux Instruction Fetch
assign o_PCSrc = i_ctrl_mem[2] && i_alu_zero;

//assign o_read_data = read_data;

always @(negedge i_clk)
if(!i_rst)
begin
    o_address <= 32'b0;
    o_read_data <= 32'b0;
    o_write_reg <= 5'b0;
    o_ctrl_wb <= 2'b0;
end
else
begin
    o_address <= i_address;
    o_write_reg <= i_write_reg;
    o_ctrl_wb <= i_ctrl_wb;
    
    if(i_ctrl_mem[5]) //LB
    begin
        if(i_ctrl_mem[3]) //Unsigned
            o_read_data <= {{24{1'b0}},read_data[7:0]};
        else
            o_read_data <= {{24{read_data[7]}},read_data[7:0]};	
    end
    else if(i_ctrl_mem[4]) //LH
    begin
        if(i_ctrl_mem[3]) //Unsigned
            o_read_data <= {{16{1'b0}},read_data[15:0]};
        else
            o_read_data <= {{16{read_data[7]}},read_data[15:0]};	  
    end
    else //LW
        o_read_data <= read_data;
end
 
                        
assign write_data_mem = (i_ctrl_mem[6] ? {{16{i_write_data[15]}},i_write_data[15:0]}: //SH
                         i_ctrl_mem[7] ? {{24{i_write_data[15]}},i_write_data[7:0]}: //SB
                         i_write_data);
                        
ram_datos
#(
    .RAM_WIDTH(LEN),
    .RAM_DEPTH(2048),        
    .RAM_PERFORMANCE("LOW_LATENCY"),
    .INIT_FILE("")        
 )
 u_ram_datos
 (
    .i_addra(i_address),
    .i_dina(write_data_mem), 
    .i_clka(i_clk),
    .i_wea(i_ctrl_mem[0]),  
    .i_ena(i_ctrl_mem[1]), 
    .i_rsta(rsta_mem),
    .i_regcea(regcea_mem), 
    .o_douta(read_data) 
 );
 
endmodule
