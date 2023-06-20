module DFlipFlop(D, clk, clr,Q);
  input D, clk, clr; //setting the data pin and clock as input
  output reg Q;
  
  always @ (posedge clk)
  begin
    Q = D&(~clr);
  end
endmodule
