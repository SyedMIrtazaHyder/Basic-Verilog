module SIPO(I, clk, S);
  input I, clk;
  output reg[1:0] S;
  reg delay;
  
  //need a trigger for storing data
  //so we can assume it to be the value 1
  
  always @ (posedge clk)
  begin
    S[1] = S[0];
    S[0] = I;
  end
            
endmodule
