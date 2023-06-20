module TFlipFlop(T, clk, Q);
  input T, clk;
  output reg Q;
  
  initial
  Q = 1;
  
  always @ (posedge clk)
  begin
      Q = Q^T;
      //as if T = 0, Q = Q but if T = 1, if Q = 0 then it becomes 1 and if Q = 1 then 1XOR1 = 0
  end
  
endmodule
