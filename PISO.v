module PISO(Reg, clk, O);
  input [2:0] Reg;
  input clk;
  output reg O;
  reg [2:0] data;
  
  initial
  begin
    data = Reg;
  end
  //loads data in the first rising edge as well, hence data starts from time 0;
  always @ (posedge clk)
  begin
  O = data[0];
  data[0] = data[1];
  data[1] = data[2];
  data[2] = 0;
  end
endmodule
