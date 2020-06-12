`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2020 16:45:31
// Design Name: 
// Module Name: tb_top_mips
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


module tb_top_mips();
`define LEN 32
`define CANTIDAD_REGISTROS 32
`define NB_ADDRESS_REGISTROS $clog2(CANTIDAD_REGISTROS)
`define NB_SIGN_EXTEND  16
`define NB_INSTRUCCION  6
`define NB_ALU_CONTROL  4       
`define NB_ALU_OP  2
`define INIT_FILE_IM "" ///home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/ram_instruction.txt"

//Tamanio de los latches 
`define NB_IF_ID  65 //96
`define NB_ID_EX  204 //224
`define NB_EX_MEM  112 //128
`define NB_MEM_WB  72 //96

//Tamanio de los registros de control
`define NB_CTRL_WB  2
`define NB_CTRL_MEM  9
`define NB_CTRL_EX 11 

//Parametros
parameter LEN = `LEN;
parameter CANTIDAD_REGISTROS = `CANTIDAD_REGISTROS;
parameter NB_ADDRESS_REGISTROS = `NB_ADDRESS_REGISTROS;
parameter NB_SIGN_EXTEND = `NB_SIGN_EXTEND;
parameter NB_INSTRUCCION = `NB_INSTRUCCION;
parameter NB_ALU_CONTROL = `NB_ALU_CONTROL;
parameter NB_ALU_OP = `NB_ALU_OP;
parameter INIT_FILE_IM = `INIT_FILE_IM;

                                                            //(Ver si realmente son estos los tamanios)
parameter NB_IF_ID = `NB_IF_ID; 
parameter NB_ID_EX = `NB_ID_EX; 
parameter NB_EX_MEM = `NB_EX_MEM; 
parameter NB_MEM_WB = `NB_MEM_WB; 

                                                           //(Ver si realmente son estos los tamanios)
parameter NB_CTRL_WB = `NB_CTRL_WB; 
parameter NB_CTRL_MEM = `NB_CTRL_MEM; 
parameter NB_CTRL_EX = `NB_CTRL_EX; 

wire [NB_IF_ID-1:0] o_if_id;
wire [NB_ID_EX-1:0] o_id_ex;
wire [NB_EX_MEM-1:0] o_ex_mem;
wire [NB_MEM_WB-1:0] o_mem_wb;

//Cables hacia/desde instruction_fetch 
wire [LEN-1:0] branch_dir;
wire PCSrc;
wire [LEN-1:0] instruccion;
wire [LEN-1:0] out_adder_if_id;
wire [LEN-1:0] contador_programa;
wire flag_halt;

//Cables hacia/desde instruction_decode 
wire [LEN-1:0] write_data_banco_reg;
wire [LEN-1:0] out_adder_id_ex;
wire [NB_ADDRESS_REGISTROS-1:0] rs;
wire [NB_ADDRESS_REGISTROS-1:0] rd;
wire [NB_ADDRESS_REGISTROS-1:0] rt;
wire [NB_ADDRESS_REGISTROS-1:0] shamt;
wire [LEN-1:0] dato1;
wire [LEN-1:0] dato2_if_ex;
wire [LEN-1:0] sign_extend;
wire [NB_CTRL_WB-1:0] ctrl_wb_id_ex;
wire [NB_CTRL_MEM-1:0] ctrl_mem_id_ex;
wire [NB_CTRL_EX-1:0] ctrl_ex_id_ex;
wire flag_stall;
wire [LEN-1:0] dir_jump;
wire flag_jump;

//Cables hacia/desde execute 
wire [LEN-1:0] dato2_ex_mem;
wire [LEN-1:0] result_alu_ex_mem;
wire alu_zero;
wire [NB_CTRL_WB-1:0] ctrl_wb_ex_mem;
wire [NB_CTRL_MEM-1:0] ctrl_mem_ex_mem;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_ex_mem;

//Cables hacia/desde memoria
wire [LEN-1:0] result_alu_mem_wb;
wire [LEN-1:0] read_data_memory;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_mem_wb;
wire [NB_CTRL_WB-1:0] ctrl_wb_mem_wb;

//Cables hacia/desde wb
wire regwrite_wb_id;
wire [NB_ADDRESS_REGISTROS-1:0] write_reg_wb_id;

//Cables hacia/desde Unidad de cortocircuito
wire [1:0] ctrl_muxA_corto;
wire [1:0] ctrl_muxB_corto;

reg i_rst;
wire i_clk;

//CARGAR LA MEMORIA DE INSTRUCCIONES
reg wea_mem_instr;
reg [LEN-1:0] dir_mem_instr;
integer ram_instruct,error1;
reg [LEN-1:0] cont;

//SACAR DATOS
integer wr_latch_if_id, wr_latch_id_ex, wr_latch_ex_mem, wr_latch_mem_wb, wr_cant_clock;

//CANTIDAD DE CLOCK
reg [LEN-1:0] cant_clock;
reg [3-1:0] cuentita;
reg flag;

//MODO DE OPERACION
reg mode;   //Si es 0 es Step by step y si es 1 es continuo
reg i_clk2;
reg enable_mode; //Si esta en 1 habilita el modo en el que esta

//ARCHIVO PARA STEP BY STEP
integer archivo_step,error2;
reg cable_enable_mode;

initial
begin
   // i_clk = 1'b0;
    i_clk2 = 1'b0;
    i_rst = 1'b0;
    cont = 32'hffffffff;
    wea_mem_instr = 1'b1;
    
    mode = 1'b1; //Continuo(1) Step(0)
    
    ram_instruct=$fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/ram_instruction.txt","r");
        if(ram_instruct==0) $stop;
    archivo_step=$fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/step.txt","r");
        if(archivo_step==0) $stop;   
    wr_latch_if_id = $fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/if_id.txt", "w");
       if(wr_latch_if_id==0) $stop;
    wr_latch_id_ex = $fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/id_ex.txt", "w");
       if(wr_latch_id_ex==0) $stop;
    wr_latch_ex_mem = $fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/ex_mem.txt", "w");
       if(wr_latch_ex_mem==0) $stop;
    wr_latch_mem_wb = $fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/mem_wb.txt", "w");
       if(wr_latch_mem_wb==0) $stop;
   wr_cant_clock = $fopen("/home/andres/Facultad/Arquitectura_de_Computadoras/Andres/Arqui/MIPS/Source/Script/cant_clock.txt", "w");
       if(wr_cant_clock==0) $stop;        
    
    #150 $finish;
end

always #2.5 i_clk2=~i_clk2;

assign i_clk = !i_rst? i_clk2 : enable_mode ? flag ? 1'b0 : i_clk2 : 1'b0;

always @(negedge i_clk2)
begin
    if(!i_rst)
    begin
        cont <= cont + 1'b1;
        error1<=$fscanf(ram_instruct,"%h",dir_mem_instr);
            if(error1!=1) 
            begin
                $stop;
                i_rst <= 1'b1;
                wea_mem_instr <= 1'b0;
            end
    end
    else
        cont <= cont;
end

always @(negedge i_clk)
begin
    if(i_rst)
    begin
        if(!flag && (enable_mode==1'b1))
        begin
            $fwrite(wr_latch_if_id, "%b\n", o_if_id);
            $fwrite(wr_latch_id_ex, "%b\n", o_id_ex);
            $fwrite(wr_latch_ex_mem, "%b\n", o_ex_mem);
            $fwrite(wr_latch_mem_wb, "%b\n", o_mem_wb);
            $fwrite(wr_cant_clock, "%b\n", cant_clock);
        end
    end
end

always @(negedge i_clk2)
begin
    if(!i_rst)
    begin
        enable_mode<=1'b0;
    end
    else
    begin
        if(mode == 1'b1) //continuo
        begin
            enable_mode <= mode;
        end
        else
        begin //step_by_step
            error2<=$fscanf(archivo_step,"%b",cable_enable_mode);
            if(error2!=1) 
                $stop;
            else
                enable_mode<=cable_enable_mode;
        end
    end
end

always @(negedge i_clk2)
begin
    if(!i_rst)
    begin
        cant_clock <= 32'b0;
        cuentita <= 2'b0;
        flag <= 1'b0;
    end
    else
    begin
        if(enable_mode==1'b1)
        begin
            if(flag_halt && flag!=1'b1)  //ACA PONDRIA OTRA MAQUINA QUE DEPENDIENDO UN FLAG ESTO SE HAGA SIEMPRE QUE SERIA EL CONTINUO O A PARTIR DE LA LECTURA DE UN ARCHIVO.
            begin                        //DIGAMOS A DEMAS DE CONTROLAR TODO ESTO DEBERIAMOS CONTROLAR EL CLOCK DEL SISTEMA
                cuentita<= cuentita + 1'b1; // EN CASO DE SER CONTINUO QUE TOME SIEMPRE EL CLOCK PERO EN CASO DE NO SERLO QUE SERIA EL STEP BY STEP QUE LO HAGA LEYENDO UN ARCHIVO SUPONGO
            end                             //USAR DOS CLOCK SUPONGO.
            else
                cuentita <= cuentita;
            
            if(cuentita >= 3'b100)
            begin
                cant_clock<= cant_clock;
                flag <= 1'b1;               //OTRA COSA A PROBAR ES SI EL FLAG ES 1 EL CLOCK DEBERIA PARARSE Y NO SEGUIR EJECUTANDO
            end
            else
            begin
                cant_clock<= cant_clock + 1'b1;
                flag <= flag;
            end
        end
        else
        begin
            cuentita <= cuentita;
            cant_clock <= cant_clock;
            flag <= flag;
        end
    end
end


//Instruction fetch
tl_instruction_fetch
#(
    .LEN(LEN),
    .INIT_FILE_IM(INIT_FILE_IM)
)
    u_tl_instruction_fetch
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_branch_dir(branch_dir),
    .i_PCSrc(PCSrc),
    .i_flag_stall(flag_stall),
    .i_flag_jump(flag_jump),
    .i_dir_jump(dir_jump),
    .i_dir_mem_instr(dir_mem_instr),
    .i_wea_mem_instr(wea_mem_instr),
    .i_addr_mem_inst(cont),
    .o_instruccion(instruccion),
    .o_adder(out_adder_if_id),
    .o_contador_programa(contador_programa), //DEBUG_UNIT
    .o_flag_halt(flag_halt)
);

//Instruction decode
tl_instruction_decode
#(
    .LEN(LEN),
    .CANTIDAD_REGISTROS(CANTIDAD_REGISTROS),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS),
    .NB_SIGN_EXTEND(NB_SIGN_EXTEND),
    .NB_INSTRUCCION(NB_INSTRUCCION),    
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ALU_OP(NB_ALU_OP)
)
    u_tl_instruction_decode
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_instruccion(instruccion),
    .i_write_data(write_data_banco_reg),
    .i_write_reg(write_reg_wb_id),
    .i_adder_pc(out_adder_if_id),
    .i_RegWrite(regwrite_wb_id),
    .i_flush(PCSrc), 
    .o_adder_pc(out_adder_id_ex), 
    .o_rs(rs),
    .o_rd(rd),
    .o_rt(rt),    
    .o_shamt(shamt),   
    .o_dato1(dato1),
    .o_dato2(dato2_if_ex),
    .o_sign_extend(sign_extend),
    .o_ctrl_wb(ctrl_wb_id_ex), //RegWrite Y MemtoReg
    .o_ctrl_mem(ctrl_mem_id_ex), //BranchNotEqual, SB, SH, LB, LH, Unsigned , Branch , MemRead Y MemWrite
    .o_ctrl_ex(ctrl_ex_id_ex), //JAL,Jump, JR, JALR,RegDst ,Jump,RegDst ,ALUSrc1(MUX de la entrada A de la ALU), ALUSrc2(MUX de la entrada B de la ALU) y alu_code(4)
    .o_flag_stall(flag_stall),
    .o_dir_jump(dir_jump),
    .o_flag_jump(flag_jump)
);

//Execute
tl_execute
#(
    .LEN(LEN),
    .NB_ALU_CONTROL(NB_ALU_CONTROL),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_CTRL_EX(NB_CTRL_EX)
    
)
    u_tl_execute
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_adder_id(out_adder_id_ex),
    .i_dato1(dato1),
    .i_dato2(dato2_if_ex),
    .i_sign_extend(sign_extend),
    .i_ctrl_wb(ctrl_wb_id_ex),
    .i_ctrl_mem(ctrl_mem_id_ex),
    .i_ctrl_ex(ctrl_ex_id_ex),
    .i_rd(rd),
    .i_rt(rt),
    .i_shamt(shamt),
    .i_ctrl_muxA_corto(ctrl_muxA_corto),
    .i_ctrl_muxB_corto(ctrl_muxB_corto),
    .i_rd_mem_corto(result_alu_ex_mem),
    .i_rd_wb_corto(write_data_banco_reg),
    .i_flush(PCSrc),
    .o_alu_zero(alu_zero),
    .o_write_reg(write_reg_ex_mem),
    .o_ctrl_wb(ctrl_wb_ex_mem),
    .o_ctrl_mem(ctrl_mem_ex_mem),
    .o_pc_branch(branch_dir),
    .o_alu_result(result_alu_ex_mem),
    .o_dato2(dato2_ex_mem)
);

//Memory
tl_memory
#(
    .LEN(LEN),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_CTRL_MEM(NB_CTRL_MEM),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)

)
    u_tl_memory
(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_address(result_alu_ex_mem),
    .i_write_data(dato2_ex_mem),
    .i_ctrl_wb(ctrl_wb_ex_mem),
    .i_ctrl_mem(ctrl_mem_ex_mem),
    .i_alu_zero(alu_zero),
    .i_write_reg(write_reg_ex_mem),
    .o_address(result_alu_mem_wb),  
    .o_read_data(read_data_memory),
    .o_write_reg(write_reg_mem_wb),
    .o_ctrl_wb(ctrl_wb_mem_wb),
    .o_PCSrc(PCSrc) //Branch, indica si se hace el flush
);

//Write Back
tl_write_back
#(
    .LEN(LEN),
    .NB_CTRL_WB(NB_CTRL_WB),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)
  
)
    u_tl_write_back
(
    .i_read_data(read_data_memory),
    .i_result_alu(result_alu_mem_wb),
    .i_ctrl_wb(ctrl_wb_mem_wb),
    .i_write_reg(write_reg_mem_wb),
    .o_write_data(write_data_banco_reg),
    .o_write_reg(write_reg_wb_id),
    .o_RegWrite(regwrite_wb_id)
);

unidad_cortocircuito
#(
    .LEN(LEN),
    .NB_ADDRESS_REGISTROS(NB_ADDRESS_REGISTROS)
)
u_unidad_corto
(
   .i_rs_id_ex(rs),
   .i_rt_id_ex(rt),
   .i_write_reg_ex_mem(write_reg_ex_mem),
   .i_write_reg_mem_wb(write_reg_wb_id), 
   .i_reg_write_ex_mem(ctrl_wb_ex_mem[1]),
   .i_reg_write_mem_wb(regwrite_wb_id),
   .o_muxA_alu(ctrl_muxA_corto),
   .o_muxB_alu(ctrl_muxB_corto)
);

//Latches intermedios
assign o_if_id = {
                  contador_programa, //32 bits
                  instruccion, //32 bits
                 // {31{1'b0}},
                  flag_halt}; //1bit

assign o_id_ex = { 
                  // {10{1'b0}},
                   ctrl_wb_id_ex,  //2bits
                   ctrl_mem_id_ex, //9bits
                   ctrl_ex_id_ex,  //11 bits
                   //{12{1'b0}},
                   shamt, //5 bits
                   rs,  //5 bits
                   rt,  //5 bits
                   rd,   //5 bits
                   out_adder_id_ex, //32 bits
                   dir_jump,         //32bits 
                   sign_extend,      //32 bits
                   dato1,            //32 bits
                   dato2_if_ex,       //32 bits
                   flag_stall,        //1 bit
                   flag_jump          //1 bit
                  };   
                   
assign o_ex_mem = {
                  // {15{1'b0}},
                   ctrl_wb_ex_mem, //2bits
                   ctrl_mem_ex_mem, //9bits
                   write_reg_ex_mem, //5bit
                   branch_dir,//32 bits
                   result_alu_ex_mem,//32 bits
                   dato2_ex_mem //32 bits
                   };

assign o_mem_wb = {
                 //  {25{1'b0}},
                   PCSrc, //1bit
                   ctrl_wb_mem_wb, //2 bits
                   write_reg_mem_wb, //5 bits
                   result_alu_mem_wb,//32 bits
                   read_data_memory //32 bits
                   };


endmodule
