`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 11:17:26
// Design Name: 
// Module Name: ram_instrucciones
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


//NO CAMBIE NADA VER ENTERO


//  Xilinx Single Port No Change RAM
//  This code implements a parameterizable single-port no-change memory where when data is written
//  to the memory, the output remains unchanged.  This is the most power efficient write mode.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

module ram_instrucciones #(
  parameter RAM_WIDTH = 32,                       // Specify RAM data width
  parameter RAM_DEPTH = 2048,                    // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "LOW_LATENCY", // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
) (
  //input [clogb2(RAM_DEPTH-1)-1:0] i_addra,  // Address bus, width determined from RAM_DEPTH
  input [RAM_WIDTH-1:0] i_addra,
  input [RAM_WIDTH-1:0] i_dina,           // RAM input data
  input i_clka,                           // Clock
  input i_wea,                            // Write enable
  input i_ena,                            // RAM Enable, for additional power savings, disable port when not in use
  input i_rsta,                           // Output reset (does not affect memory contents)
  input i_regcea,                         // Output register enable
  output [RAM_WIDTH-1:0] o_douta,          // RAM output data
  output o_halt
);

  reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};
  
  assign o_halt = &BRAM[i_addra];
  
  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge i_clka)
    if (i_ena)
      if (i_wea)
        BRAM[i_addra] <= i_dina;
      else
        ram_data <= BRAM[i_addra];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign o_douta = ram_data;

    end else begin: output_register //NO SE USA

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

      always @(negedge i_clka)
        if (i_rsta)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (i_regcea)
          douta_reg <= ram_data;

      assign o_douta = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule

// The following is an instantiation template for xilinx_single_port_ram_no_change
/*
  //  Xilinx Single Port No Change RAM
  xilinx_single_port_ram_no_change #(
    .RAM_WIDTH(18),                       // Specify RAM data width
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .addra(addra),    // Address bus, width determined from RAM_DEPTH
    .dina(dina),      // RAM input data, width determined from RAM_WIDTH
    .clka(clka),      // Clock
    .wea(wea),        // Write enable
    .ena(ena),        // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rsta),      // Output reset (does not affect memory contents)
    .regcea(regcea),  // Output register enable
    .douta(douta)     // RAM output data, width determined from RAM_WIDTH
  );

*/
