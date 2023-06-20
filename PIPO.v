module PIPO(S, clk, O);
  input [3:0] S;
  input clk;
  output reg [3:0] O;
  
  always @ (posedge clk)
  begin
    O = S;
  end
  
endmodule
