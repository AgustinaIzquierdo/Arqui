`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2020 11:36:03
// Design Name: 
// Module Name: tb_instruction_memory_monociclo
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


module tb_instruction_memory_monociclo();

localparam len=32;
localparam NB_SENIAL_CONTROL = 8;

reg clk;
reg [len-1:0] i_address;
reg [len-1:0] i_write_data;
reg [NB_SENIAL_CONTROL-1:0] i_senial_control;
reg rsta_mem;
reg regcea_mem;
wire [len-1:0] o_read_data;

initial
begin
    clk = 1'b0;
    rsta_mem = 1'b0;
    regcea_mem =1'b1;
    
    #10 i_address=32'h00000003;    //LOAD
        i_write_data=32'h00000010;
        i_senial_control=8'b11011000;
    
    #10 i_address=32'h00000002;    //STORE
        i_write_data=32'h00000110;
        i_senial_control=8'b01100000;
    
    #500 $finish;
end


always #2.5 clk=~clk;


 ram_datos
    #(
        .RAM_WIDTH(len),
        .RAM_DEPTH(2048),        
        .RAM_PERFORMANCE("LOW_LATENCY"),
        .INIT_FILE("")        
     )
     u_ram_datos
     (
        .i_addra(i_address),
        .i_dina(i_write_data), //Ver de donde viene
        .i_clka(clk),
        .i_wea(i_senial_control[5]),  //Ver de donde viene
        .i_ena(i_senial_control[3]), //Ver de donde viene
        .i_rsta(rsta_mem),
        .i_regcea(regcea_mem), 
        .o_douta(o_read_data) 
     );

endmodule
