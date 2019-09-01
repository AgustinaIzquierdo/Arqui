// Code your testbench here
// or browse Examples
module testb_ALU();
    //local parameters
    localparam  NB_DATA_01    =  5;
    localparam  NB_OPERADOR_01   =  6;
    //Inputs
  reg  signed       [NB_DATA_01-1:0]        i_data_bus_a;
  reg  signed       [NB_DATA_01-1:0]        i_data_bus_b;
  reg         [NB_OPERADOR_01-1:0]    i_data_operador;
    //Outputs
  	wire        [NB_DATA_01-1:0]        o_data_resultado;


    initial begin
      #0
      i_data_bus_a  ={NB_DATA_01{1'b0}};
      i_data_bus_b  ={NB_DATA_01{1'b0}};
      i_data_operador  ={NB_OPERADOR_01{1'b0}};
      #1000
      $finish;
    end // initial

    always begin
      #100
      i_data_bus_a = 5'b00101;
      i_data_bus_b = 5'b01010;
      i_data_operador = 6'b100000; //ADD
      #100
      i_data_bus_a = 5'b00110;
      i_data_bus_b = 5'b00111;
      i_data_operador = 6'b100010; //SUB
      #100
      i_data_bus_a = 5'b10101;
      i_data_bus_b = 5'b00111;
      i_data_operador = 6'b100100; //AND
      #100
      i_data_bus_a = 5'b11001;
      i_data_bus_b = 5'b01011;
      i_data_operador = 6'b100101; //OR
      #100
      i_data_bus_a = 5'b11111;
      i_data_bus_b = 5'b01101;
      i_data_operador = 6'b100110; //XOR
      #100
      i_data_bus_a = 5'b00110;
      i_data_bus_b = 5'b10001;
      i_data_operador =6'b100111; //NOR
      #100
      i_data_bus_a = 5'b10110;
      i_data_bus_b = 5'b11;
      i_data_operador =6'b000011; //SRA
      #100
      i_data_bus_a = 5'b11010;
      i_data_bus_b = 5'b11;
      i_data_operador =6'b000010; //SRL
    end

    ALU  
    #(
      .NB_DATA           (NB_DATA_01),
      .NB_OPERADOR          (NB_OPERADOR_01)
     )
    u_alu_01
    (
      .i_dato_a       (i_data_bus_a),
      .i_dato_b       (i_data_bus_b),
      .i_operador (i_data_operador),
      .o_resultado (o_data_resultado)
    );

endmodule